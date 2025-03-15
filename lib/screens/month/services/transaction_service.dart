import 'package:mooney2/services/api_client.dart';
import 'package:mooney2/models/expenditure.dart';
import 'package:mooney2/constants/expense_category.dart';

class TransactionService {
  /// ✅ 월별 거래 내역 가져오기 API 요청
  Future<Map<String, dynamic>> fetchMonthlyTransactions(int year, int month) async {
    try {
      final response = await apiClient.dio.get(
        '/transactions/monthly',
        queryParameters: {"year": year, "month": month},
      );

      if (response.statusCode == 200) {
        print("✅ 요청 성공: 월별 거래 내역 불러옴");
        final data = response.data;

        return {
          "totalIncomeAmount": data["totalIncomeAmount"] ?? 0,  // ✅ 전체 수입
          "totalExpenseAmount": data["totalExpenseAmount"] ?? 0, // ✅ 전체 지출
          "dailySummaries": List<Map<String, dynamic>>.from(data["dailySummaries"] ?? []), // ✅ 일별 요약
        };
      }
    } catch (e) {
      print("❌ API 요청 실패: $e");
    }
    return {
      "totalIncomeAmount": 0,
      "totalExpenseAmount": 0,
      "dailySummaries": [],
    }; // 실패 시 기본값 반환
  }
  Future<Map<String, dynamic>> fetchDailyTransactions(DateTime date) async {
    try {
      final response = await apiClient.dio.get(
        '/transactions/daily',
        queryParameters: {
          'date': "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
        List<Expenditure> transactions = [];

        // ✅ 수입 데이터 매핑
        for (var income in data["incomes"]) {
          transactions.add(
            Expenditure(
              title: income["note"] ?? "수입",
              amount: "+${income["amount"]}",
              dateTime: DateTime.parse(income["transactionTime"]),
              category: "FINANCE", // 수입은 금융 카테고리로 설정
              transactionSource: income["transactionSource"],
            ),
          );
        }

        // ✅ 지출 데이터 매핑
        for (var expense in data["expenses"]) {
          transactions.add(
            Expenditure(
              title: expense["note"] ?? "지출",
              amount: "${expense["amount"]}",
              dateTime: DateTime.parse(expense["transactionTime"]),
              category: expense["expenseCategory"],
              transactionSource: expense["transactionSource"],
            ),
          );
        }

        return {
          "date": data["date"],
          "totalIncomeAmount": data["totalIncomeAmount"],
          "totalExpenseAmount": data["totalExpenseAmount"],
          "transactions": transactions,
        };
      }
    } catch (e) {
      print("❌ 거래 내역 불러오기 실패: $e");
    }
    return {
      "date": "",
      "totalIncomeAmount": 0,
      "totalExpenseAmount": 0,
      "transactions": [],
    };
  }
}

// ✅ 전역 인스턴스
final transactionService = TransactionService();
