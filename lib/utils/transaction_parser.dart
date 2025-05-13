import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mooney2/models/transaction_notification.dart'; // TransactionNotification 모델 임포트

class TransactionParser {
  static Map<String, dynamic> parseTransaction(TransactionNotification notification) {
    final String text = "${notification.tickerText} ${notification.text}".replaceAll("\n", " ");

    // ✅ "입금", "급여"가 포함된 경우 수입(income)으로 처리
    bool isIncome = text.contains("입금") || text.contains("급여");
    // 1️⃣ 전화번호 및 계좌번호 제거 (하이픈 포함된 숫자)
    final phoneNumberRegExp = RegExp(r'\(?\d{2,4}\)?[-.\s]?\d{3,4}[-.\s]?\d{4}');
    final cleanedText = text.replaceAll(phoneNumberRegExp, "");

    // 2️⃣ 날짜 및 시간 패턴 제거 (MM/DD HH:mm, YYYY-MM-DD 등)
    final dateTimeRegExp = RegExp(r'\b\d{2}/\d{2} \d{2}:\d{2}\b|\b\d{4}-\d{2}-\d{2}\b');
    final cleanedTextWithoutDates = cleanedText.replaceAll(dateTimeRegExp, "");

    // 3️⃣ (숫자)원 패턴 우선 선택
    final amountWithWonRegExp = RegExp(r'\b\d{1,3}(,\d{3})*\b원');
    List<String> amountsWithWon = amountWithWonRegExp.allMatches(cleanedTextWithoutDates)
        .map((m) => m.group(0)!.replaceAll("원", "").replaceAll(",", ""))
        .toList();

    // 4️⃣ (숫자)원 패턴이 있으면 그것을 사용
    String amount;
    if (amountsWithWon.isNotEmpty) {
      amount = amountsWithWon.first;
    } else {
      // 5️⃣ (숫자)원 패턴이 없을 경우 쉼표 포함 숫자 탐색
      final amountWithCommaRegExp = RegExp(r'\b\d{1,3}(,\d{3})+\b');
      List<String> amountsWithComma = amountWithCommaRegExp.allMatches(cleanedTextWithoutDates)
          .map((m) => m.group(0)!.replaceAll(",", ""))
          .toList();

      amount = amountsWithComma.isNotEmpty ? amountsWithComma.first : "0";
    }


    // transactionTime 추출 (MM/DD HH:mm 형식 찾기)
    final timeRegExp = RegExp(r'\b(\d{2}/\d{2}) (\d{2}:\d{2})\b'); // 03/02 13:52 형식
    final match = timeRegExp.firstMatch(text);

    String transactionTime;
    if (match != null) {
      String datePart = match.group(1)!; // MM/DD
      String timePart = match.group(2)!; // HH:mm

      // 현재 연도 가져오기
      int currentYear = DateTime.now().year;

      // MM/DD → yyyy-MM-dd 변환
      DateTime parsedDate = DateFormat("MM/dd HH:mm").parse("$datePart $timePart");
      DateTime transactionDateTime = DateTime(currentYear, parsedDate.month, parsedDate.day, parsedDate.hour, parsedDate.minute);

      // ✅ 한국 시간으로 그대로 유지된 상태에서 ISO 8601 포맷 적용 (Z 없음)
      transactionTime = transactionDateTime.toIso8601String();
    } else {
      transactionTime = "2025-03-01T09:02:26.077Z"; // 기본값
    }

    // transactionSource 추출 (체크 or 신용 포함, 없으면 입금/출금 포함)
    final sourceRegExp = RegExp(r'(\S*체크|\S*신용|\S*입금|\S*출금)');
    String transactionSource = sourceRegExp.firstMatch(text)?.group(0) ?? "알 수 없음";

    // sourceApp 추출 (web발신이 있으면 SMS, 없으면 APP)
    String sourceApp = text.contains("Web발신") ? "sms" : "app";

    // payee (결제처) 추출 (금액 뒤에 나오는 단어들)
    // 1️⃣ "매장명 사용" 패턴 최우선 선택
    String payeeOrPayer = "";
    final payeeUsageRegExp = RegExp(r'(\S+)\s+사용');
    payeeOrPayer = payeeUsageRegExp.firstMatch(text)?.group(1) ?? "";
    // 2️⃣ "매장명 사용"이 없을 경우 데이터 정제 시작
    if (payeeOrPayer.isEmpty) {
      String filteredText = text;

      // ✅ 2-1: 날짜 (`03/02`, `2024-01-01` 등) 제거
      filteredText = filteredText.replaceAll(RegExp(r'\b\d{2}/\d{2}\b|\b\d{4}-\d{2}-\d{2}\b'), "");

      // ✅ 2-2: 시간 (`13:52`, `09:00 AM` 등) 제거
      filteredText = filteredText.replaceAll(RegExp(r'\b\d{2}:\d{2}\s*(AM|PM)?\b'), "");

      // ✅ 2-3: 계좌번호 (`1234-5678-9012-3456`, `02-123-4567` 등) 제거
      filteredText = filteredText.replaceAll(RegExp(r'\(?\d{2,4}\)?[-.\s]?\d{3,4}[-.\s]?\d{4}'), "");

      // ✅ 2-4: 금융 관련 단어 (`체크`, `신용`, `입금`, `출금`, `잔액`) 제거
      filteredText = filteredText.replaceAll(RegExp(r'\S*(체크|신용|입금|출금|입출금|잔액)\S*'), "");

      // ✅ 2-5: 숫자로만 이뤄진 단어 (`10000`, `1234` 등) 제거
      filteredText = filteredText.replaceAll(RegExp(r'\b\d+\b'), "");

      // ✅ 2-6: '*'이 포함된 단어 제거
      filteredText = filteredText.replaceAll(RegExp(r'\S*\*\S*'), "");

      // ✅ 2-7: 최소 한 글자 이상의 한글 또는 영문 문자가 포함된 단어만 추출
      List<String> words = filteredText.split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty && RegExp(r'[\p{L}]', unicode: true).hasMatch(word))
          .toList();

      payeeOrPayer = words.isNotEmpty ? words.first : "알 수 없음";
    }

    if (isIncome) {
      return {
        "amount": int.tryParse(amount) ?? 0,
        "transactionTime": transactionTime,
        "transactionSource": transactionSource,
        "sourceApp": sourceApp,
        "payer": payeeOrPayer,
      };
    } else {
      return {
        "amount": int.tryParse(amount) ?? 0,
        "transactionTime": transactionTime,
        "transactionSource": transactionSource,
        "sourceApp": sourceApp,
        "payee": payeeOrPayer,
      };
    }
  }
}
