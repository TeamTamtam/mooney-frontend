import 'package:intl/intl.dart';

Map<String, dynamic> getCurrentWeekInfo() {
  final now = DateTime.now();
  final firstDayOfMonth = DateTime(now.year, now.month, 1);
  final weekday = now.weekday;
  final monday = now.subtract(Duration(days: weekday - 1));
  final sunday = monday.add(const Duration(days: 6));

  // 몇 주차인지 계산 (1일 기준 offset 주차)
  int weekNumber = ((now.day + firstDayOfMonth.weekday - 2) / 7).ceil() + 1;

  String range = "${DateFormat('M.d').format(monday)}~${DateFormat('M.d').format(sunday)}";

  return {
    'month': now.month,
    'week': weekNumber,
    'range': range,
  };
}
