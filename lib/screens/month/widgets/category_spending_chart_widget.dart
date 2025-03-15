import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mooney2/constants/app_fonts.dart';

// 🔥 카테고리별 지출 차트 위젯
class CategorySpendingChart extends StatelessWidget {
  final List<Map<String, dynamic>> categoryData;

  const CategorySpendingChart({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    // 🔥 퍼센트 기준 내림차순 정렬
    List<Map<String, dynamic>> sortedData = List.from(categoryData);
    sortedData.sort((a, b) => b["percent"].compareTo(a["percent"]));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 카테고리별 지출 제목
        Text("카테고리별 지출", style: AppFonts.body1Sb.copyWith(fontSize: 18)),

        const SizedBox(height: 16),

        // 🔥 왼쪽(범례) - 오른쪽(파이 차트) 배치
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔵 카테고리 범례 (왼쪽)
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sortedData.map((data) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: data["color"],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          data["category"],
                          style: AppFonts.body1Rg.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            // 🟡 파이 차트 (오른쪽)
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0, // 🔥 조각 간격 없음
                    centerSpaceRadius: 0, // 🔥 도넛 모양 제거 (색이 다 차게)
                    sections: sortedData.map((data) {
                      return PieChartSectionData(
                        color: data["color"],
                        value: data["percent"],
                        title: "${data["percent"]}%",
                        radius: 100,
                        titlePositionPercentageOffset: 0.6,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}