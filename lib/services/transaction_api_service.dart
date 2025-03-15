import 'dart:convert';
import 'package:mooney2/services/api_client.dart'; // ✅ apiClient 사용
import 'package:dio/dio.dart';

// class TransactionApiService {
//   static Future<void> sendTransaction(Map<String, dynamic> transactionJson) async {
//     try {
//       final response = await apiClient.dio.post(
//         "/transactions/expenses",
//         data: jsonEncode(transactionJson),
//       );
//
//       if (response.statusCode == 200) {
//         print("✅ 트랜잭션 API 전송 성공: ${response.data}");
//       } else {
//         print("❌ 트랜잭션 API 전송 실패: ${response.statusCode} ${response.data}");
//       }
//     } catch (e) {
//       print("❌ API 요청 중 오류 발생: $e");
//     }
//   }
// }

class TransactionApiService {
  static Future<void> sendExpenseTransaction(Map<String, dynamic> transactionJson) async {
    try {
      final response = await apiClient.dio.post(
        "/transactions/expenses",
        data: jsonEncode(transactionJson),
      );

      if (response.statusCode == 200) {
        print("✅ 지출 API 전송 성공: ${response.data}");
      } else {
        print("❌ 지출 API 전송 실패: ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      print("❌ 지출 API 요청 중 오류 발생: $e");
    }
  }

  static Future<void> sendIncomeTransaction(Map<String, dynamic> transactionJson) async {
    try {
      final response = await apiClient.dio.post(
        "/transactions/incomes",
        data: jsonEncode(transactionJson),
      );

      if (response.statusCode == 200) {
        print("✅ 수입 API 전송 성공: ${response.data}");
      } else {
        print("❌ 수입 API 전송 실패: ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      print("❌ 수입 API 요청 중 오류 발생: $e");
    }
  }
}
