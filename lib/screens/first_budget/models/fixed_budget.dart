class FixedBudgetEntry {
  final String type; //유형
  final int amount; //금액
  final String period; //주기
//매달 5일, 월세
  FixedBudgetEntry({required this.type, required this.amount, required this.period});

  // JSON 변환을 위한 toJson 함수 (API 전송 시 사용)
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "amount": amount,
      "period": period,
    };
  }
}

