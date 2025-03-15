// import 'package:flutter/material.dart';
// import 'package:mooney2/constants/app_fonts.dart';
// import 'package:mooney2/constants/colors.dart';
// import '../widgets/month_selector_widget.dart';
// import '../widgets/report_budget_card_widget.dart';
// import '../widgets/weekly_expense_list_widget.dart';
// import '../widgets/category_spending_chart_widget.dart';
// import '../widgets/top_spending_list_widget.dart';
// import '../widgets/feedback_card_widget.dart';
//
// class ReportTab extends StatefulWidget {
//   const ReportTab({super.key});
//
//   @override
//   _ReportTabState createState() => _ReportTabState();
// }
//
// class _ReportTabState extends State<ReportTab> {
//   DateTime _selectedMonth = DateTime.now();
//
//   // 🔥 더미 데이터 (API 연동 시 변경)
//   final dummyData = {
//     'budget': 1000000,
//     'expenses': 700000,
//     'savings': 100000,
//     'income': 500000,
//   };
//
//   // 🔥 주별 지출 데이터 (API 연동 대비)
//   final Map<int, int> dummyWeeklyExpenses = {
//     1: 150000,
//     2: 180000,
//     3: 200000,
//     4: 170000,
//     5: 50000, // 5주차가 있는 경우
//   };
//
//   // 🔥 카테고리별 지출 데이터 (API 연동 대비, 퍼센트 내림차순 정렬 필요)
//   final List<Map<String, dynamic>> dummyCategoryData = [
//     {"category": "외식/배달", "percent": 30.0, "color": Colors.blue},
//     {"category": "교통/주유", "percent": 20.0, "color": Colors.orange},
//     {"category": "취미/문화", "percent": 15.0, "color": Colors.purple},
//     {"category": "식비", "percent": 15.0, "color": Colors.red},
//     {"category": "생활/쇼핑", "percent": 10.0, "color": Colors.green},
//     {"category": "의료/건강", "percent": 10.0, "color": Colors.yellow},
//   ];
//
//   final List<Map<String, dynamic>> dummyTopSpendingData = [
//     {
//       "rank": 1,
//       "title": "애플스토어 명동점",
//       "amount": 320000,
//       "date": "02.24",
//       "emoji": "💻"
//     },
//     {
//       "rank": 2,
//       "title": "뮤지컬",
//       "amount": 170000,
//       "date": "02.20",
//       "emoji": "🎭"
//     },
//     {
//       "rank": 3,
//       "title": "일렉기타",
//       "amount": 130000,
//       "date": "02.20",
//       "emoji": "🎸"
//     },
//   ];
//
//   // 예산 대비 퍼센트 계산
//   String _calculatePercentage(int amount, int total) {
//     if (total == 0) return '0%';
//     return '${((amount / total) * 100).toStringAsFixed(0)}%';
//   }
//
//   // 월 변경
//   void _changeMonth(int diff) {
//     setState(() {
//       _selectedMonth =
//           DateTime(_selectedMonth.year, _selectedMonth.month + diff);
//       // TODO: API 호출해서 새 데이터 받아오기
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // 🔥 상단 월 선택
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: MonthSelector(
//             selectedMonth: _selectedMonth,
//             onMonthChange: _changeMonth,
//           ),
//         ),
//
//         const SizedBox(height: 12),
//
//         // 🔥 예산 관련 위젯들
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             children: [
//               BudgetCard(
//                 title: "이달 예산",
//                 amount: dummyData['budget']!,
//                 backgroundColor: Colors.white,
//                 borderColor: Colors.grey.shade300,
//                 height: 40,
//                 titleStyle: AppFonts.body1Rg,
//                 amountStyle: AppFonts.body1Sb,
//               ),
//               const SizedBox(height: 12),
//               BudgetCard(
//                 title: "지출",
//                 amount: dummyData['expenses']!,
//                 backgroundColor: dummyData['expenses']! > dummyData['budget']!
//                     ? Colors.red.shade50
//                     : Colors.green.shade50,
//                 borderColor: Colors.transparent,
//                 subText:
//                     "예산의 ${_calculatePercentage(dummyData['expenses']!, dummyData['budget']!)}",
//                 height: 74,
//               ),
//               const SizedBox(height: 12),
//               BudgetCard(
//                 title: "저축",
//                 amount: dummyData['savings']!,
//                 backgroundColor: dummyData['savings']! > 0
//                     ? Colors.yellow.shade50
//                     : Colors.white,
//                 borderColor: dummyData['savings']! > 0
//                     ? Colors.transparent
//                     : Colors.grey.shade300,
//                 subText:
//                     "예산의 ${_calculatePercentage(dummyData['savings']!, dummyData['budget']!)}",
//                 height: 74,
//               ),
//               const SizedBox(height: 12),
//               BudgetCard(
//                 title: "수입",
//                 amount: dummyData['income']!,
//                 backgroundColor: dummyData['income']! > 0
//                     ? Colors.blue.shade50
//                     : Colors.white,
//                 borderColor: dummyData['income']! > 0
//                     ? Colors.transparent
//                     : Colors.grey.shade300,
//                 height: 52,
//               ),
//               const SizedBox(height: 12),
//               BudgetCard(
//                 title: "수입-지출-저축",
//                 amount: dummyData['income']! -
//                     dummyData['expenses']! -
//                     dummyData['savings']!,
//                 backgroundColor: Colors.white,
//                 borderColor: Colors.grey.shade300,
//                 height: 40,
//               ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 18),
//
//         const Divider(
//           height: 15,
//           thickness: 10, // 두께 조절
//           color: AppColors.grey50,
//         ),
//
//         const SizedBox(height: 18),
//
//         // 🔥 주별 지출 섹션
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: WeeklyExpenseList(
//               selectedMonth: _selectedMonth,
//               weeklyExpenses: dummyWeeklyExpenses),
//         ),
//         const SizedBox(height: 18),
//         const Divider(
//           height: 15,
//           thickness: 10, // 두께 조절
//           color: AppColors.grey50,
//         ),
//         const SizedBox(height: 18),
//         // 🔥 카테고리별 지출 섹션
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CategorySpendingChart(categoryData: dummyCategoryData),
//             ],
//           ),
//         ),
//         const SizedBox(height: 18),
//         const Divider(
//           height: 15,
//           thickness: 10, // 두께 조절
//           color: AppColors.grey50,
//         ),
//         const SizedBox(height: 18),
//         // 🔥 가장 큰 지출 Top 3 섹션
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: TopSpendingList(topSpendingData: dummyTopSpendingData),
//         ),
//         const Divider(
//           height: 15,
//           thickness: 10, // 두께 조절
//           color: AppColors.grey50,
//         ),
//
//         //무니의 피드백 섹션 : 추후 api 연동으로 받아올 것들은 모델로 빼기
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('무니의 피드백', style: Theme.of(context).textTheme.headlineMedium),
//                       const SizedBox(height: 8),
//                       const Text(
//                         '이번 달 소비를 분석해보니, 몇 가지 눈에\n 띄는 점이 있었어요. 함께 살펴볼까요? 😊',
//                         style: TextStyle(color: Colors.grey, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   Image.asset('assets/mooney.png', height: 80),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               FeedbackCard(
//                 title: '✅ 잘한 점',
//                 titleColor: Colors.green,
//                 feedbackItems: [
//                   {
//                     'title': '🎉 저축 목표 달성',
//                     'description': '꾸준히 저축하면서 예산을 잘 관리했어요. 이번 페이스 그대로 유지해봐요! 💰'
//                   },
//                   {
//                     'title': '👍 문화·여가비 절약',
//                     'description': '무리한 소비 없이 알차게 즐겼어요. 계획적인 소비 습관, 너무 좋아요! 👏'
//                   },
//                 ],
//               ),
//               const SizedBox(height: 18),
//               FeedbackCard(
//                 title: '🎯 개선할 점',
//                 titleColor: Colors.red,
//                 feedbackItems: [
//                   {
//                     'title': '❗ 식비 예산 초과',
//                     'description': '외식과 배달이 많았어요. 조금만 조절하면 더 여유로운 소비가 가능할 거예요!'
//                   },
//                   {
//                     'title': '❗ 쇼핑 지출 증가',
//                     'description':
//                         '계획에 없던 소비가 있었을 수 있어요. 다음 달엔 한 번 더 고민해보는 습관을 가져보는 것도 좋겠어요.'
//                   },
//                 ],
//               ),
//               const SizedBox(height: 18),
//               Container(
//                 padding: const EdgeInsets.all(18),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       '💡 예산 준수를 위한 팁',
//                       style: TextStyle(
//                           color: Colors.deepPurple,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 12),
//                     const Text(
//                       '다음 달에는 식비 예산을 조금 조정해보거나, 장보기 목록을 미리 계획해 보세요!\n지금처럼 예산을 잘 지킨 카테고리는 그대로 유지하면서, 여유 자금을 저축하면 좋아요.',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Center(
//                 child: Text(
//                   '이번 달도 고생 많았어요! 👏 다음 달엔 더 똑똑한 소비로 예산을 잘 관리해봐요! 😊 무니가 함께할게요! 💙',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 36),
//             ],
//           ),
//         )
//       ],
//     ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:mooney2/constants/colors.dart';
import '../widgets/month_selector_widget.dart';
import '../widgets/report_budget_card_widget.dart';
import '../widgets/weekly_expense_list_widget.dart';
import '../widgets/category_spending_chart_widget.dart';
import '../widgets/top_spending_list_widget.dart';
import '../widgets/feedback_card_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooney2/providers/character_provider.dart';

class ReportTab extends ConsumerStatefulWidget {
  // ✅ ConsumerStatefulWidget으로 변경
  const ReportTab({super.key});

  @override
  ConsumerState<ReportTab> createState() => _ReportTabState(); // ✅ 변경
}

class _ReportTabState extends ConsumerState<ReportTab> {
  // ✅ ConsumerState 사용
  DateTime _selectedMonth = DateTime.now();

  // 🔥 더미 데이터 (API 연동 시 변경)
  final dummyData = {
    'budget': 1000000,
    'expenses': 700000,
    'savings': 100000,
    'income': 500000,
  };

  final Map<int, int> dummyWeeklyExpenses = {
    1: 150000,
    2: 180000,
    3: 200000,
    4: 170000,
    5: 50000,
  };

  final List<Map<String, dynamic>> dummyCategoryData = [
    {"category": "외식/배달", "percent": 30.0, "color": Colors.blue},
    {"category": "교통/주유", "percent": 20.0, "color": Colors.orange},
    {"category": "취미/문화", "percent": 15.0, "color": Colors.purple},
    {"category": "식비", "percent": 15.0, "color": Colors.red},
    {"category": "생활/쇼핑", "percent": 10.0, "color": Colors.green},
    {"category": "의료/건강", "percent": 10.0, "color": Colors.yellow},
  ];

  final List<Map<String, dynamic>> dummyTopSpendingData = [
    {
      "rank": 1,
      "title": "애플스토어 명동점",
      "amount": 320000,
      "date": "02.24",
      "emoji": "💻"
    },
    {
      "rank": 2,
      "title": "뮤지컬",
      "amount": 170000,
      "date": "02.20",
      "emoji": "🎭"
    },
    {
      "rank": 3,
      "title": "일렉기타",
      "amount": 130000,
      "date": "02.20",
      "emoji": "🎸"
    },
  ];

  // 예산 대비 퍼센트 계산
  String _calculatePercentage(int amount, int total) {
    if (total == 0) return '0%';
    return '${((amount / total) * 100).toStringAsFixed(0)}%';
  }

  void _changeMonth(int diff) {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + diff);
    });
  }

  @override
  Widget build(BuildContext context) {
    final characterState = ref.watch(characterProvider); // ✅ 캐릭터 상태 구독

    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 상단 월 선택
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MonthSelector(
            selectedMonth: _selectedMonth,
            onMonthChange: _changeMonth,
          ),
        ),

        const SizedBox(height: 12),

        // 🔥 예산 관련 위젯들
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              BudgetCard(
                title: "이달 예산",
                amount: dummyData['budget']!,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                height: 40,
                titleStyle: AppFonts.body1Rg,
                amountStyle: AppFonts.body1Sb,
              ),
              const SizedBox(height: 12),
              BudgetCard(
                title: "지출",
                amount: dummyData['expenses']!,
                backgroundColor: dummyData['expenses']! > dummyData['budget']!
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                borderColor: Colors.transparent,
                subText:
                    "예산의 ${_calculatePercentage(dummyData['expenses']!, dummyData['budget']!)}",
                height: 74,
              ),
              const SizedBox(height: 12),
              BudgetCard(
                title: "저축",
                amount: dummyData['savings']!,
                backgroundColor: dummyData['savings']! > 0
                    ? Colors.yellow.shade50
                    : Colors.white,
                borderColor: dummyData['savings']! > 0
                    ? Colors.transparent
                    : Colors.grey.shade300,
                subText:
                    "예산의 ${_calculatePercentage(dummyData['savings']!, dummyData['budget']!)}",
                height: 74,
              ),
              const SizedBox(height: 12),
              BudgetCard(
                title: "수입",
                amount: dummyData['income']!,
                backgroundColor: dummyData['income']! > 0
                    ? Colors.blue.shade50
                    : Colors.white,
                borderColor: dummyData['income']! > 0
                    ? Colors.transparent
                    : Colors.grey.shade300,
                height: 52,
              ),
              const SizedBox(height: 12),
              BudgetCard(
                title: "수입-지출-저축",
                amount: dummyData['income']! -
                    dummyData['expenses']! -
                    dummyData['savings']!,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                height: 40,
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        const Divider(
          height: 15,
          thickness: 10, // 두께 조절
          color: AppColors.grey50,
        ),

        const SizedBox(height: 18),

        // 🔥 주별 지출 섹션
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: WeeklyExpenseList(
              selectedMonth: _selectedMonth,
              weeklyExpenses: dummyWeeklyExpenses),
        ),
        const SizedBox(height: 18),
        const Divider(
          height: 15,
          thickness: 10, // 두께 조절
          color: AppColors.grey50,
        ),
        const SizedBox(height: 18),
        // 🔥 카테고리별 지출 섹션
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategorySpendingChart(categoryData: dummyCategoryData),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Divider(
          height: 15,
          thickness: 10, // 두께 조절
          color: AppColors.grey50,
        ),
        const SizedBox(height: 18),
        // 🔥 가장 큰 지출 Top 3 섹션
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TopSpendingList(topSpendingData: dummyTopSpendingData),
        ),
        const Divider(
          height: 15,
          thickness: 10, // 두께 조절
          color: AppColors.grey50,
        ),

        // 🔥 무니의 피드백 섹션
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterState.when(
                        data: (character) => Text(
                          '${character?.name ?? '00'}의 피드백', // ✅ 캐릭터 이름 적용
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        loading: () => const Text(
                          '로딩 중...', // 로딩 중일 때
                          style: TextStyle(fontSize: 18),
                        ),
                        error: (err, stack) => const Text(
                          '오류 발생', // 에러 발생 시
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),),
                      const SizedBox(height: 8),
                      const Text(
                        '이번 달 소비를 분석해보니, 몇 가지 눈에\n 띄는 점이 있었어요. 함께 살펴볼까요? 😊',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                  // ✅ 캐릭터 프로바이더에서 받아온 이미지 적용
                  characterState.when(
                    data: (character) => character != null
                        ? Image.asset(character.imgPath,
                            height: 80) // ✅ 캐릭터 이미지 반영
                        : const Icon(Icons.error, size: 80, color: Colors.red),
                    // 데이터 없을 경우
                    loading: () => const CircularProgressIndicator(),
                    // 로딩 중
                    error: (err, stack) => const Icon(Icons.error,
                        size: 80, color: Colors.red), // 에러 발생 시
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FeedbackCard(
                title: '✅ 잘한 점',
                titleColor: Colors.green,
                feedbackItems: [
                  {
                    'title': '🎉 저축 목표 달성',
                    'description': '꾸준히 저축하면서 예산을 잘 관리했어요. 이번 페이스 그대로 유지해봐요! 💰'
                  },
                  {
                    'title': '👍 문화·여가비 절약',
                    'description': '무리한 소비 없이 알차게 즐겼어요. 계획적인 소비 습관, 너무 좋아요! 👏'
                  },
                ],
              ),
              const SizedBox(height: 18),
              FeedbackCard(
                title: '🎯 개선할 점',
                titleColor: Colors.red,
                feedbackItems: [
                  {
                    'title': '❗ 식비 예산 초과',
                    'description': '외식과 배달이 많았어요. 조금만 조절하면 더 여유로운 소비가 가능할 거예요!'
                  },
                  {
                    'title': '❗ 쇼핑 지출 증가',
                    'description':
                        '계획에 없던 소비가 있었을 수 있어요. 다음 달엔 한 번 더 고민해보는 습관을 가져보는 것도 좋겠어요.'
                  },
                ],
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  '이번 달도 고생 많았어요! 👏 다음 달엔 더 똑똑한 소비로 예산을 잘 관리해봐요! 😊 무니가 함께할게요! 💙',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        )
      ],
    ));
  }
}
