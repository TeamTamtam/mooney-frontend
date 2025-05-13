import 'package:flutter/material.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:mooney2/constants/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  void openNotificationAccessSettings() {
    const AndroidIntent intent = AndroidIntent(
      action: 'android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS',
    );
    intent.launch();
  }

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
                // onPressed: () {
                //   Navigator.pushNamed(context, '/newMission');
                // },
                // style: ElevatedButton.styleFrom(
                //   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                // ),
                onPressed: openNotificationAccessSettings,
                child: const Text('알림 접근 허용',style: TextStyle(color: AppColors.primaryPurple),),
              ),
              const SizedBox(height: 5),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pushNamed(context, '/firstBudgetSplash');
              //   },
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              //   ),
              //   child: const Text('첫달예산'),
              // ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/newMission');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: const Text('이번 주 챌린지',style: TextStyle(color: AppColors.primaryPurple),),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                //덮밥은 만원 초밥은 5만원인데 초밥먹어도딜까
                child: const Text('로그인',style: TextStyle(color: AppColors.primaryPurple),),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/root');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: const Text('홈',style: TextStyle(color: AppColors.primaryPurple),),
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