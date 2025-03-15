import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/models/expenditure.dart';
import 'package:mooney2/widgets/expenditure_income_box.dart';
import '../services/transaction_service.dart';
import 'package:mooney2/constants/app_fonts.dart';

class ExpenseIncomeTab extends StatefulWidget {
  const ExpenseIncomeTab({super.key});

  @override
  State<ExpenseIncomeTab> createState() => _ExpenseIncomeTabState();
}

class _ExpenseIncomeTabState extends State<ExpenseIncomeTab> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  //월 내역 조회
  List<Map<String, dynamic>> _dailySummaries = []; // ✅ API에서 받은 날짜별 수입/지출 합계 데이터 저장
  int _totalIncome = 0; // ✅ 월별 수입 총액
  int _totalExpense = 0; // ✅ 월별 지출 총액
  //일 내역 조회
  List<Expenditure> _dailyTransactions = [];
  int _dailyIncome = 0;
  int _dailyExpense = 0;


  // Format currency with comma separator
  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},'
    );
  }

  Future<void> _fetchTransactionsData() async {
    final year = _focusedDate.year;
    final month = _focusedDate.month;

    final response = await transactionService.fetchMonthlyTransactions(year, month);

    setState(() {
      _totalIncome = response["totalIncomeAmount"]; // ✅ 수입 총액 업데이트
      _totalExpense = response["totalExpenseAmount"]; // ✅ 지출 총액 업데이트
      _dailySummaries = response["dailySummaries"]; // ✅ 일별 요약 데이터 업데이트
    });
  }

  Future<void> _fetchDailyTransactions() async {
    final response = await transactionService.fetchDailyTransactions(_selectedDate);

    setState(() {
      _dailyIncome = response["totalIncomeAmount"];
      _dailyExpense = response["totalExpenseAmount"];
      _dailyTransactions = response["transactions"];
    });
  }


  @override
  void initState() {
    super.initState();
    _fetchTransactionsData(); // ✅ 초기 데이터 가져오기
    _fetchDailyTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendarHeader(),
        _buildIncomeExpenseSummary(),
        const SizedBox(height: 18,),
        _buildCalendarGrid(),
        const Divider(
          height: 15,
          thickness: 10, // 두께 조절
          color: AppColors.grey50,
        ),
        Expanded(
          child: _buildTransactionList(),
        ),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return CalendarHeader(
      focusedDate: _focusedDate,
      onPreviousMonth: () {
        setState(() {
          _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
        });
        _fetchTransactionsData(); // ✅ 월 변경 시 다시 요청
      },
      onNextMonth: () {
        setState(() {
          _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
        });
        _fetchTransactionsData(); // ✅ 월 변경 시 다시 요청
      },
    );
  }

  /// ✅ 수입/지출 요약 표시 위젯
  Widget _buildIncomeExpenseSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIncomeExpenseBox("수입", _totalIncome, Colors.blue),
          const  SizedBox(width: 8,),
          _buildIncomeExpenseBox("지출", _totalExpense, Colors.red),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseBox(String label, int amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppFonts.body2Rg.copyWith(color: AppColors.grey600),
            ),
            Text(
              '${_formatCurrency(amount)}원',
              textAlign: TextAlign.right,
              style: AppFonts.body2Sb.copyWith(color: AppColors.grey600),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return CalendarGrid(
      focusedDate: _focusedDate,
      selectedDate: _selectedDate,
      onDateSelected: (date) {
        setState(() {
          _selectedDate = date;
        });
        _fetchDailyTransactions(); // ✅ 날짜 선택 시 API 다시 호출
      },
      dailySummaries: _dailySummaries, // ✅ API에서 받은 날짜별 요약 데이터 전달
    );
  }

  Widget _buildTransactionList() {
    return ListView(
      padding: const EdgeInsets.all(18.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedDate.month}월 ${_selectedDate.day}일',
              style: AppFonts.body1Sb
            ),
            Row(
              children: [
                if (_dailyIncome > 0)
                  Text('+$_dailyIncome원', style: AppFonts.body2Rg.copyWith(color: AppColors.secondaryBlue)),
                if (_dailyIncome > 0 && _dailyExpense > 0)
                  const Text('    '),
                if (_dailyExpense > 0)
                  Text('-$_dailyExpense원', style: AppFonts.body2Rg.copyWith(color: Color(0xFF202020))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._dailyTransactions.map((tx) => ExpenditureBox(expenditure: tx)).toList(),
      ],
    );
  }
}


String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }


class CalendarHeader extends StatelessWidget {
  final DateTime focusedDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const CalendarHeader({
    required this.focusedDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  icon: const Icon(Icons.chevron_left),
                  onPressed: onPreviousMonth),
              Text(
                '${focusedDate.year}년 ${focusedDate.month}월',
                style : AppFonts.title2_sb
              ),
              IconButton(icon: const Icon(Icons.chevron_right), onPressed: onNextMonth),
            ],
          ),
        ],
      ),
    );
  }
}

class CalendarGrid extends StatelessWidget {
  final DateTime focusedDate;
  final DateTime selectedDate;
  // final Map<String, List<Expenditure>> transactions;
  final ValueChanged<DateTime> onDateSelected;
  final List<Map<String, dynamic>> dailySummaries;

  const CalendarGrid({
    required this.focusedDate,
    required this.selectedDate,
    required this.onDateSelected,
    // required this.transactions,
    required this.dailySummaries,
    Key? key,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        _buildWeekdayHeader(),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,  // 날짜와 금액을 모두 표시할 수 있도록 조정
          ),
          itemCount: 35, //42
          itemBuilder: (context, index) {
            final int day = index - firstWeekday + 1;
            if (day < 1 || day > daysInMonth) {
              return const SizedBox.shrink();
            }

            final date = DateTime(focusedDate.year, focusedDate.month, day);
            final dateString = _formatDate(date);
            // final transactionsForDay = transactions[dateString] ?? [];
            // ✅ API 데이터가 없으면 기본값 0으로 설정
            final dailySummary = dailySummaries.firstWhere(
                  (summary) => summary['date'] == dateString,
              orElse: () => {"totalIncomeAmount": 0, "totalExpenseAmount": 0},
            );


            final int income = dailySummary.isNotEmpty ? dailySummary["totalIncomeAmount"] : 0;
            final int expense = dailySummary.isNotEmpty ? dailySummary["totalExpenseAmount"] : 0;

            final isSelected = selectedDate.year == date.year &&
                selectedDate.month == date.month &&
                selectedDate.day == date.day;
            final isToday = DateTime.now().year == date.year &&
                DateTime.now().month == date.month &&
                DateTime.now().day == date.day;

            return GestureDetector(
              onTap: () => onDateSelected(date),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isSelected || isToday)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.primaryPurple.withOpacity(0.2)
                                : AppColors.primaryPurple.withOpacity(0.1),
                          ),
                        ),
                      Text(
                        '$day',
                        style: AppFonts.body2Rg.copyWith(color: AppColors.grey400),
                      ),
                    ],
                  ),
                  Text(
                    '-$expense',
                    style: AppFonts.body4Med.copyWith(color: expense > 0 ? AppColors.secondaryBlue : Colors.transparent)
                  ),
                  Text(
                    '+$income',
                      style: AppFonts.body4Med.copyWith(color: income > 0 ? AppColors.grey300 : Colors.transparent)

                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map((day) => Expanded(
        child: Center(
          child: Text(
            day,
            style: AppFonts.body2Rg.copyWith(color: AppColors.grey400),
          ),
        ),
      ))
          .toList(),
    );
  }
}