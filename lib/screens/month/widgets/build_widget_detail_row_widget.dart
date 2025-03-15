import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetDetailRow extends StatelessWidget {
  final String title;
  final int amount;

  const BudgetDetailRow({
    Key? key,
    required this.title,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Text(
            '${NumberFormat('#,###').format(amount)}원',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
