/// 현지 날짜를 DB에 저장하는 'yyyy-MM-dd' 문자열로 바꾼다 (PRD 5장: 일일 기준은 현지 자정).
String dateKey(DateTime dateTime) {
  final local = dateTime.toLocal();
  final y = local.year.toString().padLeft(4, '0');
  final m = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
