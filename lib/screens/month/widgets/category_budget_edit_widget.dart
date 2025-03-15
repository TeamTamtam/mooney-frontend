// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
//
// class CategoryBudgetWidget extends StatefulWidget {
//   final int totalBudget;
//   final int totalFixedExpense;
//   final List<Map<String, dynamic>> categories;
//
//   const CategoryBudgetWidget({
//     Key? key,
//     required this.totalBudget,
//     required this.totalFixedExpense,
//     required this.categories,
//   }) : super(key: key);
//
//   @override
//   _CategoryBudgetWidgetState createState() => _CategoryBudgetWidgetState();
// }
//
// class _CategoryBudgetWidgetState extends State<CategoryBudgetWidget> {
//   late Map<String, TextEditingController> controllers;
//
//   @override
//   void initState() {
//     super.initState();
//     // 초기 카테고리별 예산을 컨트롤러에 설정
//     controllers = {
//       for (var c in widget.categories)
//         c['category']: TextEditingController(
//           text: NumberFormat('#,###').format(c['budget']),
//         )
//     };
//   }
//
//   @override
//   void dispose() {
//     // 모든 컨트롤러 해제
//     controllers.forEach((key, controller) => controller.dispose());
//     super.dispose();
//   }
//
//   void _updateCategoryBudget(String category, String value) {
//     setState(() {
//       int newValue = int.tryParse(value.replaceAll(',', '')) ?? 0;
//       controllers[category]!.text = NumberFormat('#,###').format(newValue);
//     });
//   }
//
//   int get remainingBudget {
//     int allocatedBudget = controllers.values.fold(0, (sum, controller) {
//       return sum + (int.tryParse(controller.text.replaceAll(',', '')) ?? 0);
//     });
//     return widget.totalBudget - widget.totalFixedExpense - allocatedBudget;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 제목 + 남은 예산
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '카테고리별 예산 나누기',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF202020),
//                   ),
//                 ),
//                 Text(
//                   '${NumberFormat('#,###').format(remainingBudget)}원 남음',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF6B7076),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           Column(
//             children: widget.categories.map((category) {
//               return _buildCategoryRow(category);
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryRow(Map<String, dynamic> category) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // 카테고리 아이콘 및 텍스트
//           Row(
//             children: [
//               Container(
//                 width: 32,
//                 height: 32,
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF3F4F6),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(category['emoji'] ?? '🔘', style: TextStyle(fontSize: 18)),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     category['category'],
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF202020),
//                     ),
//                   ),
//                   Text(
//                     '지난달 ${NumberFormat('#,###').format(category['lastMonth'] ?? 0)}원',
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF6B7076),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           SizedBox(
//             width: 100,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 // 숫자 입력 필드
//                 Expanded(
//                   child: TextField(
//                     controller: controllers[category['category']],
//                     textAlign: TextAlign.right,
//                     enableSuggestions: false,
//                     keyboardType: TextInputType.text,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
//                       TextInputFormatter.withFunction((oldValue, newValue) {
//                         String formattedValue =
//                         NumberFormat('#,###').format(int.tryParse(newValue.text) ?? 0);
//                         return TextEditingValue(
//                           text: formattedValue,
//                           selection: TextSelection.collapsed(offset: formattedValue.length),
//                         );
//                       }),
//                     ],
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF3A3E43),
//                     ),
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                     ),
//                     onChanged: (value) {
//                       _updateCategoryBudget(category['category'], value);
//                     },
//                   ),
//                 ),
//                 // "원" 텍스트
//                 Text(
//                   '원',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF3A3E43),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class CategoryBudgetWidget extends StatefulWidget {
  final int totalBudget;
  final int totalFixedExpense;
  final List<Map<String, dynamic>> categories;
  final Map<String, TextEditingController> categoryControllers;

  const CategoryBudgetWidget({
    Key? key,
    required this.totalBudget,
    required this.totalFixedExpense,
    required this.categories,
    required this.categoryControllers,
  }) : super(key: key);

  @override
  _CategoryBudgetWidgetState createState() => _CategoryBudgetWidgetState();
}

class _CategoryBudgetWidgetState extends State<CategoryBudgetWidget> {
  int get remainingBudget {
    int allocatedBudget = widget.categoryControllers.values.fold(0, (sum, controller) {
      return sum + (int.tryParse(controller.text.replaceAll(',', '')) ?? 0);
    });
    return widget.totalBudget - widget.totalFixedExpense - allocatedBudget;
  }

  void _updateCategoryBudget(String category, String value) {
    setState(() {
      int newValue = int.tryParse(value.replaceAll(',', '')) ?? 0;
      widget.categoryControllers[category]!.text = NumberFormat('#,###').format(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 + 남은 예산
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '카테고리별 예산 나누기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202020),
                  ),
                ),
                Text(
                  '${NumberFormat('#,###').format(remainingBudget)}원 남음',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7076),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Column(
            children: widget.categories.map((category) {
              return _buildCategoryRow(category);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(Map<String, dynamic> category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 카테고리 아이콘 및 텍스트
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(category['emoji'] ?? '🔘', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['category'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF202020),
                    ),
                  ),
                  Text(
                    '지난달 ${NumberFormat('#,###').format(category['lastMonth'] ?? 0)}원',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7076),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 숫자 입력 필드
                Expanded(
                  child: TextField(
                    controller: widget.categoryControllers[category['category']],
                    textAlign: TextAlign.right,
                    enableSuggestions: false,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        String formattedValue =
                        NumberFormat('#,###').format(int.tryParse(newValue.text) ?? 0);
                        return TextEditingValue(
                          text: formattedValue,
                          selection: TextSelection.collapsed(offset: formattedValue.length),
                        );
                      }),
                    ],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3A3E43),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _updateCategoryBudget(category['category'], value);
                    },
                  ),
                ),
                Text(
                  '원',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A3E43),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
