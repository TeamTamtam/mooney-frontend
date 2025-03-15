import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mooney2/constants/colors.dart';

class CategoryBudgetItem extends StatelessWidget {
  final String categoryName;
  final String emoji;
  final int totalBudget;
  final int spent;

  const CategoryBudgetItem({
    Key? key,
    required this.categoryName,
    required this.emoji,
    required this.totalBudget,
    required this.spent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int remainingBudget = totalBudget - spent;
    double progress = (spent / totalBudget).clamp(0.0, 1.0);
    bool isOverBudget = spent > totalBudget;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOverBudget ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    emoji,
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    categoryName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                isOverBudget ?
                    '0원 남음' : '${NumberFormat('#,###').format(remainingBudget)}원 남음',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 4,
                    width: isOverBudget ? constraints.maxWidth : constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: isOverBudget ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '예산: ${NumberFormat('#,###').format(totalBudget)}원',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              Text(
                '지출: ${NumberFormat('#,###').format(spent)}원',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
