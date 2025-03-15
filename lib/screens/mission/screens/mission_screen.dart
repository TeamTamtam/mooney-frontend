// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mooney2/constants/app_fonts.dart';
// import 'package:mooney2/constants/colors.dart';
// import '../models/mission_data.dart';
// import '../widgets/day_selector_widget.dart';
// import '../widgets/mission_card_widget.dart';
//
// class MissionScreen extends StatefulWidget {
//   const MissionScreen({super.key});
//
//   @override
//   State<MissionScreen> createState() => _MissionScreenState();
// }
//
// class _MissionScreenState extends State<MissionScreen> {
//   final String characterImageAsset = 'assets/mooney.png';
//   String weekDateRange = '';
//   int selectedDayIndex = 0;
//
//   final List<MissionData> missions = [
//     MissionData(
//       title: '커피 적게 마시기',
//       description: '평균적으로 일주일에 3.5회 / xxxxx원 마셔요.\n2회 이하로 마시는 건 어떨까요?',
//       progressText: '현재까지 4회 / 99,999원 썼어요 😊',
//       index: 1,
//     ),
//     MissionData(
//       title: '배달음식 대신 요리',
//       description: '평균적으로 일주일에 3.5회 / xxxxx원 써요.',
//       progressText: '현재까지 4회 / 99,999원 썼어요 😊',
//       index: 2,
//     ),
//     MissionData(
//       title: '쇼핑은 꼭 필요한 것만',
//       description: '평균적으로 일주일에 3.5회 / xxxxx원 써요.',
//       progressText: '현재까지 4회 / 99,999원 썼어요 😊',
//       index: 3,
//     ),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeWeekInfo();
//   }
//
//   void _initializeWeekInfo() {
//     final now = DateTime.now();
//     final monday = now.subtract(Duration(days: now.weekday - 1));
//     final sunday = monday.add(const Duration(days: 6));
//     weekDateRange =
//         '${DateFormat('M.d').format(monday)} ~ ${DateFormat('M.d').format(sunday)}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Column(
//               children: [
//                 Container(
//                   height: 200,
//                   decoration:
//                       const BoxDecoration(color: Colors.lightBlueAccent),
//                   child: Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Image.asset(characterImageAsset),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(color: Colors.lightBlueAccent),
//                 ),
//               ],
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 const SizedBox(height: 200),
//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(24),
//                         topRight: Radius.circular(24),
//                       ),
//                     ),
//                     child: Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 18, vertical: 18),
//                         child: Column(
//                           children: [
//                             _buildWeekHeader(),
//                             const SizedBox(height: 14),
//                             DaySelectorWidget(
//                               selectedDayIndex: selectedDayIndex,
//                               onDaySelected: (index) {
//                                 setState(() {
//                                   selectedDayIndex = index;
//                                   // _fetchMissionData(selectedDayIndex); // API 호출 예정
//                                 });
//                               },
//                             ),
//                             const SizedBox(height: 14),
//                             Expanded(
//                               child: ListView.builder(
//                                 itemCount: missions.length,
//                                 itemBuilder: (context, index) => MissionCard(
//                                   mission: missions[index],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWeekHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text('이번 주 미션', style: AppFonts.title2_sb),
//                 const SizedBox(width: 10),
//                 Text(weekDateRange,
//                     style:
//                         AppFonts.body2Rg.copyWith(color: AppColors.bluegray)),
//               ],
//             ),
// //
//           ],
//         ),
//         Row(
//           children: [
//             Text(
//               '도전 ${selectedDayIndex + 1}일째',
//               style: AppFonts.body1Sb.copyWith(color: AppColors.secondaryBlue),
//             ),
//             Image.asset('assets/flag_blue.png', height: 24, width: 24),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:mooney2/constants/colors.dart';
import '../models/mission_data.dart';
import '../widgets/day_selector_widget.dart';
import '../widgets/mission_card_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooney2/providers/character_provider.dart';

class MissionScreen extends ConsumerStatefulWidget { // ✅ ConsumerStatefulWidget으로 변경
  const MissionScreen({super.key});

  @override
  ConsumerState<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends ConsumerState<MissionScreen> {
  String weekDateRange = '';
  int selectedDayIndex = 0;

  final List<MissionData> missions = [
    MissionData(
      title: '커피 적게 마시기',
      description: '평균적으로 일주일에 3.5회 / xxxxx원 마셔요.\n2회 이하로 마시는 건 어떨까요?',
      progressText: '현재까지 4회 / 99,999원 썼어요 😊',
      index: 1,
    ),
    MissionData(
      title: '배달음식 대신 요리',
      description: '평균적으로 일주일에 3.5회 / xxxxx원 써요.',
      progressText: '현재까지 4회 / 99,999원 썼어요 😊',
      index: 2,
    ),
    MissionData(
      title: '쇼핑은 꼭 필요한 것만',
      description: '평균적으로 일주일에 3.5회 / xxxxx원 써요.',
      progressText: '현재까지 4회 / 99,999원 썼어요 😊',
      index: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeWeekInfo();
  }

  void _initializeWeekInfo() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    weekDateRange =
    '${DateFormat('M.d').format(monday)} ~ ${DateFormat('M.d').format(sunday)}';
  }

  @override
  Widget build(BuildContext context) {
    final characterState = ref.watch(characterProvider); // ✅ 캐릭터 상태 구독

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration:
                  const BoxDecoration(color: Colors.lightBlueAccent),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    // ✅ 캐릭터 프로바이더에서 받아온 이미지 적용
                    child: characterState.when(
                      data: (character) => character != null
                          ? Image.asset(character.imgPath) // ✅ 캐릭터 이미지 반영
                          : const Icon(Icons.error, size: 80, color: Colors.red), // 데이터 없을 경우
                      loading: () => const CircularProgressIndicator(), // 로딩 중
                      error: (err, stack) => const Icon(Icons.error, size: 80, color: Colors.red), // 에러 발생 시
                    ),
                  ),
                ),
                Expanded(
                  child: Container(color: Colors.lightBlueAccent),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 200),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        child: Column(
                          children: [
                            _buildWeekHeader(),
                            const SizedBox(height: 14),
                            DaySelectorWidget(
                              selectedDayIndex: selectedDayIndex,
                              onDaySelected: (index) {
                                setState(() {
                                  selectedDayIndex = index;
                                  // _fetchMissionData(selectedDayIndex); // API 호출 예정
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                            Expanded(
                              child: ListView.builder(
                                itemCount: missions.length,
                                itemBuilder: (context, index) => MissionCard(
                                  mission: missions[index],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader() {
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
                Text('이번 주 미션', style: AppFonts.title2_sb),
                const SizedBox(width: 10),
                Text(weekDateRange,
                    style:
                    AppFonts.body2Rg.copyWith(color: AppColors.bluegray)),
              ],
            ),
//
          ],
        ),
        Row(
          children: [
            Text(
              '도전 ${selectedDayIndex + 1}일째',
              style: AppFonts.body1Sb.copyWith(color: AppColors.secondaryBlue),
            ),
            Image.asset('assets/flag_blue.png', height: 24, width: 24),
          ],
        ),
      ],
    );
  }
}
