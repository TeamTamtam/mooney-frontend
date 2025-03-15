import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mooney2/constants/colors.dart'; // 숫자 포맷 라이브러리

class FixedExpenseWidget extends StatelessWidget {
  final int totalFixedExpense;
  final List<Map<String, dynamic>> fixedExpenses;

  const FixedExpenseWidget({
    Key? key,
    required this.totalFixedExpense,
    required this.fixedExpenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.grey100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 고정비 타이틀
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '고정비',
                style: TextStyle(
                  color: Color(0xFF3A3E43),
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.20,
                  letterSpacing: -0.50,
                ),
              ),
              Text(
                '${NumberFormat('#,###').format(totalFixedExpense)}원',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF3A3E43),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.38,
                  letterSpacing: -0.38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 고정비 리스트
          Column(
            children: fixedExpenses.map((expense) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '[${expense['type']}] ${expense['name']}',
                      style: TextStyle(
                        color: Color(0xFF3A3E43),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.14,
                        letterSpacing: -0.35,
                      ),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(expense['amount'])}원',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF3A3E43),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.14,
                        letterSpacing: -0.35,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
