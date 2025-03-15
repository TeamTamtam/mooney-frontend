import 'package:flutter/material.dart';
import 'package:mooney2/widgets/home_styled_box.dart';

class DailyExpenditureWidget extends StatelessWidget {
  // 금액을 나중에 API로 받아올 수 있게 String 타입으로 미리 설정
  final String amount;

  const DailyExpenditureWidget({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return StyledBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          // "오늘의 지출" 텍스트
          Text(
            '오늘의 지출',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8), // 두 텍스트 간 간격
          // 금액을 보여주는 텍스트
          Text(
            amount+"원",  // 금액을 API에서 받아오면 해당 값으로 업데이트
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
