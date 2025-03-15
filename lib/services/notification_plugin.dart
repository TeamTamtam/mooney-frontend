// lib/notification_plugin.dart
import 'package:flutter/services.dart';
import 'package:mooney2/models/transaction_notification.dart';
import 'package:mooney2/services/auth_service.dart';
import 'package:mooney2/services/pending_transaction_service.dart';
import 'package:mooney2/utils/transaction_parser.dart';
import 'package:mooney2/services/transaction_api_service.dart';

class NotificationPlugin {
  // 네이티브(NotificationService)와 통신할 채널 이름 (임의로 정함)
  static const MethodChannel _channel = MethodChannel('notification_channel');

  static final List<String> _transactionKeywords = [
    "결제", "승인", "체크카드", "사용", "승인완료", "출금", "일시불", "입금"
  ];


  static bool _isListening = false;

  static void startListening() async {
    if (_isListening) return;
    _isListening = true;

    final bool loggedIn = await authService.isLoggedIn();

    // 🔥 로그인 후 보류된 알림 전송
    if (loggedIn) {
      print("🔄 로그인 후 보류된 결제 알림을 처리 중...");
      List<TransactionNotification> pendingTransactions =
      await PendingTransactionService.getPendingTransactions();
      for (var transaction in pendingTransactions) {
        await _sendTransactionToApi(transaction);
      }
      await PendingTransactionService.clearPendingTransactions(); // 🔥 보낸 후 삭제
    }

    _channel.setMethodCallHandler((call) async {
      if (call.method == "notificationPosted") {
        final Map<dynamic, dynamic> notificationData = call.arguments;
        final String tickerText = notificationData['tickerText']?.replaceAll("\n", " ") ?? '';
        final String title = notificationData['title'] ?? '';
        final String text = notificationData['text'] ?? '';

        final bool isTransaction = _transactionKeywords.any((keyword) =>
        tickerText.contains(keyword) || text.contains(keyword));

        if (isTransaction) {
          final transaction = TransactionNotification(
            packageName: notificationData['packageName'] ?? '',
            notificationId: notificationData['notificationId'] ?? 0,
            title: title,
            text: text,
            tickerText: tickerText,
          );

          print("✅ 결제 알림 도착: $transaction");

          if (loggedIn) {
            await _sendTransactionToApi(transaction);
          } else {
            print("🚀 로그인 전이므로 보류된 결제 알림 저장");
            await PendingTransactionService.savePendingTransaction(transaction);
          }
        }
      }
    });
  }

  // 🔥 API 전송 (apiClient 자동 토큰 관리)
  static Future<void> _sendTransactionToApi(TransactionNotification transaction) async {
    final transactionJson = TransactionParser.parseTransaction(transaction);
    print('파싱된 객체 : ${transactionJson} ');
    // ✅ 결제 or 수입을 구분하여 API 전송
    if (transactionJson.containsKey("payer")) {
      await TransactionApiService.sendIncomeTransaction(transactionJson);
    } else {
      await TransactionApiService.sendExpenseTransaction(transactionJson);
    }
  }
}
