import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷 라이브러리
import 'package:mooney2/constants/colors.dart';
import '../widgets/build_widget_detail_row_widget.dart';
import '../widgets/category_spent_budget_widget.dart';
import 'package:mooney2/config/routes.dart';
import '../services/budget_progress_service.dart';

class BudgetTab extends StatefulWidget {
  @override
  _BudgetTabState createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  late DateTime _selectedMonth;
  Map<String, dynamic>? _budgetData; // 예산 및 카테고리별 예산을 함께 저장

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _fetchBudgetData(); // 초기 데이터 로드
  }

  Future<void> _fetchBudgetData() async {
    try {
      DateTime today = _selectedMonth.month == DateTime.now().month && _selectedMonth.year == DateTime.now().year
          ? DateTime.now()
          : DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0); // 선택한 달의 마지막 날

      Map<String, dynamic> fetchedData = await BudgetService.fetchBudgetData(_selectedMonth, today);
      setState(() {
        _budgetData = fetchedData;
      });
    } catch (e) {
      print("Error fetching budget data: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_budgetData == null) {
      return Center(child: CircularProgressIndicator()); // 데이터 로딩 중
    }

    int remainingDays = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day - DateTime.now().day + 1;
    double dailyBudget = _budgetData!["dailyBudgetAmount"].toDouble();
    double progress = _budgetData!["budgetUsagePercentage"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMonthSelector(),
              const SizedBox(height: 18),
              _buildBudgetOverview(_budgetData!, dailyBudget, progress),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 15, thickness: 10, color: AppColors.grey50),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('카테고리별 예산', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: (_budgetData!["categoryBudgets"] as List)
                          .map((category) => CategoryBudgetItem(
                        categoryName: category["expenseCategory"],
                        emoji: category["emoji"],
                        totalBudget: category["budgetAmount"],
                        spent: category["spentAmount"],
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  //모듈화 / 왼쪽공백 없애기(아이콘 기본패딩때문인듯)
  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_sharp),
          style: IconButton.styleFrom(
            padding:EdgeInsets.symmetric(horizontal: 0),
              minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          constraints: const BoxConstraints(),
          onPressed: () {
            setState(() {
              _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
              _fetchBudgetData();
            });
          },
        ),
        const SizedBox(width: 8),
        Text(
          DateFormat('yyyy년 M월').format(_selectedMonth),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right_sharp),
          style: IconButton.styleFrom(
            padding:EdgeInsets.symmetric(horizontal: 0),
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          constraints: const BoxConstraints(),
          onPressed: () {
            setState(() {
              _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
              _fetchBudgetData();
            });
          },
        ),
      ],
    );
  }
  
  
  
//모듈화
  Widget _buildBudgetOverview(Map<String, dynamic> budgetData, double dailyBudget, double progress) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '한 달 예산',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,),
              ),
              TextButton(
                
                //추후 api에 따라 카테고리별 예산,지난달 사용금액 정보도 같이 넘기기
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.budgetEdit,arguments: _selectedMonth, );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // 🔥 버튼 내부 패딩 없애기
                  minimumSize: Size(0, 0), // 🔥 최소 크기 제한 없애기
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 🔥 터치 영역 최소화
                ),
                child: Text('편집',style: TextStyle(fontSize: 16, color: AppColors.bluegray)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${NumberFormat('#,###').format(budgetData['remainingBudgetAmount'])}원 남음',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            '하루 예산 ${NumberFormat('#,###').format(budgetData["dailyBudgetAmount"])}원',
            style: TextStyle(fontSize: 14, color: AppColors.grey400),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 20,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          BudgetDetailRow(title: '이번 달 예산', amount: budgetData['monthlyBudgetAmount']),
          BudgetDetailRow(title: '오늘까지 지출', amount: -budgetData['totalExpenseAmount']),
          BudgetDetailRow(title: '예정된 지출', amount: -budgetData['pendingExpenseAmount']),
        ],
      ),
    );
  }
}


