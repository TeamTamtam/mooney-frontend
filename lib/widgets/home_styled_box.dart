import 'package:flutter/material.dart';

class StyledBox extends StatelessWidget {
  final Widget child;

  const StyledBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18), // 안쪽 여백
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, // 배경색
        borderRadius: BorderRadius.circular(20), // 둥근 모서리
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // 그림자 위치
          ),
        ],
      ),
      child: child,
    );
  }
}
