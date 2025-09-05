class NaverPlace {
  final String id; // 고유 판단을 위한 키 (없으니 title+mapx+mapy 등 조합)
  final String name;
  final String? phone;
  final String? roadAddress;
  final double lat;
  final double lng;

  NaverPlace({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.phone,
    this.roadAddress,
  });

  factory NaverPlace.fromJson(Map<String, dynamic> json) {
    double toCoord(String s) => double.parse(s) / 1e7;

    return NaverPlace(
      id: json['link'] as String? ?? '',
      name: (json['title'] as String).replaceAll(RegExp(r'<\/?b>'), ''),
      lng: toCoord(json['mapx'] as String),
      lat: toCoord(json['mapy'] as String),
      phone: json['telephone'] as String?,
      roadAddress: json['roadAddress'] as String?,
    );
  }
}
