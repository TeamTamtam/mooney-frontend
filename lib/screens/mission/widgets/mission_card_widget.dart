import 'package:flutter/material.dart';
import '../models/mission_data.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/constants/app_fonts.dart';

class MissionCard extends StatelessWidget {
  final MissionData mission;

  const MissionCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFEBF6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${mission.index}.  ${mission.title}',
            style: AppFonts.title2_sb.copyWith(color: Color(0xFF0E40C8),)
          ),
          const SizedBox(height: 8),
          Text(
            mission.description,
            style: AppFonts.body2Rg.copyWith(color: AppColors.grey400)
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFDFEFF),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              mission.progressText,
              textAlign: TextAlign.center,
              style: AppFonts.body1Rg.copyWith(color: AppColors.grey600)
            ),
          ),
        ],
      ),
    );
  }
}
