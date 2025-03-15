import 'package:flutter/material.dart';
import 'package:mooney2/widgets/home_styled_box.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/screens/home/models/remained_budget.dart';

class RemainedBudgetWidget extends StatelessWidget {
  final RemainedBudget remainedBudget; // RemainedBudget 모델을 받도록 수정

  const RemainedBudgetWidget({super.key, required this.remainedBudget});


  @override
  Widget build(BuildContext context) {
    double percentValue = double.parse(remainedBudget.percent); // percent를 double로 변환
    return StyledBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          // 타이틀과 버튼을 포함한 Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '이번 주 남은 예산',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios_rounded),
                color: AppColors.grey400,
                onPressed: () {
                  // 버튼 클릭 시 행동 추가
                },
              ),
            ],
          ),

          // 남은 예산 표시
          Text(
            '${remainedBudget.remainedAmount}원',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16), // 남은 예산과 세부 정보 간격
          // 진행 상태 막대바
          Container(
            width: double.infinity, // 전체 너비를 차지하도록
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), // 둥근 모서리
              color: Colors.grey[200], // 배경색 회색
            ),
            child: Stack(
              children: [
                // 색칠된 부분
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentValue / 100, // percent 값에 따라 너비를 조정
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4), // 둥근 모서리
                      color: AppColors.primaryPurple, // 색상
                    ),
                    child: Align(
                      alignment: Alignment.centerRight, // 텍스트 오른쪽 정렬
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0), // 오른쪽 여백
                        child: Text(
                          '${remainedBudget.percent}%', // 퍼센트 텍스트
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 세부 예산 정보
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBudgetRow('이번주 예산', remainedBudget.weekBudget),
              _buildBudgetRow('오늘까지 지출', remainedBudget.expenditure),
              _buildBudgetRow('예정된 지출', remainedBudget.willExpend),
              Divider(
                color: AppColors.grey400, // 구분선 색
                thickness: 0.5,            // 구분선 두께
                indent: 0,                 // 왼쪽 여백
                endIndent: 0,              // 오른쪽 여백
              ),
              _buildBudgetRow('이번주 남은 예산', remainedBudget.remainedAmount),
              _buildBudgetRow('1일 예산', remainedBudget.dayBudget),

            ],
          ),
        ],
      ),
    );
  }

  // 예산 정보를 세로로 나열하는 메소드
  Widget _buildBudgetRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '$amount원',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}