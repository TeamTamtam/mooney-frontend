import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:mooney2/constants/colors.dart';

class TotalBudgetWidget extends StatelessWidget {
  final TextEditingController totalBudgetController;
  final Function(String) onBudgetChanged;

  const TotalBudgetWidget({
    Key? key,
    required this.totalBudgetController,
    required this.onBudgetChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Color(0xFFFDFEFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '총 예산',
            style: TextStyle(
              color: Color(0xFF202020),
              fontSize: 20,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 1.20,
              letterSpacing: -0.50,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: TextField(
                    controller: totalBudgetController,
                    textAlign: TextAlign.right,
                    enableSuggestions: false,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        String formattedValue = NumberFormat('#,###').format(int.tryParse(newValue.text) ?? 0);
                        return TextEditingValue(
                          text: formattedValue,
                          selection: TextSelection.collapsed(offset: formattedValue.length),
                        );
                      }),
                    ],
                    style: TextStyle(
                      color: Color(0xFF6E4EE0),
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 1.20,
                      letterSpacing: -0.50,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true, // 내부 패딩 줄여서 중앙 정렬 유지
                    ),
                    onChanged: onBudgetChanged,
                  ),
                ),
                Text(
                  '원',
                  style: TextStyle(
                    color: Color(0xFF202020),
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.20,
                    letterSpacing: -0.50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
