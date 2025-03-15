import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mooney2/services/user_service.dart';
import 'package:mooney2/constants/app_fonts.dart';
//
// class SplashFirstScreen extends StatefulWidget {
//   const SplashFirstScreen({super.key});
//
//   @override
//   _SplashFirstScreenState createState() => _SplashFirstScreenState();
// }
//
// class _SplashFirstScreenState extends State<SplashFirstScreen> {
//   double _opacity = 0.0; // 초기 상태는 투명
//
//   @override
//   void initState() {
//     super.initState();
//     // 1초 후 텍스트 페이드인
//     Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() {
//         _opacity = 1.0;
//       });
//     });
//   }
//
//   void _fadeOutAndNavigate() {
//     setState(() {
//       _opacity = 0.0;
//     });
//
//     // 0.5초 후 다음 화면으로 전환
//     Future.delayed(const Duration(milliseconds: 500), () {
//       Navigator.pushReplacementNamed(context, '/firstBudgetSplash2');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _fadeOutAndNavigate, // 화면 클릭 시 페이드아웃 & 이동
//       child: Scaffold(
//         body: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xFFFFFFFF), // ✅ 완전 흰색 (상단)
//                 Color(0xFFF5DEFF), // ✅ 연한 보라 (중간)
//                 Color(0xFFEAD8FF), // ✅ 부드러운 연보라 (하단)
//               ],
//             ),
//           ),
//           child: Stack(
//             children: [
//               // 중앙 정렬된 캐릭터 + 텍스트
//               Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // 캐릭터 (무니)
//                     Image.asset(
//                       'assets/mooney.png', // 무니 캐릭터
//                       width: 100,
//                       height: 100,
//                     ),
//                     const SizedBox(height: 20), // 캐릭터와 텍스트 사이 여백
//
//                     // 텍스트 (페이드인 애니메이션)
//                     AnimatedOpacity(
//                       duration: const Duration(seconds: 1),
//                       opacity: _opacity,
//                       child: const Text(
//                         "안녕하세요, OO님~\n"
//                             "저는 오늘부터 OO님의\n"
//                             "현명한 소비를 도울 수호천사,\n"
//                             "무니라고 해요!",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // 하단 원 장식 (PNG)
//               Positioned(
//                 bottom: 0,
//                 child: Image.asset(
//                   'assets/splash_circle_frame.png', // 하단 원 장식
//                   width: MediaQuery.of(context).size.width,
//                   fit: BoxFit.cover, // ✅ 가로 꽉 채우기
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class SplashFirstScreen extends StatefulWidget {
  const SplashFirstScreen({super.key});

  @override
  _SplashFirstScreenState createState() => _SplashFirstScreenState();
}

class _SplashFirstScreenState extends State<SplashFirstScreen> {
  double _opacity = 0.0;
  String _nickname = ""; // ✅ 기본 닉네임

  @override
  void initState() {
    super.initState();
    _fetchNickname(); // ✅ 닉네임 불러오기

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  /// ✅ 닉네임 불러오기
  void _fetchNickname() async {
    final nickname = await userService.getNickname(); // ✅ API 호출
    setState(() {
      _nickname = nickname;
    });
  }

  void _fadeOutAndNavigate() {
    setState(() {
      _opacity = 0.0;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/firstBudgetSplash2');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _fadeOutAndNavigate,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFF5DEFF),
                Color(0xFFEAD8FF),
              ],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/mooney.png',
                      width: 100,
                      height: 100,
                    ),

                    AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: _opacity,
                      child: Text(
                        "안녕하세요, $_nickname님~\n"
                            "저는 오늘부터 $_nickname님의\n"
                            "현명한 소비를 도울 수호천사,\n"
                            "무니라고 해요!",
                        textAlign: TextAlign.center,
                        style: AppFonts.title1_sb
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Image.asset(
                  'assets/splash_circle_frame.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
