import 'package:flutter/material.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:mooney2/constants/colors.dart';

class DaySelectorWidget extends StatelessWidget {
  final Function(int) onDaySelected;

  const DaySelectorWidget({
    super.key,
    required this.onDaySelected,
  });

  int getTodayWeekIndex() => DateTime.now().weekday - 1;

  @override
  Widget build(BuildContext context) {
    final days = ['월', '화', '수', '목', '금', '토', '일'];
    final todayIndex = getTodayWeekIndex();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(days.length, (index) {
        bool isPast = index < todayIndex;
        bool isToday = index == todayIndex;
        bool isFuture = index > todayIndex;

        Color bgColor = Colors.transparent;
        BoxBorder? border;
        Color textColor = AppColors.grey200;

        if (isToday) {
          bgColor = AppColors.skyBlue;
          border = Border.all(color: AppColors.secondaryBlue, width: 2);
          textColor = AppColors.secondaryBlue;
        } else if (isPast) {
          bgColor = AppColors.skyBlue;
          border = null;
          textColor = AppColors.secondaryBlue;
        }

        return GestureDetector(
          onTap: () => onDaySelected(index),
          child: Container(
            alignment: Alignment.center,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: border,
            ),
            child: Text(
              days[index],
              style: AppFonts.body2Rg.copyWith(color: textColor),
            ),
          ),
        );
      }),
    );
  }
}
