class TransactionNotification {
  final String packageName;
  final int notificationId;
  final String title;
  final String text;
  final String tickerText;

  TransactionNotification({
    required this.packageName,
    required this.notificationId,
    required this.title,
    required this.text,
    required this.tickerText,
  });

  @override
  String toString() {
    return 'TransactionNotification(title: $title, text: $text, tickerText: $tickerText)';
  }

  // JSON 변환 추가
  Map<String, dynamic> toJson() {
    return {
      "packageName": packageName,
      "notificationId": notificationId,
      "title": title,
      "text": text,
      "tickerText": tickerText,
    };
  }

  factory TransactionNotification.fromJson(Map<String, dynamic> json) {
    return TransactionNotification(
      packageName: json["packageName"],
      notificationId: json["notificationId"],
      title: json["title"],
      text: json["text"],
      tickerText: json["tickerText"],
    );
  }
}

