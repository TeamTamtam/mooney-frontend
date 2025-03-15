import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/screens/first_budget/models/fixed_budget.dart';
import '../widgets/budget_item_widget.dart';
import 'package:mooney2/widgets/category_budget.dart';
import 'package:mooney2/constants/expense_category.dart';
import '../services/first_budget_service.dart';
import 'package:mooney2/config/routes.dart';
import 'package:mooney2/constants/app_fonts.dart';


class TotalBudgetSetupScreen extends StatefulWidget {
  final List<FixedBudgetEntry> fixedExpenseEntries;
  final List<FixedBudgetEntry> fixedSavingEntries;
  final List<FixedBudgetEntry> fixedIncomeEntries;

  const TotalBudgetSetupScreen({
    super.key,
    required this.fixedIncomeEntries,
    required this.fixedExpenseEntries,
    required this.fixedSavingEntries,
  });

  @override
  State<TotalBudgetSetupScreen> createState() => _TotalBudgetSetupScreenState();
}

class _TotalBudgetSetupScreenState extends State<TotalBudgetSetupScreen> {
  final TextEditingController _budgetController = TextEditingController();
  bool _isCategoryBudgetVisible = false;
  int _totalBudget = 0;
  int _remainingBudget = 0;
  bool _isLoading = false; // ✅ API 요청 중 로딩 상태


  // ✅ 카테고리별 예산을 저장하는 맵
  Map<ExpenseCategory, int> _categoryBudgets = {};

  int get totalFixedExpense => widget.fixedExpenseEntries.fold(0, (sum, item) => sum + item.amount);
  int get totalFixedSaving => widget.fixedSavingEntries.fold(0, (sum, item) => sum + item.amount);

  void _onBudgetChanged(String value) {
    setState(() {
      _totalBudget = int.tryParse(value.replaceAll(',', '')) ?? 0;
      _remainingBudget = _totalBudget - (totalFixedExpense + totalFixedSaving);
      if (_remainingBudget < 0) _remainingBudget = 0;
      _isCategoryBudgetVisible = _totalBudget > totalFixedExpense + totalFixedSaving;
    });
  }

  // ✅ 카테고리별 예산이 변경될 때 호출되는 함수
  void _onCategoryBudgetChanged(Map<ExpenseCategory, int> categoryBudgets) {
    setState(() {
      _categoryBudgets = categoryBudgets;
    });
  }

  // ✅ API 요청 함수 (서비스 호출)
  Future<void> _submitBudget() async {
    setState(() {
      _isLoading = true;
    });

    bool success = await firstBudgetService.submitFirstBudget(
      fixedIncome: widget.fixedIncomeEntries,
      fixedExpense: widget.fixedExpenseEntries,
      fixedSavings: widget.fixedSavingEntries,
      totalBudget: _totalBudget,
      categoryBudgets: _categoryBudgets,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      print("예산이 성공적으로 등록되었습니다!");
      Navigator.pushNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("예산 등록에 실패했습니다. 다시 시도해주세요.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.grey50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("한 달 예산을 세워봐요!", style: AppFonts.title1_sb),
                          const SizedBox(height: 1),
                          Text("평균적인 값으로 세우면 돼요~", style : AppFonts.body2Rg.copyWith(color: AppColors.grey400 )),
                        ],
                      ),
                    ),
                    Image.asset('assets/mooney.png', width: 100 ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child : Column(
                  children: [
                    const SizedBox(height: 18),
                    ...widget.fixedExpenseEntries.map((entry) => BudgetItem(title: "[고정 지출] ${entry.type}", amount: entry.amount)),
                    ...widget.fixedSavingEntries.map((entry) => BudgetItem(title: "[고정 저축] ${entry.type}", amount: entry.amount)),
                    const SizedBox(height: 8,),
                    const Divider(thickness: 2, height: 1, color: AppColors.grey100),
                    const SizedBox(height: 8,),
                    BudgetItem(title: "고정비", amount: totalFixedExpense + totalFixedSaving),
                  ],
                )
              ),

              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text("총 예산", style: AppFonts.title2_sb),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _budgetController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "",
                        ),
                        onChanged: _onBudgetChanged,
                        style: AppFonts.title2_sb.copyWith(color: AppColors.primaryPurple),
                      ),
                    ),
                    Text("원", style: AppFonts.title2_sb.copyWith(color: AppColors.primaryPurple)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_isCategoryBudgetVisible) ...[
                StatefulBuilder(
                  builder: (context, setState) {
                    return CategoryBudgetAllocation(
                        remainingBudget: _remainingBudget,
                        onCategoryBudgetChanged: _onCategoryBudgetChanged,
                    );
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _isLoading ? null : _submitBudget, // ✅ 로딩 중이면 비활성화
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white) // ✅ 로딩 표시
                        : const Text("완료", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),

              ],
            ],
          ),
        ),
      ),
    );
  }
}
