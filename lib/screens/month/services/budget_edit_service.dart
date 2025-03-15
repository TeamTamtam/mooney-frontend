import 'package:dio/dio.dart';
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

        return {
          'monthlyBudget': data['monthlyBudgetAmount'],
          'categories': data['categoryBudgets'].map<Map<String, dynamic>>((c) {
            ExpenseCategory categoryEnum = ExpenseCategoryExtension.fromString(c['expenseCategory']);
            return {
              'category': categoryEnum.label,
              'emoji': categoryEnum.emoji,
              'budget': c['amount'],
              'lastMonth': c['lastMonthExpenseAmount'] ?? 0,
              'formattedBudget': NumberFormat('#,###').format(c['amount']), // 포맷된 값 추가
            };
          }).toList(),
        };
      } else {
        throw Exception('Failed to load budget data');
      }
    } catch (e) {
      print('Error fetching budget data: $e');
      throw Exception('Error fetching budget data');
    }
  }
}

final budgetService = BudgetService();