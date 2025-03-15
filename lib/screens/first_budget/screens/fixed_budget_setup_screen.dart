import 'package:flutter/material.dart';
import 'package:mooney2/screens/first_budget/widgets/fixed_buget_input_widget.dart';// 위에서 만든 위젯 임포트
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/screens/first_budget/models/fixed_budget.dart';
import 'package:mooney2/screens/first_budget/screens/total_budget_setup_screen.dart';

class FixedBudgetSetupScreen extends StatefulWidget {
  const FixedBudgetSetupScreen({super.key});

  @override
  _FixedBudgetSetupScreenState createState() => _FixedBudgetSetupScreenState();
}

class _FixedBudgetSetupScreenState extends State<FixedBudgetSetupScreen> {


  List<FixedBudgetEntry> fixedExpenseEntries = [];
  List<FixedBudgetEntry> fixedSavingEntries = [];
  List<FixedBudgetEntry> fixedIncomeEntries = [];

  void _goToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TotalBudgetSetupScreen(
              fixedIncomeEntries : fixedIncomeEntries,
              fixedExpenseEntries: fixedExpenseEntries,
              fixedSavingEntries: fixedSavingEntries,

            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: true, // ✅ 키보드 올라올 때 화면 조정 가능
      body: SafeArea(
        child: Column(
          children: [
            Expanded( // ✅ 입력 필드가 화면을 꽉 채우도록 확장
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      FixedBudgetInput(
                        title: '고정 수입',
                        onEntriesChanged: (entries) => setState(() => fixedIncomeEntries = entries),
                      ),
                      FixedBudgetInput(
                        title: '고정 지출',
                        onEntriesChanged: (entries) => setState(() => fixedExpenseEntries = entries),
                      ),
                      FixedBudgetInput(
                        title: '고정 저축',
                        onEntriesChanged: (entries) => setState(() => fixedSavingEntries = entries),
                      ),
                      const SizedBox(height: 20), // ✅ 하단 간격 추가
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _goToNextScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('완료', style: TextStyle(fontSize: 16)),
                ),
              ),
            ), // ✅ 완료 버튼을 Column의 마지막 요소로 배치
          ],
        ),
      ),
    );
  }
}