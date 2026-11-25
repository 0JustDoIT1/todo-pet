import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/core/date/date_key.dart';

void main() {
  test('현지 날짜를 yyyy-MM-dd로 만든다 (한 자리 월·일은 0을 채움)', () {
    expect(dateKey(DateTime(2026, 1, 5, 23, 59)), '2026-01-05');
  });

  test('자정이 지나면 다음 날짜가 된다', () {
    expect(dateKey(DateTime(2026, 11, 25, 23, 59, 59)), '2026-11-25');
    expect(dateKey(DateTime(2026, 11, 26)), '2026-11-26');
  });
}
