class RemainedBudget {
  final String remainedAmount; //이번주남은예산
  final String weekBudget; //이번주예산
  final String expenditure ; //오늘까지지출
  final String willExpend; //예정된지출
  final String dayBudget; //1일예산
  final String percent;

  RemainedBudget({
    required this.remainedAmount,
    required this.weekBudget,
    required this.expenditure,
    required this.willExpend,
    required this.dayBudget,
    required this.percent,
  });
}