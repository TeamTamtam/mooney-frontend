import 'package:flutter/material.dart';
import 'package:mooney2/constants/app_fonts.dart';

class MissionListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> missions;

  const MissionListWidget({super.key, required this.missions});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 18),
            child: Text('이번주 챌린지', style: AppFonts.title2_sb),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              return MissionBox(
                title: missions[index]['title'] ?? '',
                emoji: _getEmoji(missions[index]['status']),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getEmoji(String? status) {
    switch (status) {
      case '1':
        return '😢';
      case '2':
        return '😊';
      case '3':
        return '😁';
      default:
        return '😶';
    }
  }
}


// 개별 미션 박스 위젯
class MissionBox extends StatelessWidget {
  final String title;
  final String emoji;

  const MissionBox({
    required this.title,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFEEF7FF), // 배경색
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 왼쪽에 미션 텍스트
          Expanded(
            child: Text(
              title,
              style: AppFonts.body1Sb
          ),),
          // 오른쪽에 이모지
          Text(
            emoji,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
