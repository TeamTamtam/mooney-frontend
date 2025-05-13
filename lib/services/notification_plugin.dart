// lib/notification_plugin.dart
import 'package:flutter/services.dart';
import 'package:mooney2/models/transaction_notification.dart';
import 'package:mooney2/services/auth_service.dart';
import 'package:mooney2/services/pending_transaction_service.dart';
import 'package:mooney2/utils/transaction_parser.dart';
import 'package:mooney2/services/transaction_api_service.dart';

class NotificationPlugin {
  // 네이티브(NotificationService)와 통신할 채널 이름
  static const MethodChannel _channel = MethodChannel('notification_channel');

  static final List<String> _transactionKeywords = [
    "결제", "승인", "체크카드", "사용", "승인완료", "출금", "일시불", "입금"
  ];


  static bool _isListening = false;

  static Future<void> startListening() async {

    print("🔔 NotificationPlugin 리스너 초기화 시작");
    final bool loggedIn = await authService.isLoggedIn();
    if (_isListening) {
      // 🔁 이미 리스닝 중이더라도 로그인 상태면 보류 알림 다시 전송 시도
      if (loggedIn) {
        print("🔄 로그인 후 보류 알림 재전송");
        List<TransactionNotification> pendingTransactions =
        await PendingTransactionService.getPendingTransactions();
        for (var transaction in pendingTransactions) {
          await _sendTransactionToApi(transaction);
        }
        await PendingTransactionService.clearPendingTransactions();
      }
      return;
    }

    _isListening = true;

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


          print("🔍 getaccess token 확인 중...");
          final hasToken = await authService.getAccessToken();
          print("✅ access token 확인 결과: $hasToken");

          if (hasToken != null) {
            try {
              print("api 전송 시도");
              await _sendTransactionToApi(transaction);
            } catch (e) {
              print("❌ 전송 실패. 아마도 토큰 만료? ${e.toString()}");

              // 보류 처리도 가능
              await PendingTransactionService.savePendingTransaction(transaction);

              // refreshToken 만료로 로그아웃 된 상태라면, 여기서 재전송 시도 안 함
            }
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
