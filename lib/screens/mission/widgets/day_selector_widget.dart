import 'package:flutter/material.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:mooney2/constants/colors.dart';

class DaySelectorWidget extends StatelessWidget {
  final int selectedDayIndex;
  final Function(int) onDaySelected;

  const DaySelectorWidget({
    super.key,
    required this.selectedDayIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['월', '화', '수', '목', '금', '토', '일'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(days.length, (index) {
        bool selected = index == selectedDayIndex;
        return GestureDetector(
          onTap: () => onDaySelected(index),
          child: Container(
            alignment: Alignment.center,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: selected ? AppColors.skyBlue : Colors.transparent,
              shape: BoxShape.circle,
              border: selected ? Border.all(color: AppColors.secondaryBlue, width: 2) : null,
            ),
            child: Text(
              days[index],
              style: AppFonts.body2Rg.copyWith(
                color: selected ? AppColors.secondaryBlue : AppColors.grey200,
              ),
            ),
          ),
        );
      }),
    );
  }
}
