import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/screens/home/widgets/mission_widget.dart';
import 'package:mooney2/screens/home/widgets/daily_expenditure_widget.dart';
import  'package:mooney2/screens/home/models/expenditure.dart';
import 'package:mooney2/screens/home/widgets/recent_expenditure_widget.dart';
import 'package:mooney2/screens/home/widgets/remained_budget_widget.dart';
import 'package:mooney2/screens/home/models/remained_budget.dart';
import 'package:mooney2/config/routes.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooney2/providers/character_provider.dart';
import 'package:mooney2/services/user_service.dart';
import '../services/home_service.dart';

class HomeScreen extends ConsumerStatefulWidget { // ✅ ConsumerStatefulWidget으로 변경
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _nickname = '';
  List<Map<String,dynamic>> _weeklyMissions = [];
  int _todayExpenseAmount = 0;
  List<Expenditure> _recentExpenses = [];
  RemainedBudget _remainedBudget = RemainedBudget(
    remainedAmount: "0",
    weekBudget: "0",
    expenditure: "0",
    willExpend: "0",
    dayBudget: "0",
    percent: "0",
  );

  @override
  void initState() {
    super.initState();
    _fetchNickname(); // ✅ 닉네임 가져오기
    _fetchHomeData();

    // ✅ 홈에 진입할 때 캐릭터 다시 불러오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(characterProvider.notifier).fetchCharacter();
    });
  }

  /// ✅ 닉네임 API 호출
  Future<void> _fetchNickname() async {
    String nickname = await userService.getNickname();
    setState(() {
      _nickname = nickname.isNotEmpty ? nickname : "00"; // ✅ 값이 없으면 기본값 유지
    });
  }

  Future<void> _fetchHomeData() async {
    try {
      final data = await homeService.fetchHomeData();

      setState(() {

        // _weeklyMissions = (data["weeklyMissions"] as List<dynamic>? ?? [])
        //     .whereType<Map<String, dynamic>>() // 올바른 타입만 필터링
        //     .map((mission) => {
        //   "title": mission["title"] ?? "미션 제목 없음",
        //   "status": mission["status"]?.toString() ?? "2"
        // })
        //     .toList();
        _weeklyMissions = (data["weeklyMissions"] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((mission) {
          final result = (mission["result"] ?? 0).toDouble();

          String status;
          if (result >= 0 && result < 2.5) {
            status = "1";
          } else if (result >= 2.5 && result < 4.0) {
            status = "2";
          } else {
            status = "3";
          }

          return {
            "title": mission["title"] ?? "미션 제목 없음",
            "status": status,
          };
        }).toList();

        _todayExpenseAmount = data["todayExpenseAmount"] ?? 0;

        _recentExpenses = (data["recentExpenses"] as List)
            .map((item) => Expenditure(
          title: item["payee"] ?? "기타",
          amount: item["amount"].toString(),
          dateTime: DateTime.parse(item["transactionTime"]),
          transactionSource: item["transactionSource"] ?? "알 수 없음",
        ))
            .toList();

        // ✅ weeklyBudget이 null인지 체크 후 안전하게 처리
        final weeklyBudget = data["weeklyBudget"] as Map<String, dynamic>? ?? {};

        _remainedBudget = RemainedBudget(
          remainedAmount: (weeklyBudget["remainingBudgetAmount"] ?? 0).toString(),
          weekBudget: (weeklyBudget["totalBudgetAmount"] ?? 0).toString(),
          expenditure: (weeklyBudget["spentAmount"] ?? 0).toString(),
          willExpend: (weeklyBudget["scheduledExpenseAmount"] ?? 0).toString(),
          dayBudget: (weeklyBudget["dailyBudgetAmount"] ?? 0).toString(),
          percent: (weeklyBudget["budgetUsagePercentage"] ?? 0).toString(),
        );
      });
    } catch (e) {
      print("홈 데이터 로드 실패: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final characterState = ref.watch(characterProvider); // ✅ 캐릭터 상태 구독

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded, color: AppColors.bluegray),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '좋은 아침이에요, $_nickname님!',
                        style: AppFonts.title1_sb,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '오늘도 예산을 잘 지켜봐요 :)',
                        style: AppFonts.body2Sb.copyWith(color: AppColors.grey400),
                      ),
                    ],
                  ),
                ),
                const Spacer(), // ✅ 왼쪽 텍스트와 오른쪽 이미지 사이 여백 추가
                // ✅ 캐릭터 프로바이더에서 가져온 이미지 렌더링
                characterState.when(
                  data: (character) => character != null
                      ? Image.asset(character.imgPath, width: 80, height: 80) // ✅ 캐릭터 이미지 적용
                      : const Icon(Icons.error, size: 80), // 캐릭터 정보 없을 때 기본 아이콘
                  loading: () => const CircularProgressIndicator(), // 로딩 중 표시
                  error: (err, stack) => const Icon(Icons.error, size: 80), // 에러 발생 시 기본 아이콘
                ),
              ],
            ),
            MissionListWidget(
              missions: _weeklyMissions.map((mission) {
                return {
                  "title": mission["title"],
                  "status": mission["status"]
                };
              }).toList(),
            ),

            /// ✅ API에서 가져온 오늘 지출 금액 사용
            DailyExpenditureWidget(amount: _todayExpenseAmount.toString()),

            /// ✅ API에서 가져온 최근 지출 내역 사용
            RecentExpenditureWidget(expenditures: _recentExpenses),

            /// ✅ API에서 가져온 남은 예산 데이터 사용
            RemainedBudgetWidget(remainedBudget: _remainedBudget),
          ],
        ),
      ),
    );
  }
}
