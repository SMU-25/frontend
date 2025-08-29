class HomeCam {
  final String name;
  final String place;
  final int childId;
  final String childName;
  final String serialNum;
  final String? videoUrl;
  final DateTime createdAt;
  final int homecamId;

  HomeCam({
    required this.name,
    required this.place,
    required this.childId,
    required this.childName,
    required this.serialNum,
    this.videoUrl,
    required this.createdAt,
    required this.homecamId,
  });

  factory HomeCam.fromJson(Map<String, dynamic> json) {
    return HomeCam(
      name: json['name'] as String,
      place: json['place'] as String,
      childId: json['childId'] as int,
      childName: json['childName'] as String,
      serialNum: json['serialNum'] as String,
      videoUrl: json['videoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      homecamId: json['homecamId'] as int,
    );
  }
}
