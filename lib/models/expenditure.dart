class Expenditure {
  final String title;
  final String amount;
  final DateTime dateTime;
  final String category;
  final String transactionSource;

  Expenditure({
    required this.title,
    required this.amount,
    required this.dateTime,
    required this.category,
    required this.transactionSource
  });
}