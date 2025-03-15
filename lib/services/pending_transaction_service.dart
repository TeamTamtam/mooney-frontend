import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_notification.dart';

class PendingTransactionService {
  static const String _pendingKey = "pending_transactions";

  // 🔥 로그인 전 수신한 알림을 저장
  static Future<void> savePendingTransaction(TransactionNotification transaction) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList(_pendingKey) ?? [];
    transactions.add(jsonEncode(transaction.toJson())); // JSON으로 변환 후 저장
    await prefs.setStringList(_pendingKey, transactions);
  }

  // 🔥 저장된 알림 가져오기 (로그인 후 API로 전송)
  static Future<List<TransactionNotification>> getPendingTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList(_pendingKey) ?? [];
    return transactions.map((json) => TransactionNotification.fromJson(jsonDecode(json))).toList();
  }

  // 🔥 저장된 알림 삭제 (로그인 후 API 전송 완료 시 호출)
  static Future<void> clearPendingTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingKey);
  }
}

