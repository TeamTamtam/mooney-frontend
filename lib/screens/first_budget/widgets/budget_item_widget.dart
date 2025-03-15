import 'package:flutter/material.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:mooney2/constants/colors.dart';

// 예산 정보 표시용 위젯(고정지출, ..)
class BudgetItem extends StatelessWidget {
  final String title;
  final int amount;

  const BudgetItem({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppFonts.body2Rg.copyWith(color: AppColors.grey600)),
          Text("${amount.toString()}원",
              style: AppFonts.body2Rg.copyWith(color: AppColors.grey600)),
        ],
      ),
    );
  }
}
