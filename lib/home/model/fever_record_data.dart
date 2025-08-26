class FeverRecord {
  final double? fever;
  final DateTime? createdAt;

  FeverRecord({required this.fever, required this.createdAt});
  factory FeverRecord.fromJson(Map<String, dynamic> j) => FeverRecord(
    fever: (j['fever'] as num).toDouble(),
    createdAt: DateTime.parse(j['createdAt'] as String),
  );
}
