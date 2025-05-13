import 'package:flutter/material.dart';
import '../widgets/challenge_item.dart';
import '../utils/date_utils.dart';
import '../services/new_mission_service.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/constants/app_fonts.dart';

class NewChallengeScreen extends StatefulWidget {
  const NewChallengeScreen({Key? key}) : super(key: key);

  @override
  State<NewChallengeScreen> createState() => _NewChallengeScreenState();
}

class _NewChallengeScreenState extends State<NewChallengeScreen> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  List<String> challengeTexts = [];

  final NewMissionService _missionService = NewMissionService();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMissions();
  }

  Future<void> _fetchMissions() async {
    final titles = await _missionService.fetchMissionTitles();

    _controllers = List.generate(titles.length, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });

    setState(() {
      challengeTexts = titles;
      _isLoading = false;
    });

    _playAnimations();
  }


  void _playAnimations() async {
    for (int i = _controllers.length - 1; i >= 0; i--) {
      await Future.delayed(const Duration(milliseconds: 300));
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateInfo = getCurrentWeekInfo();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 150),
                    Text(
                      "${dateInfo['month']}월 ${dateInfo['week']}주차 (${dateInfo['range']})",
                      style: AppFonts.title2_sb),
                    const SizedBox(height: 8),
                    Text("챌린지가 도착했어요!", style: AppFonts.title2_sb),
                    const SizedBox(height: 70),
                    ...List.generate(challengeTexts.length, (index) {
                      return FadeTransition(
                        opacity: _controllers[index].drive(
                            CurveTween(curve: Curves.easeIn)),
                        child: SlideTransition(
                          position: _controllers[index].drive(
                            Tween<Offset>(
                                begin: const Offset(0, 0.3), end: Offset.zero)
                                .chain(CurveTween(curve: Curves.easeOut)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ChallengeItem(text: challengeTexts[index]),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text("확인",style: AppFonts.title2_sb.copyWith(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


// ElevatedButton(
// onPressed: _isLoading ? null : _login, // ✅ 로딩 중이면 버튼 비활성화
// style: ElevatedButton.styleFrom(
// backgroundColor: AppColors.primaryPurple,
// disabledBackgroundColor: AppColors.primaryPurple,
// padding: const EdgeInsets.symmetric(vertical: 12),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(18),
// ),
// ),
// child: _isLoading
// ? SizedBox(
// width: 20, // ✅ 크기 조절
// height: 20,
// child: CircularProgressIndicator(
// color: Colors.white,
// strokeWidth: 2, // ✅ 선 굵기 조절
// ),
// )
//     : Text(
// '로그인',
// style: AppFonts.title2_sb.copyWith(color: Colors.white),
// ),
// ),
// 회원가입 텍스트