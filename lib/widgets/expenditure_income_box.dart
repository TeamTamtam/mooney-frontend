import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/models/expenditure.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:mooney2/constants/expense_category.dart';

class ExpenditureBox extends StatelessWidget {
  final Expenditure expenditure;

  const ExpenditureBox({
    required this.expenditure,
    Key? key,
  }) : super(key: key);

  // ✅ 날짜 및 시간 포맷
  String formatDateTime(DateTime dateTime) {
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$month.$day $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    // ✅ amount가 "+"로 시작하면 수입으로 간주
    bool isIncome = expenditure.amount.startsWith("+");
    ExpenseCategory category = ExpenseCategoryExtension.fromString(expenditure.category);


    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 왼쪽 아이콘 자리
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey50
            ),
            child: Center(
              child: Text(
                category.emoji,
                style: TextStyle(fontSize: 24), // ✅ 이모지가 컨테이너를 가득 채우도록 크기 조정
              ),
            ),
          ),
          SizedBox(width: 12),

          // ✅ 중간: 타이틀 + (결제 시각 | 거래처)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    expenditure.title,
                    style: AppFonts.body2Rg
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                        formatDateTime(expenditure.dateTime), // ✅ 결제 시각
                        style: AppFonts.body3Rg.copyWith(color:AppColors.grey300 )
                    ),
                    const SizedBox(width: 6),
                    Text(
                        '|',
                        style: AppFonts.body3Rg.copyWith(color:AppColors.grey300 )
                    ),
                    const SizedBox(width: 6),
                    Text(
                        expenditure.transactionSource, // ✅ 거래처 (ex. KB국민체크)
                        style: AppFonts.body3Rg.copyWith(color:AppColors.grey300 )
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ 오른쪽: 금액 표시 (지출/수입 구분)
          Text(
            '${isIncome ? '' : '-'}${expenditure.amount}원',
            style: AppFonts.body2Sb
          ),
        ],
      ),
    );
  }
}
