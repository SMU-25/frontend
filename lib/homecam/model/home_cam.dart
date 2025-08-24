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
}
