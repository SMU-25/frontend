String? validateHeight(String? value) {
  if (value == null || value.isEmpty) return '값을 입력해주세요';
  final parsed = double.tryParse(value);
  if (parsed == null) return '숫자만 입력해주세요';
  if (parsed < 0 || parsed > 200) return '0~200 사이로 입력해주세요';
  if (!RegExp(r'^\d{1,3}(\.\d)?$').hasMatch(value)) return '소수 첫째자리까지 입력해주세요';
  return null;
}

String? validateWeight(String? value) {
  if (value == null || value.isEmpty) return '값을 입력해주세요';
  final parsed = double.tryParse(value);
  if (parsed == null) return '숫자만 입력해주세요';
  if (parsed < 0 || parsed > 100) return '0~100 사이로 입력해주세요';
  if (!RegExp(r'^\d{1,3}(\.\d)?$').hasMatch(value)) return '소수 첫째자리까지 입력해주세요';
  return null;
}
