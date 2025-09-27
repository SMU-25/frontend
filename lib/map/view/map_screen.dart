import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:team_project_front/map/model/place.dart';
import 'package:url_launcher/url_launcher.dart';

// REST 키 (검색 API용)
const kakaoRestKey = String.fromEnvironment('KAKAO_REST_API_KEY');

void _validateKakaoRestKey() {
  if (kakaoRestKey == '') {
    throw Exception(" Kakao REST API 키가 주입되지 않았습니다. --dart-define으로 전달해주세요.");
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  KakaoMapController? _controller;
  bool _loading = false;

  LatLng _center = const LatLng(37.6026, 126.9553);

  // 검색
  final _searchCtl = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debouncer;

  // 결과 / 선택
  List<Place> _places = [];
  Place? _selected;

  final PoiStyle _poiStyle = PoiStyle(
    icon: KImage.fromAsset("asset/img/map/pin.png", 20, 20),
  );
  // 검색 결과 리스트 표시 여부
  bool _showResults = false;
  // 재 지도에 올라간 Poi 관리
  final List<Poi> _poiList = [];

  @override
  void initState() {
    super.initState();
    _validateKakaoRestKey();
    _initCurrentLocation();
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    _searchCtl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _initCurrentLocation() async {
    setState(() => _loading = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) return;
      }
      if (perm == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      _center = LatLng(pos.latitude, pos.longitude);

      // 초기 자동 검색
      await _searchByKeyword('소아청소년과', near: _center, size: 14);
      await _moveCamera(_center, 14);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _moveCamera(LatLng target, int zoom) async {
    final c = _controller;
    if (c == null) return;
    await c.moveCamera(CameraUpdate.newCenterPosition(target, zoomLevel: zoom));
  }

  void _onChanged(String q) {
    if (_debouncer?.isActive ?? false) _debouncer!.cancel();
    _debouncer = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      final cam = await _controller?.getCameraPosition();
      final center = cam?.position ?? _center;
      setState(() => _showResults = q.trim().isNotEmpty);
      await _searchByKeyword(q.trim(), near: center);
    });
  }

  /// 카카오 로컬 API로 장소 검색 → 리스트/POI 반영
  Future<void> _searchByKeyword(
    String query, {
    required LatLng near,
    int size = 14,
  }) async {
    if (query.isEmpty) {
      setState(() {
        _places = [];
        _selected = null;
      });
      // 기존 POI 숨김/정리
      await _hideAllPoi();
      return;
    }

    setState(() => _loading = true);
    try {
      final dio = Dio(
        BaseOptions(headers: {'Authorization': 'KakaoAK $kakaoRestKey'}),
      );

      final res = await dio.get(
        'https://dapi.kakao.com/v2/local/search/keyword.json',
        queryParameters: {
          'query': query,
          'y': near.latitude.toString(),
          'x': near.longitude.toString(),
          'radius': '5000',
          'size': size.toString(),
          'sort': 'accuracy',
        },
      );

      final docs = (res.data['documents'] as List?) ?? const [];
      final places = docs
          .map((e) => Place.fromJson(e as Map<String, dynamic>))
          .toList();

      // 지도에 표시된 기존 POI 숨기고 새로 그리기
      await _hideAllPoi();
      await _drawPois(places);

      setState(() {
        _places = places;
        if (places.isNotEmpty) _selected = places.first;
      });
    } on DioException catch (e) {
      debugPrint(
        'Kakao search error: ${e.response?.statusCode} ${e.response?.data}',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('검색에 실패했습니다.')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// 기존 POI 전체 숨김
  Future<void> _hideAllPoi() async {
    final c = _controller;
    if (c == null) return;
    // SDK가 removeAllPoi() 를 제공하지 않는 버전도 있어 hide로 처리
    await c.labelLayer.hideAllPoi();
  }

  /// 검색 결과를 POI로 지도에 표시
  Future<void> _drawPois(List<Place> places) async {
    final c = _controller;
    if (c == null) return;

    for (final poi in _poiList) {
      await c.labelLayer.removePoi(poi);
    }
    _poiList.clear();

    for (final p in places) {
      final poi = await c.labelLayer.addPoi(
        LatLng(p.latitude, p.longitude),
        id: p.id,
        text: p.placeName,
        style: _poiStyle,
        visible: true,
        onClick: () {
          if (!mounted) return;
          setState(() {
            _selected = p;
            _showResults = false;
          });
        },
      );
      _poiList.add(poi); // 리스트에 Poi 저장
    }
  }

  Future<void> _call(String number) async {
    final clean = number.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri(scheme: 'tel', path: clean);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('전화 앱을 열 수 없어요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);

    return Scaffold(
      body: Stack(
        children: [
          KakaoMap(
            option: KakaoMapOption(
              position: _center,
              zoomLevel: 14,
              mapType: MapType.normal,
            ),
            onMapReady: (controller) {
              _controller = controller;
            },
            onMapClick: (point, position) {
              // 지도 클릭 시 상세 패널 닫기
              setState(() => _selected = null);
              _focusNode.unfocus();
              _showResults = false;
            },
          ),

          // 검색 상자
          Positioned(
            top: 16 + pad.top,
            left: 16,
            right: 16,
            child: _SearchBox(
              controller: _searchCtl,
              focusNode: _focusNode,
              onChanged: _onChanged,
              onClear: () {
                _searchCtl.clear();
                setState(() => _showResults = false);
                _searchByKeyword('', near: _center);
              },
            ),
          ),

          // 검색 결과 리스트
          if (_showResults && _places.isNotEmpty)
            Positioned(
              top: 76 + pad.top,
              left: 16,
              right: 16,
              child: _ResultList(
                places: _places,
                onTap: (p) async {
                  _showResults = false;
                  setState(() => _selected = p);
                  await _moveCamera(LatLng(p.latitude, p.longitude), 15);
                },
              ),
            ),

          // 내 위치 버튼
          Positioned(
            right: 16,
            bottom: 150 + pad.bottom,
            child: FloatingActionButton.small(
              heroTag: 'myLoc',
              backgroundColor: Colors.white,
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      try {
                        final pos = await Geolocator.getCurrentPosition(
                          locationSettings: const LocationSettings(
                            accuracy: LocationAccuracy.high,
                          ),
                        );
                        _center = LatLng(pos.latitude, pos.longitude);
                        await _moveCamera(_center, 15);
                        await _searchByKeyword(
                          _searchCtl.text.isNotEmpty
                              ? _searchCtl.text
                              : '소아청소년과',
                          near: _center,
                        );
                      } finally {
                        if (mounted) setState(() => _loading = false);
                      }
                    },
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          // 선택 상세 카드
          if (_selected != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 16 + pad.bottom,
              child: _PlaceCard(place: _selected!, onCall: (ph) => _call(ph)),
            ),

          if (_loading)
            const Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Color(0x33000000),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(10),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: '장소를 검색하세요',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear, color: Colors.grey),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.places, required this.onTap});
  final List<Place> places;
  final ValueChanged<Place> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: places.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final p = places[i];
            return ListTile(
              title: Text(
                p.placeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                p.roadAddressName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54),
              ),
              onTap: () => onTap(p),
            );
          },
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place, required this.onCall});
  final Place place;
  final void Function(String phone) onCall;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              place.placeName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              place.roadAddressName ?? '주소 정보 없음',
              style: const TextStyle(color: Colors.grey),
            ),
            if ((place.phone ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: () => onCall(place.phone!),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(place.phone!, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
