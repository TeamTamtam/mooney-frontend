import 'package:mooney2/services/api_client.dart';
import 'package:mooney2/constants/expense_category.dart';
import 'package:intl/intl.dart';

class BudgetService {
  Future<Map<String, dynamic>> fetchBudgetPlan(int year, int month) async {
    try {
      final response = await apiClient.dio.get(
        '/budgets/plan',
        queryParameters: {'year': year, 'month': month},
      );
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // 고정 지출 데이터 변환
        List<Map<String, dynamic>> fixedExpenses = [
          ...(data['fixedExpense'] as List<dynamic>? ?? []).map((expense) => {
            'type': '고정 지출',
            'name': expense['title'],
            'amount': expense['amount'],
          }),
          ...(data['fixedSavings'] as List<dynamic>? ?? []).map((saving) => {
            'type': '고정 저축',
            'name': saving['title'],
            'amount': saving['amount'],
          }),
        ];

        // 카테고리 예산 데이터 변환
        List<Map<String, dynamic>> categoryBudgets =
        (data['categoryBudgets'] as List<dynamic>? ?? [])
            .map<Map<String, dynamic>>((c) {
          ExpenseCategory categoryEnum =
          ExpenseCategoryExtension.fromString(c['expenseCategory']);
          return {
            'category': categoryEnum.label,
            'emoji': categoryEnum.emoji,
            'budget': c['amount'],
            'lastMonth': c['lastMonthExpenseAmount'] ?? 0,
            'formattedBudget': NumberFormat('#,###').format(c['amount']),
          };
        }).toList();

        return {
          'monthlyBudget': data['monthlyBudgetAmount'],
          'fixedExpenses': fixedExpenses,
          'categories': categoryBudgets,
        };
      } else {
        throw Exception('Failed to load budget data');
      }
    } catch (e) {
      print('Error fetching budget data: $e');
      throw Exception('Error fetching budget data');
    }
  }
  /// ✅ 예산 수정 API (PATCH)
  Future<void> updateBudgetPlan({
    required int year,
    required int month,
    required int totalBudget,
    required List<Map<String, dynamic>> categories,
  }) async {
    try {
      final requestBody = {
        "year": year,
        "month": month,
        "monthlyBudgetAmount": totalBudget,
        "categoryBudgets": categories.map((c) => {
          "expenseCategory": ExpenseCategoryExtension.toEnum(c['category']), // 한글 카테고리명 → ENUM 변환
          "amount": c['budget']
        }).toList(),
      };

      final response = await apiClient.dio.patch(
        '/budgets/plan',
        data: requestBody,
      );

      if (response.statusCode == 200) {
        print("예산 수정 성공!");
      } else {
        throw Exception("예산 수정 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("예산 수정 중 오류 발생: $e");
      throw Exception("예산 수정 중 오류 발생");
    }
  }
}


final budgetService = BudgetService();
