import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../widgets/total_budget_widget.dart';
import 'package:mooney2/constants/colors.dart';
import '../widgets/category_budget_edit_widget.dart';
import '../widgets/fixed_budget_widget.dart';
import '../services/budget_edit_service.dart';


class BudgetEditScreen extends StatefulWidget {
  @override
  _BudgetEditScreenState createState() => _BudgetEditScreenState();
}

class _BudgetEditScreenState extends State<BudgetEditScreen> {
  late TextEditingController _totalBudgetController;
  int? _totalBudget;
  int _totalFixedExpense = 500000;
  late Map<String, TextEditingController> _categoryControllers;
  bool _isLoading = true;
  late DateTime selectedMonth;

  List<Map<String, dynamic>> fixedExpenses = [
    {'type': '고정 지출', 'name': '월세', 'amount': 300000},
    {'type': '고정 지출', 'name': 'OTT', 'amount': 50000},
    {'type': '고정 저축', 'name': '적금', 'amount': 50000},
  ];

  List<Map<String, dynamic>> categories = [];


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedMonth = ModalRoute.of(context)?.settings.arguments as DateTime? ?? DateTime.now();
    _fetchBudgetData();
  }

  @override
  void initState() {
    super.initState();
    _totalBudgetController = TextEditingController();
    _categoryControllers = {};
  }

  Future<void> _fetchBudgetData() async {
    int year = selectedMonth.year;
    int month = selectedMonth.month;
    try {
      final budgetData = await budgetService.fetchBudgetPlan(year, month);
      setState(() {
        _totalBudget = budgetData['monthlyBudget'];
        _totalBudgetController.text = NumberFormat('#,###').format(_totalBudget!);
        categories = budgetData['categories'];

        // 각 카테고리의 예산을 컨트롤러에 설정
        _categoryControllers = {
          for (var c in categories)
            c['category']: TextEditingController(text: c['formattedBudget'])
        };

        _isLoading = false;
      });
    } catch (e) {
      print("예산 데이터를 불러오는 중 오류 발생: $e");
      setState(() {
        _totalBudget = 0;
        _isLoading = false;
      });
    }
  }



  @override
  void dispose() {
    _totalBudgetController.dispose();
    _categoryControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _updateTotalBudget(String value) {
    setState(() {
      _totalBudget = int.tryParse(value.replaceAll(',', '')) ?? 0;
      _totalBudgetController.text = NumberFormat('#,###').format(_totalBudget);
    });
  }

  void _onSubmit() {
    // 총 예산과 카테고리별 예산을 포함한 데이터 전송 준비
    Map<String, dynamic> budgetData = {
      'totalBudget': _totalBudget,
      'categories': categories.map((c) => {
        'category': c['category'],
        'budget': int.tryParse(_categoryControllers[c['category']]!.text.replaceAll(',', '')) ?? 0,
      }).toList(),
    };

    print("전송할 데이터: $budgetData");
  }

  @override
  Widget build(BuildContext context) {
    final selectedMonth = ModalRoute.of(context)?.settings.arguments as DateTime? ?? DateTime.now();
    String formattedMonth = DateFormat('yyyy년 M월').format(selectedMonth);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.grey50,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.grey50,
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$formattedMonth 예산',
                style: TextStyle(
                  color: Color(0xFF202020),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TotalBudgetWidget(
                totalBudgetController: _totalBudgetController,
                onBudgetChanged: _updateTotalBudget,
              ),
              const SizedBox(height: 12),
              FixedExpenseWidget(
                totalFixedExpense: _totalFixedExpense,
                fixedExpenses: fixedExpenses,
              ),
              const SizedBox(height: 12),
              CategoryBudgetWidget(
                totalBudget: _totalBudget ?? 0,
                totalFixedExpense: _totalFixedExpense,
                categories: categories,
                categoryControllers: _categoryControllers,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _onSubmit,
                  child: const Text("완료", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}