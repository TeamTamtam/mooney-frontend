import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:mooney2/constants/colors.dart';
import '../models/mission_data.dart';
import '../widgets/day_selector_widget.dart';
import '../widgets/mission_card_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooney2/providers/character_provider.dart';
import '../services/mission_service.dart';
//
// class MissionScreen extends ConsumerStatefulWidget { // ✅ ConsumerStatefulWidget으로 변경
//   const MissionScreen({super.key});
//
//   @override
//   ConsumerState<MissionScreen> createState() => _MissionScreenState();
// }
//
// class _MissionScreenState extends ConsumerState<MissionScreen> {
//   String weekDateRange = '';
//   int getTodayWeekIndex() => DateTime.now().weekday - 1;
//   late Future<List<MissionData>> _missionsFuture;
//
//   List<Widget>? _missionsFutureWidget;
//
//   String backgroundImagePath = 'assets/back_normal.png';
//
//   List<Widget> _buildMissionListAsWidgets() {
//     return _missionsFutureWidget ?? [ // 처음엔 null일 수도 있으니까
//       const Center(child: CircularProgressIndicator())
//     ];
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeWeekInfo();
//     missionService.fetchMissions().then((missions) {
//       setState(() {
//         _missionsFutureWidget = missions
//             .map((mission) => MissionCard(mission: mission))
//             .toList();
//       });
//     });
//     //5000원짜리 햄버거랑 5만원짜리 햄버거중에 5만원짜리 먹어도 될까
//     //같은 메뉴를 매장에서 먹으면 9천원이고, 배달시키면 50프로 할인쿠폰이 있고 배달비가 3천원이야. 둘 중 뭐가 좋을끼
//     // 2️⃣ mooneystatus만 따로 불러오기
//     missionService.fetchMissionsWithStatus().then((data) {
//       final mooneyStatus = (data['mooneystatus'] ?? 0).toDouble();
//
//       String bgPath;
//       if (mooneyStatus < 2.4) {
//         bgPath = 'assets/background_bad.png';
//       } else if (mooneyStatus < 4.0) {
//         bgPath = 'assets/back_normal.png';
//       } else {
//         bgPath = 'assets/background_good.png';
//       }
//
//       setState(() {
//         backgroundImagePath = bgPath;
//       });
//     });
//   }
//
//
//   void _initializeWeekInfo() {
//     final now = DateTime.now();
//     final monday = now.subtract(Duration(days: now.weekday - 1));
//     final sunday = monday.add(const Duration(days: 6));
//     weekDateRange =
//     '${DateFormat('M.d').format(monday)} ~ ${DateFormat('M.d').format(sunday)}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final characterState = ref.watch(characterProvider); // ✅ 캐릭터 상태 구독
//     final todayIndex = getTodayWeekIndex();
//
//
//     return Scaffold(
//       backgroundColor: Colors.transparent, // 👈 핵심 1: Scaffold 배경 투명하게!
//       body: Stack(
//         children: [
//           // ✅ 1. 배경 이미지
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Image.asset(
//               backgroundImagePath,
//               fit: BoxFit.cover,
//               height: 270,
//             ),
//           ),
//
//           // ✅ 2. 캐릭터
//           Positioned(
//             top: 100,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: characterState.when(
//                 data: (character) =>
//                 character != null
//                     ? Image.asset(character.imgPath, height: 100)
//                     : const Icon(Icons.error, size: 80, color: Colors.red),
//                 loading: () => const CircularProgressIndicator(),
//                 error: (err, stack) =>
//                 const Icon(Icons.error, size: 80, color: Colors.red),
//               ),
//             ),
//           ),
//
//           // ✅ 3. 흰 카드 (위에 얹히는 진짜 컴포넌트)
//           Positioned(
//             top: 210,
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(24),
//                   topRight: Radius.circular(24),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, -4),
//                   ),
//                 ],
//               ),
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 18, vertical: 18),
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                           minHeight: constraints.maxHeight),
//                       child: IntrinsicHeight(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildWeekHeader(getTodayWeekIndex()),
//                             const SizedBox(height: 14),
//                             DaySelectorWidget(onDaySelected: (index) {}),
//                             const SizedBox(height: 14),
//                             ..._buildMissionListAsWidgets(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }


class MissionScreen extends ConsumerStatefulWidget {
  const MissionScreen({super.key});

  @override
  ConsumerState<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends ConsumerState<MissionScreen> {
  String weekDateRange = '';
  int getTodayWeekIndex() => DateTime.now().weekday - 1;
  late Future<List<MissionData>> _missionsFuture;

  List<Widget>? _missionsFutureWidget;

  String backgroundImagePath = 'assets/back_normal.png';
  double _mooneyStatus = 0.0; // ✅ 추가

  List<Widget> _buildMissionListAsWidgets() {
    return _missionsFutureWidget ??
        [const Center(child: CircularProgressIndicator())];
  }

  @override
  void initState() {
    super.initState();
    _initializeWeekInfo();

    missionService.fetchMissions().then((missions) {
      setState(() {
        _missionsFutureWidget =
            missions.map((mission) => MissionCard(mission: mission)).toList();
      });
    });

    missionService.fetchMissionsWithStatus().then((data) {
      final status = (data['mooneystatus'] ?? 0).toDouble();
      _mooneyStatus = status; // ✅ 저장

      String bgPath;
      if (_mooneyStatus < 2.4) {
        bgPath = 'assets/background_bad.png';
      } else if (_mooneyStatus < 4.0) {
        bgPath = 'assets/back_normal.png';
      } else {
        bgPath = 'assets/background_good.png';
      }

      setState(() {
        backgroundImagePath = bgPath;
      });
    });
  }

  void _initializeWeekInfo() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    weekDateRange =
    '${DateFormat('M.d').format(monday)} ~ ${DateFormat('M.d').format(sunday)}';
  }

  // ✅ mooneyStatus에 따라 캐릭터 이미지 오버라이드
  String _getCharacterImagePath(String originalPath) {
    if (_mooneyStatus < 2.4) {
      return 'assets/mooney_sad.png';
    } else if (_mooneyStatus < 4.0) {
      return originalPath;
    } else {
      return 'assets/mooney_happy.png';
    }
  }


  @override
  Widget build(BuildContext context) {
    final characterState = ref.watch(characterProvider);
    final todayIndex = getTodayWeekIndex();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ✅ 1. 배경 이미지
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              backgroundImagePath,
              fit: BoxFit.cover,
              height: 270,
            ),
          ),

          // ✅ 2. 캐릭터
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: characterState.when(
                data: (character) {
                  if (character == null) {
                    return const Icon(Icons.error,
                        size: 80, color: Colors.red);
                  }
                  final overriddenPath =
                  _getCharacterImagePath(character.imgPath); // ✅ 오버라이드
                  return Image.asset(overriddenPath, height: 100);
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) =>
                const Icon(Icons.error, size: 80, color: Colors.red),
              ),
            ),
          ),

          // ✅ 3. 흰 카드
          Positioned(
            top: 210,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWeekHeader(getTodayWeekIndex()),
                            const SizedBox(height: 14),
                            DaySelectorWidget(onDaySelected: (index) {}),
                            const SizedBox(height: 14),
                            ..._buildMissionListAsWidgets(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }




  Widget _buildWeekHeader(int todayIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('이번 주 챌린지', style: AppFonts.title2_sb),
                const SizedBox(width: 10),
                Text(
                  weekDateRange,
                  style: AppFonts.body2Rg.copyWith(color: AppColors.bluegray),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '도전 ${todayIndex + 1}일째',
              style: AppFonts.body1Sb.copyWith(color: AppColors.secondaryBlue),
            ),
            Image.asset('assets/flag_blue.png', height: 24, width: 24),
          ],
        ),
      ],
    );
  }
}