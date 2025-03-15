import 'package:flutter/material.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:intl/intl.dart';

// 🔥 주별 지출 목록 위젯 (선택한 달 반영)
class WeeklyExpenseList extends StatelessWidget {
  final DateTime selectedMonth;
  final Map<int, int> weeklyExpenses;

  const WeeklyExpenseList({super.key, required this.selectedMonth, required this.weeklyExpenses});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("주별 지출", style: AppFonts.body1Sb.copyWith(fontSize: 18)),

        const SizedBox(height: 8),

        ...weeklyExpenses.entries.map((entry) {
          int week = entry.key;
          int amount = entry.value;

          String weekLabel = _generateWeekLabel(selectedMonth, week);
          String formattedAmount = amount == 0 ? "0원" : "${NumberFormat('#,###').format(amount)}원";

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(weekLabel, style: AppFonts.body1Rg.copyWith(fontSize: 16, color: Colors.black87)),
                Text(formattedAmount, style: AppFonts.body1Sb.copyWith(fontSize: 16)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // 🔥 선택한 달을 기준으로 주차 생성
  String _generateWeekLabel(DateTime selectedMonth, int week) {
    DateTime firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
    DateTime weekStart = firstDay.add(Duration(days: (week - 1) * 7));
    DateTime weekEnd = weekStart.add(const Duration(days: 6));

    String formatStart = DateFormat('MM.dd').format(weekStart);
    String formatEnd = DateFormat('MM.dd').format(weekEnd);

    return "${selectedMonth.month}월 ${week}주 ($formatStart - $formatEnd)";
  }
}