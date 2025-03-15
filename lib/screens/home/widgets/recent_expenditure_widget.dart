import 'package:flutter/material.dart';
import 'package:mooney2/widgets/home_styled_box.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/screens/home/models/expenditure.dart';

class RecentExpenditureWidget extends StatelessWidget {
  final List<Expenditure> expenditures; // ✅ 지출 데이터 리스트

  const RecentExpenditureWidget({
    super.key,
    this.expenditures = const [], // 기본값은 빈 리스트로 설정
  });

  @override
  Widget build(BuildContext context) {
    return StyledBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀과 버튼을 포함한 Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최근 지출 내역',
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


                },
              ),
            ],
          ),
          const SizedBox(height: 12), // 타이틀과 지출 내역 간격

          // ✅ 지출 데이터 렌더링
          if (expenditures.isEmpty)
            Center(
              child: Text(
                '지출 내역이 없습니다.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true, // Column 내부에서 사용하기 위해 필요
              physics: NeverScrollableScrollPhysics(), // 부모 스크롤에 영향받도록 설정
              itemCount: expenditures.length,
              itemBuilder: (context, index) {
                final exp = expenditures[index];
                return ExpenditureBox(
                  // title: exp.title,
                  // amount: exp.amount,
                  // dateTime: exp.dateTime,
                  // category: exp.category,
                  expenditure: exp, // Expenditure 객체 넘기기
                );
              },
            ),
        ],
      ),
    );
  }
}



// 개별 지출박스 위젯
class ExpenditureBox extends StatelessWidget {
  //모델에서 만든걸로 사용
  // final String title;
  // final String amount;
  // final DateTime dateTime;
  // final String category;
  //
  // const ExpenditureBox({
  //   required this.title,
  //   required this.amount,
  //   required this.dateTime,
  //   required this.category,
  // });
  final Expenditure expenditure; // Expenditure 객체를 직접 받음

  const ExpenditureBox({
    required this.expenditure, // Expenditure 객체를 받음
  });
  // ✅ 01.29 14:23 형식으로 포맷팅
  String formatDateTime(DateTime dateTime) {
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$month.$day $hour:$minute';
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(12), //색 없으니 필요 없음 - 추후제거
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 왼쪽: 타이틀 + (결제 시각 | 카테고리)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expenditure.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      formatDateTime(expenditure.dateTime), // ✅ 결제 시각
                      style: TextStyle(
                        color: AppColors.grey400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '|',
                      style: TextStyle(color: AppColors.grey400, fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      expenditure.transactionSource, // ✅ 결제소스
                      style: TextStyle(
                        color:  AppColors.grey400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ✅ 오른쪽: 금액 표시
          Text(
            '-${expenditure.amount}원',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}