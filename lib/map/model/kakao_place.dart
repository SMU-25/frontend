class KakaoPlace {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String? roadAddress;
  final String? phone;

  KakaoPlace({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.roadAddress,
    this.phone,
  });

  factory KakaoPlace.fromJson(Map<String, dynamic> m) {
    final x = double.tryParse(m['x'] ?? '') ?? 0;
    final y = double.tryParse(m['y'] ?? '') ?? 0;
    return KakaoPlace(
      id: m['id'] as String,
      name: (m['place_name'] as String?) ?? '이름 없음',
      lng: x,
      lat: y,
      roadAddress: m['road_address_name'] as String?,
      phone: m['phone'] as String?,
    );
  }
}
