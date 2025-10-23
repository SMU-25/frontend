import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/core/const/base_url.dart';
import 'package:team_project_front/core/utils/secure_storage_service.dart';

// 컨텍스트 없이도 화면 전환을 하기 위한 글로벌 키
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 동시 refresh 방지 게이트
class _RefreshGate {
  // 현재 refresh 중인지 여부 플래그
  bool _refreshing = false;
  // 다른 요청들이 refresh 완료를 기다릴 수 있도록 하는 Completer
  Completer<void>? _c;
  Future<void> run(Future<void> Function() job) async {
    if (_refreshing) return _c!.future;
    _refreshing = true;
    _c = Completer<void>();
    try {
      await job();
      _c!.complete();
    } catch (e) {
      _c!.completeError(e);
      rethrow;
    } finally {
      _refreshing = false;
    }
  }
}

final _refreshGate = _RefreshGate();

Future<TokenPair?> _refreshTokens() async {
  final refresh = await SecureStorageService.getRefreshToken();
  if (refresh == null) return null;
  final refreshDio = Dio(
    BaseOptions(baseUrl: base_URL, connectTimeout: const Duration(seconds: 10)),
  );
  final res = await refreshDio.post(
    '/auth/refresh',
    data: {'refreshToken': refresh},
    options: Options(validateStatus: (_) => true),
  );
  if (res.statusCode == 200) {
    final result = res.data['result'] as Map<String, dynamic>;
    final newAccess = result['accessToken'] as String;
    final newRefresh = (result['refreshToken'] as String?) ?? refresh;
    await SecureStorageService.saveAccessToken(newAccess);
    await SecureStorageService.saveRefreshToken(newRefresh);
    return TokenPair(newAccess, newRefresh);
  }
  return null;
}

class TokenPair {
  final String access;
  final String refresh;
  TokenPair(this.access, this.refresh);
}

Dio buildAuthedDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: base_URL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.clear();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // refresh 호출은 건너뜀
        final isRefreshCall = options.path.contains('/auth/refresh');
        if (!isRefreshCall) {
          final at = await SecureStorageService.getAccessToken();
          if (at != null) {
            options.headers['Authorization'] = 'Bearer $at';
          }
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final res = error.response;
        final req = error.requestOptions;

        // 이미 재시도한 요청이면 통과 (무한루프 방지)
        if (req.extra['retried'] == true) return handler.next(error);

        // 401이면 만료로 간주(가능하면 서버 code도 함께 체크)
        final isExpired = res?.statusCode == 401;

        if (isExpired) {
          try {
            await _refreshGate.run(() async {
              final pair = await _refreshTokens();
              if (pair == null) {
                await SecureStorageService.clearTokens();
                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  '/login',
                  (r) => false,
                );
                throw DioException(
                  requestOptions: req,
                  error: 'refresh failed',
                );
              }
            });

            // 새 토큰으로 원요청 재시도
            final newAccess = await SecureStorageService.getAccessToken();
            final newReq = _cloneWithNewToken(req, newAccess);
            final resp = await dio.fetch(newReq);
            return handler.resolve(resp);
          } catch (_) {
            // refresh 실패 → 원 에러 전달
            return handler.next(error);
          }
        }

        handler.next(error);
      },
    ),
  );

  return dio;
}

RequestOptions _cloneWithNewToken(RequestOptions req, String? access) {
  final headers = Map<String, dynamic>.from(req.headers);
  if (access != null) headers['Authorization'] = 'Bearer $access';

  return RequestOptions(
    path: req.path,
    method: req.method,
    baseUrl: req.baseUrl,
    data: req.data,
    queryParameters: req.queryParameters,
    headers: headers,
    connectTimeout: req.connectTimeout,
    sendTimeout: req.sendTimeout,
    receiveTimeout: req.receiveTimeout,
    extra: Map<String, dynamic>.from(req.extra)..['retried'] = true,
    contentType: req.contentType,
    responseType: req.responseType,
    followRedirects: req.followRedirects,
    listFormat: req.listFormat,
  );
}
