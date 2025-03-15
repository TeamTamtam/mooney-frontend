import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/constants/expense_category.dart';
import 'package:mooney2/constants/app_fonts.dart';

class CategoryBudgetAllocation extends StatefulWidget {
  final int remainingBudget;
  final Function(Map<ExpenseCategory, int>) onCategoryBudgetChanged;

  const CategoryBudgetAllocation({
    super.key,
    required this.remainingBudget,
    required this.onCategoryBudgetChanged,
  });

  @override
  State<CategoryBudgetAllocation> createState() =>
      _CategoryBudgetAllocationState();
}

class _CategoryBudgetAllocationState extends State<CategoryBudgetAllocation> {
  late int _remainingBudget;
  final Map<ExpenseCategory, int> _categoryBudgets = {};

  @override
  void initState() {
    super.initState();
    _remainingBudget = widget.remainingBudget;
    for (var category in ExpenseCategory.values) {
      _categoryBudgets[category] = 0;
    }
  }

  @override
  void didUpdateWidget(covariant CategoryBudgetAllocation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remainingBudget != widget.remainingBudget) {
      setState(() {
        _remainingBudget = widget.remainingBudget;
      });
    }
  }

  void _onBudgetChanged(ExpenseCategory category, String value) {
    setState(() {
      int newAmount = int.tryParse(value.replaceAll(',', '')) ?? 0;
      int previousAmount = _categoryBudgets[category] ?? 0;
      _remainingBudget += previousAmount - newAmount;
      _categoryBudgets[category] = newAmount;
    });
    // ✅ 상위 위젯에 변경된 값 전달
    widget.onCategoryBudgetChanged(_categoryBudgets);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("카테고리별 예산 나누기", style: AppFonts.title2_sb),
                  Text("${_remainingBudget.toString()}원 남음",
                      style:
                          AppFonts.body2Sb.copyWith(color: AppColors.grey300)),
                ],
              ),
              const SizedBox(height: 20),
              ...ExpenseCategory.values.map((category) => CategoryBudgetItem(
                    category: category,
                    budget: _categoryBudgets[category]!,
                    onBudgetChanged: (value) =>
                        _onBudgetChanged(category, value),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryBudgetItem extends StatefulWidget {
  final ExpenseCategory category;
  final int budget;
  final Function(String) onBudgetChanged;

  const CategoryBudgetItem({
    super.key,
    required this.category,
    required this.budget,
    required this.onBudgetChanged,
  });

  @override
  State<CategoryBudgetItem> createState() => _CategoryBudgetItemState();
}

class _CategoryBudgetItemState extends State<CategoryBudgetItem> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.budget.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // ✅ Divider를 정렬
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(widget.category.emoji,
                        style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  Text(widget.category.label, style: AppFonts.body1Rg),
                ],
              ),
              SizedBox(
                width: 100, // ✅ 가로 길이 조정
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  style: AppFonts.body1Sb.copyWith(
                      color: _isEditing ? Colors.black : AppColors.grey200),
                  decoration: const InputDecoration(
                    isDense: true,
                    // ✅ 내부 패딩 최소화 (텍스트와 선 간격 줄이기)
                    contentPadding: EdgeInsets.only(bottom: 3),
                    // ✅ 선과 글자 간격 조절
                    border: InputBorder.none,
                    // 기존 테두리 제거
                    enabledBorder: UnderlineInputBorder(
                      // ✅ 얇은 선 추가
                      borderSide:
                          BorderSide(color: AppColors.grey200, width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.grey200, width: 1),
                    ),

                  ),
                  onTap: () {
                    setState(() {
                      _isEditing = true;
                      _controller.text =
                          _controller.text == "0" ? "" : _controller.text;
                    });
                  },
                  onChanged: widget.onBudgetChanged,
                  onEditingComplete: () {
                    setState(() {
                      _isEditing = false;
                      if (_controller.text.isEmpty) {
                        _controller.text = "0";
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
