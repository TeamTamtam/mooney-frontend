
import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/screens/first_budget/models/fixed_budget.dart';

class FixedBudgetInput extends StatefulWidget {
  final String title;

  final Function(List<FixedBudgetEntry>) onEntriesChanged; // ✅ 개별 항목 리스트 전달

  const FixedBudgetInput({super.key, required this.title, required this.onEntriesChanged});


  @override
  _FixedBudgetInputState createState() => _FixedBudgetInputState();
}

class _FixedBudgetInputState extends State<FixedBudgetInput> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController periodController = TextEditingController();

  List<FixedBudgetEntry> entries = []; // Model 리스트
  int totalAmount = 0; // ✅ 총합 상태 변수 추가


  void _updateEntries() {
    widget.onEntriesChanged(entries); // ✅ 상위 위젯에 전달
  }
  void _addEntry() {
    setState(() {
      if (typeController.text.isNotEmpty &&
          amountController.text.isNotEmpty &&
          periodController.text.isNotEmpty) {
        entries.add(FixedBudgetEntry(
          type: typeController.text,
          amount: int.tryParse(amountController.text.replaceAll(',', '')) ?? 0, // 숫자로 변환
          period: periodController.text,
        ));

        // 입력 필드 초기화
        typeController.clear();
        amountController.clear();
        periodController.clear();
        _updateEntries();
      }
    });
  }

  //엔트리 삭제(엑스 버튼)
  void _removeEntry(int index) {
    setState(() {
      entries.removeAt(index);
      _updateEntries();
    });
  }

  // 총합 계산 함수
  int getTotalAmount() {
    return entries.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 총합 표시 추가
          Text(
            "${widget.title}: ${entries.isNotEmpty ? '${getTotalAmount()}원' : ''}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),

          // 입력된 리스트 UI
          Column(
            children: entries.asMap().entries.map((entry) {
              int index = entry.key;
              FixedBudgetEntry data = entry.value;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.lightPurple2,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data.type,
                            style: const TextStyle(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${data.amount}원 | ${data.period}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey400,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _removeEntry(index),
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }).toList(),

          ),


          const SizedBox(height: 5),

          // 입력 필드
          Row(
            children: [
              FixedInputField(label: '유형', controller: typeController, keyboardType: TextInputType.text),
              const SizedBox(width: 7),
              FixedInputField(label: '금액', controller: amountController, keyboardType: TextInputType.text),
              const SizedBox(width: 7),
              FixedInputField(label: '주기', controller: periodController, keyboardType: TextInputType.text),
              const SizedBox(width: 7),
              ElevatedButton(
                onPressed: _addEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF3F4F6),
                  minimumSize: const Size(55, 38),
                  foregroundColor: AppColors.grey400,
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    // side: const BorderSide(color: Colors.grey),
                  ),
                ),
                child: const Text('확인', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FixedInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const FixedInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 87,
      height : 35,// 필드 크기 조절
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enableSuggestions: false,
        autocorrect: false,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: AppColors.grey400),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.grey100),
          ),
        ),
      ),
    );
  }
}

