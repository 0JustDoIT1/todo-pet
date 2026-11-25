import '../../../core/date/date_key.dart';

const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

/// 'yyyy-MM-dd' → '11월 25일 (수)'.
String dateLabel(String key) {
  final p = key.split('-').map(int.parse).toList();
  final weekday = DateTime.utc(p[0], p[1], p[2]).weekday;
  return '${p[1]}월 ${p[2]}일 (${_weekdays[weekday - 1]})';
}

/// 반복 요일 비트마스크 → '매일' 또는 '월·수·금'.
String weekdaysLabel(int mask) {
  if (mask == 127) return '매일';
  return [
    for (var i = 0; i < 7; i++)
      if (mask & (1 << i) != 0) _weekdays[i],
  ].join('·');
}

/// 요일 이름 (월=0 … 일=6).
String weekdayName(int index) => _weekdays[index];

/// 날짜 선택 창 결과를 DB 형식으로.
String keyFromDate(DateTime date) => dateKey(date);
