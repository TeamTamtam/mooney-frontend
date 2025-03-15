import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';

class CharacterEditScreen extends StatelessWidget {
  const CharacterEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🟢 상단 영역 (연한 회색 배경)
        Container(
          width: double.infinity,
          color: AppColors.grey50, // 연한 회색 배경
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 65,
                backgroundImage: AssetImage('assets/mooney.png'),
                backgroundColor: AppColors.grey50,
              ),
              const SizedBox(height: 16),
              const Text(
                '보라 무니',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // 🟣 하단 (흰색 배경)
        Expanded(
          child: Container(
            color: Colors.white, // 흰색 배경 유지
          ),
        ),
      ],
    );
  }
}