import 'package:mooney2/services/api_client.dart';
import 'package:mooney2/constants/expense_category.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class BudgetService {
  static Future<Map<String, dynamic>> fetchBudgetData(DateTime date, DateTime today) async {
    try {
      final response = await apiClient.dio.get(
        '/budgets/progress',
        queryParameters: {
          'year': date.year,
          'month': date.month,
          'today': DateFormat('yyyy-MM-dd').format(today),        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('예산진행 요청 성공: ${jsonEncode(response.data)}');
        return {
          'remainingBudgetAmount': data['remainingBudgetAmount'] ?? 0,
          'dailyBudgetAmount': data['dailyBudgetAmount'] ?? 0, // ✅ 백엔드에서 받은 하루 예산 사용
          'monthlyBudgetAmount': data['monthlyBudgetAmount'] ?? 0,
          'pendingExpenseAmount': data['pendingExpenseAmount'] ?? 0,
          'totalExpenseAmount': data['totalExpenseAmount'] ?? 0,
          'categoryBudgets': (data['categoryBudgets'] as List?)?.map((category) {
            return {
              'expenseCategory': ExpenseCategoryExtension.fromString(category['expenseCategory']).label,
              'emoji': ExpenseCategoryExtension.fromString(category['expenseCategory']).emoji,
              'budgetAmount': category['budgetAmount'] ?? 0,
              'spentAmount': category['spentAmount'] ?? 0,
              'spentPercentage': category['spentPercentage'] ?? 0.0,
              'remainingAmount': category['remainingAmount'] ?? 0,
            };
          }).toList() ?? [],
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
