import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// 🔥 월 선택 위젯
class MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final Function(int) onMonthChange;

  const MonthSelector({super.key, required this.selectedMonth, required this.onMonthChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_sharp),
          onPressed: () => onMonthChange(-1),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Text(
          DateFormat('yyyy년 M월').format(selectedMonth),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_sharp),
          onPressed: () => onMonthChange(1),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
