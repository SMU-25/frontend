import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/map/model/naver_place.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  NaverMapController? _mapController;
  bool _skipNextMapTap = false;

  late Future<NOverlayImage> _hospitalIconF;
  late Future<NOverlayImage> _searchIconF;
  static const NLatLng _fallback = NLatLng(37.5666, 126.9790);

  bool _isLoading = false;

  final List<NMarker> _hospitalMarkers = [];
  final List<NMarker> _searchMarkers = [];

  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  Timer? _debouncer;
  List<NaverPlace> _searchResults = [];

  NaverPlace? _selectedPlace;

  double _toCoord(String s) => double.parse(s) / 1e7;

  Future<Position?> _getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) return null;
    }
    if (perm == LocationPermission.deniedForever) return null;

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<List<NaverPlace>> fetchNearbyHospitalsNaver({
    required double lat,
    required double lng,
    int display = 20,
  }) async {
    final dio = Dio(
      BaseOptions(
        headers: {
          'X-Naver-Client-Id': 'KWi9VShsCyUlGL54hJyX',
          'X-Naver-Client-Secret': 'uzVmuAa2lG',
        },
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );

    final res = await dio.get(
      'https://openapi.naver.com/v1/search/local.json',
      queryParameters: {
        'query': '소아과',
        'display': display.toString(),
        'start': '1',
        'sort': 'random',
        'coordinate': '$lng,$lat',
      },
    );
    final items = (res.data['items'] as List?) ?? const [];

    return items.map((e) {
      final m = e as Map<String, dynamic>;
      final name = (m['title'] as String).replaceAll(RegExp(r'<\/?b>'), '');
      final mapx = m['mapx'] as String;
      final mapy = m['mapy'] as String;
      return NaverPlace(
        id: '${m['link'] ?? ''}_${mapx}_$mapy',
        name: name,
        lng: _toCoord(mapx),
        lat: _toCoord(mapy),
        phone: m['telephone'] as String?,
        roadAddress: m['roadAddress'] as String?,
      );
    }).toList();
  }

  Future<List<NaverPlace>> _searchPlacesNaver(
    String query, {
    required double lat,
    required double lng,
  }) async {
    if (query.isEmpty) {
      return [];
    }
    final dio = Dio(
      BaseOptions(
        headers: {
          'X-Naver-Client-Id': 'KWi9VShsCyUlGL54hJyX',
          'X-Naver-Client-Secret': 'uzVmuAa2lG',
        },
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );

    try {
      final res = await dio.get(
        'https://openapi.naver.com/v1/search/local.json',
        queryParameters: {
          'query': query,
          'display': '10',
          'start': '1',
          'sort': 'random',
          'coordinate': '$lng,$lat',
        },
      );
      final items = (res.data['items'] as List?) ?? const [];
      return items.map((e) {
        final m = e as Map<String, dynamic>;
        final name = (m['title'] as String).replaceAll(RegExp(r'<\/?b>'), '');
        final mapx = m['mapx'] as String;
        final mapy = m['mapy'] as String;
        return NaverPlace(
          id: '${m['link'] ?? ''}_${mapx}_$mapy',
          name: name,
          lng: _toCoord(mapx),
          lat: _toCoord(mapy),
          phone: m['telephone'] as String?,
          roadAddress: m['roadAddress'] as String?,
        );
      }).toList();
    } on DioException catch (e) {
      debugPrint(
        'Naver API search error: ${e.response?.statusCode} ${e.response?.data}',
      );
      return [];
    }
  }

  void _onSearchChanged(String query, double lat, double lng) {
    if (_debouncer?.isActive ?? false) _debouncer!.cancel();
    _debouncer = Timer(const Duration(milliseconds: 500), () async {
      final results = await _searchPlacesNaver(query, lat: lat, lng: lng);
      setState(() {
        _searchResults = results;
      });
      await _updateSearchMarkers(results);
    });
  }

  Future<void> _onSelectPlace(NaverPlace place) async {
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(place.lat, place.lng),
        zoom: 15,
      ),
    );
    setState(() {
      _searchResults = [];
      _searchFocusNode.unfocus();

      _selectedPlace = place;
    });
    final hasMarker = _searchMarkers.any(
      (m) => m.info.id == 'srch_${place.id}',
    );
    if (!hasMarker) {
      await _updateSearchMarkers([place]);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hospitalIconF = NOverlayImage.fromWidget(
      context: context,
      widget: const Icon(Icons.add_circle, color: MAIN_COLOR, size: 40),
      size: const Size(40, 40),
    );
    _searchIconF = NOverlayImage.fromWidget(
      context: context,
      widget: const Icon(Icons.place, color: Colors.blueAccent, size: 36),
      size: const Size(36, 36),
    );
  }

  Future<void> _clearSearchMarkers() async {
    if (_mapController == null) return;
    for (final m in _searchMarkers) {
      await _mapController!.deleteOverlay(m.info);
    }
    _searchMarkers.clear();
  }

  Future<void> _updateSearchMarkers(List<NaverPlace> results) async {
    if (_mapController == null) return;
    // 기존 검색 마커 제거
    await _clearSearchMarkers();

    // 아이콘 준비
    final icon = await _searchIconF;

    // 새 검색 마커 추가
    for (final p in results) {
      final marker = NMarker(
        id: 'srch_${p.id}',
        position: NLatLng(p.lat, p.lng),
        icon: icon,
        anchor: const NPoint(0.5, 1.0),
        caption: NOverlayCaption(text: p.name, minZoom: 14),
        isHideCollidedSymbols: true,
      );

      // 마커 탭 시 상세 패널 노출 + 카메라 살짝 이동
      marker.setOnTapListener((overlay) async {
        if (!mounted) return;
        _skipNextMapTap = true;
        setState(() {
          _selectedPlace = p;
        });
        await _mapController?.updateCamera(
          NCameraUpdate.scrollAndZoomTo(
            target: NLatLng(p.lat, p.lng),
            zoom: 15,
          ),
        );
      });

      _mapController!.addOverlay(marker);
      _searchMarkers.add(marker);
    }
  }

  Future<void> _showHospitalsNearMe() async {
    if (_mapController == null) return;

    setState(() => _isLoading = true);
    try {
      final pos = await _getCurrentPosition();
      final here =
          (pos != null) ? NLatLng(pos.latitude, pos.longitude) : _fallback;

      await _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(target: here, zoom: 15),
      );

      final hospitals = await fetchNearbyHospitalsNaver(
        lat: here.latitude,
        lng: here.longitude,
        display: 20,
      );

      for (final m in _hospitalMarkers) {
        await _mapController?.deleteOverlay(m.info); // ✅ NOverlayInfo 전달
      }

      _hospitalMarkers.clear();

      final hospitalIcon = await _hospitalIconF;

      for (final h in hospitals) {
        final m = NMarker(
          id: h.id,
          position: NLatLng(h.lat, h.lng),
          icon: hospitalIcon,
          anchor: const NPoint(0.5, 1.0),
          caption: NOverlayCaption(text: h.name, minZoom: 14),
          isHideCollidedSymbols: true,
        );
        _mapController!.addOverlay(m);
        _hospitalMarkers.add(m);
      }

      final overlay = _mapController!.getLocationOverlay();
      overlay.setIsVisible(true);
      overlay.setPosition(here);
    } on DioException catch (e) {
      debugPrint(
        'Naver API error: ${e.response?.statusCode} ${e.response?.data}',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('병원 데이터를 불러오지 못했습니다.')));
    } catch (e) {
      debugPrint('Unexpected: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('오류가 발생했습니다.')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('전화를 걸 수 없습니다.')));
    }
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaPadding = MediaQuery.paddingOf(context);

    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              contentPadding: safeAreaPadding,
              initialCameraPosition: const NCameraPosition(
                target: _fallback,
                zoom: 14,
              ),
              locationButtonEnable: false,
              indoorEnable: true,
            ),
            onMapReady: (controller) async {
              _mapController = controller;

              final pos = await _getCurrentPosition();
              final here =
                  (pos != null)
                      ? NLatLng(pos.latitude, pos.longitude)
                      : _fallback;

              await controller.updateCamera(
                NCameraUpdate.scrollAndZoomTo(target: here, zoom: 14),
              );

              final overlay = controller.getLocationOverlay();
              overlay.setIsVisible(true);
              overlay.setPosition(here);
            },
            onMapTapped: (point, latLng) {
              if (_skipNextMapTap) {
                _skipNextMapTap = false;
                return;
              }
              if (_searchFocusNode.hasFocus) {
                _searchFocusNode.unfocus();
              }
              // 지도 탭 시 UI 닫기
              setState(() {
                _selectedPlace = null;
              });
            },
          ),

          // 검색창 및 검색 결과 리스트
          Positioned(
            top: 16 + safeAreaPadding.top,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // 검색창
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (query) {
                      _onSearchChanged(
                        query,
                        _fallback.latitude,
                        _fallback.longitude,
                      );
                    },
                    decoration: InputDecoration(
                      hintText: '원하는 장소를 검색하세요',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchResults = [];
                                  });
                                },
                              )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                // 검색 결과 리스트
                if (_searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero, // 리스트 자체 패딩 제거
                      itemCount: _searchResults.length,
                      separatorBuilder:
                          (_, __) => const Divider(height: 1, thickness: 0.5),
                      itemBuilder: (context, index) {
                        final place = _searchResults[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(
                            12,
                            8,
                            12,
                            8,
                          ),
                          minLeadingWidth: 0,
                          leading: const SizedBox(width: 0),
                          // 텍스트 정리
                          title: Text(
                            place.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            place.roadAddress ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          onTap: () => _onSelectPlace(place),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // 로딩 오버레이
          if (_isLoading)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: false,
                child: Container(
                  color: Colors.black45,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),

          // 하단 우측 “현 위치에서 병원 보기” 버튼
          Positioned(
            right: 16,
            bottom: 150 + safeAreaPadding.bottom,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _showHospitalsNearMe,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          // 선택된 병원 정보 UI
          if (_selectedPlace != null)
            Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedPlace!.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.favorite_border, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Text(
                      _selectedPlace!.roadAddress ?? '주소 정보 없음',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (_selectedPlace!.phone != null &&
                        _selectedPlace!.phone!.isNotEmpty)
                      InkWell(
                        onTap: () => _makePhoneCall(_selectedPlace!.phone!),
                        child: Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              _selectedPlace!.phone!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
