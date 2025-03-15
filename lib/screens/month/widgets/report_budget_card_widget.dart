import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 🔥 개별 예산 표시 위젯 (높이 조정 가능)
class BudgetCard extends StatelessWidget {
  final String title;
  final int amount;
  final Color backgroundColor;
  final Color borderColor;
  final String? subText;
  final double height;

  // 🔥 추가된 스타일 속성
  final TextStyle? titleStyle;
  final TextStyle? amountStyle;
  final TextStyle? subTextStyle;

  const BudgetCard({
    super.key,
    required this.title,
    required this.amount,
    required this.backgroundColor,
    required this.borderColor,
    this.subText,
    this.height = 70,
    this.titleStyle,
    this.amountStyle,
    this.subTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 타이틀과 금액을 한 줄(Row)로 정렬
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: titleStyle ??
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                NumberFormat('#,###').format(amount) + '원',
                style: amountStyle ??
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          if (subText != null) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight, // 🔥 오른쪽 정렬 (금액과 맞춤)
              child: Text(
                subText!,
                style: subTextStyle ??
                    TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ],
        ],
      ),
    );
  }

}

