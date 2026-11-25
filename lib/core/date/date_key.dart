/// 현지 날짜를 DB에 저장하는 'yyyy-MM-dd' 문자열로 바꾼다 (PRD 5장: 일일 기준은 현지 자정).
String dateKey(DateTime dateTime) {
  final local = dateTime.toLocal();
  final y = local.year.toString().padLeft(4, '0');
  final m = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// 'yyyy-MM-dd' 두 날짜 사이의 일수 ([to] - [from]). 서머타임 영향을 피하려고 UTC로 계산한다.
int daysBetween(String from, String to) {
  DateTime utc(String key) {
    final p = key.split('-').map(int.parse).toList();
    return DateTime.utc(p[0], p[1], p[2]);
  }

  return utc(to).difference(utc(from)).inDays;
}

/// 'yyyy-MM-dd'의 요일 비트 (월=1, 화=2, … 일=64). todos.repeatWeekdays와 같은 형식.
int weekdayBit(String key) {
  final p = key.split('-').map(int.parse).toList();
  return 1 << (DateTime.utc(p[0], p[1], p[2]).weekday - 1);
}
