import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'expense_tab_screen.dart';
import 'budget_tab_screen.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'report_tab_screen.dart';

class MonthScreen extends StatefulWidget {
  const MonthScreen({super.key});

  @override
  State<MonthScreen> createState() => _MonthScreenState();
}

class _MonthScreenState extends State<MonthScreen> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabs = [
    ExpenseIncomeTab(), // 지출/수입 화면
    BudgetTab(),        // 예산 화면
    ReportTab(),        // 리포트 화면
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // AppBar 높이 설정
        child: AppBar(
          automaticallyImplyLeading: false, // 이전 버튼 없애기
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40), // 위쪽 여백 조정
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton('내역', 0),
                _buildTabButton('예산', 1),
                _buildTabButton('분석', 2),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // 바디 배경색을 흰색으로 설정
        child: _tabs[_selectedTabIndex],
      ),
    );
  }


  Widget _buildTabButton(String text, int index) {
    final bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppFonts.body1Sb.copyWith(color:  isSelected ? AppColors.primaryPurple : AppColors.grey200, ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 100, // 보라색 선의 길이를 고정
            height: 3,
            color: isSelected ? AppColors.primaryPurple : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

