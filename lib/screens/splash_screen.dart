import 'package:flutter/material.dart';
import 'package:mooney2/constants/app_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 100),
          Expanded( // 🟢 자동으로 남은 공간을 차지
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/splash_background.png'),
                  Text(
                    '무니와 함께하는\n똑똑한 소비 습관',
                    textAlign: TextAlign.center,
                    style : AppFonts.title1_sb

                  ),
                ],
              ),
            ),
          ),
          // 버튼 추가
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/firstBudgetSplash');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: const Text('첫달예산'),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: const Text('로그인'),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/root');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: const Text('홈'),
              ),
              const SizedBox(height: 20), // 버튼 아래 여백
              Image.asset(
                'assets/splash.png',
                width: 120,
                height: 40,
              ),
              const SizedBox(height: 20), // 하단 여백 추가
            ],
          ),
        ],
      ),
    );
  }
}