import 'package:dio/dio.dart';
import 'package:mooney2/services/api_client.dart';
import 'package:mooney2/constants/expense_category.dart';
import 'package:mooney2/screens/first_budget/models/fixed_budget.dart';

class FirstBudgetService {
  /// ✅ 첫 달 예산 저장 API 요청
  Future<bool> submitFirstBudget({
    required List<FixedBudgetEntry> fixedIncome,
    required List<FixedBudgetEntry> fixedExpense,
    required List<FixedBudgetEntry> fixedSavings,
    required int totalBudget,
    required Map<ExpenseCategory, int> categoryBudgets,
  }) async {
    final requestBody = {
      "year": DateTime.now().year,
      "month": DateTime.now().month,
      "fixedIncome": fixedIncome.map((e) => {
        "title": e.type,
        "amount": e.amount,
        "period": "monthly"
      }).toList(),
      "fixedExpense": fixedExpense.map((e) => {
        "title": e.type,
        "amount": e.amount,
        "period": "monthly"
      }).toList(),
      "fixedSavings": fixedSavings.map((e) => {
        "title": e.type,
        "amount": e.amount,
        "period": "monthly"
      }).toList(),
      "monthlyBudgetAmount": totalBudget,
      "categoryBudgets": categoryBudgets.entries
          .where((entry) => entry.value > 0) // 0이 아닌 값만 전송
          .map((entry) => {
        "expenseCategory": entry.key.name, // ENUM을 API 요청 형식으로 변환
        "amount": entry.value
      }).toList()
    };

    try {
      final response = await apiClient.dio.post(
        '/budgets/first-budget',
        data: requestBody,
      );

      if (response.statusCode == 200) {
        print("✅ 예산 등록 성공: ${response.data}");
        return true;
      } else {
        print("❌ 예산 등록 실패: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ API 요청 중 오류 발생: $e");
      return false;
    }
  }
}

// ✅ 전역 인스턴스
final firstBudgetService = FirstBudgetService();
