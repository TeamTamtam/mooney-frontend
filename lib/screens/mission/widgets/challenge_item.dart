import 'package:flutter/material.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:mooney2/constants/colors.dart';

class ChallengeItem extends StatelessWidget {
  final String text;

  const ChallengeItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17,horizontal:5),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7FF),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFFD4E6FF)),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: AppFonts.title2_sb.copyWith(color :Color(0xFF0E40C8) ),
      ),
    );
  }
}
