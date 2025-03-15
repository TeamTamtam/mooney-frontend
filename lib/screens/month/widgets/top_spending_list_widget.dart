import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:mooney2/constants/colors.dart';

// 🔥 가장 큰 지출 Top 3 목록 위젯
class TopSpendingList extends StatelessWidget {
  final List<Map<String, dynamic>> topSpendingData;

  const TopSpendingList({super.key, required this.topSpendingData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Text("가장 큰 지출 Top 3", style: AppFonts.body1Sb.copyWith(fontSize: 18)),

        const SizedBox(height: 16),


        Column(
          children: topSpendingData.map((data) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔢 순위 표시
                  SizedBox(
                    width: 24,
                    child: Text(
                      "${data["rank"]}",
                      textAlign: TextAlign.center,
                      style: AppFonts.body1Sb.copyWith(fontSize: 18, color: Colors.black87),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 🔥 지출 항목 컨테이너
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 🖼️ 아이콘 (이모지)
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                data["emoji"],
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // 📌 텍스트 정보 (제목 + 날짜)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 제목 (한 줄 유지)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Text(
                                      data["title"],
                                      style: AppFonts.body1Sb.copyWith(fontSize: 16),
                                      overflow: TextOverflow.ellipsis, // 길어지면 ... 처리
                                    ),

                                    // 💰 금액 (같은 줄 유지)
                                    Text(
                                      "${NumberFormat('#,###').format(data["amount"])}원  ",
                                      style: AppFonts.body1Sb.copyWith(fontSize: 16, color: AppColors.grey400),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 3),

                                // 날짜
                                Text(
                                  data["date"],
                                  style: AppFonts.body1Rg.copyWith(fontSize: 14, color: AppColors.grey400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}