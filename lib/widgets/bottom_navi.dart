import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mooney2/constants/colors.dart';

class BottomNavi extends StatelessWidget {
  final int currentIndex;              // 현재 선택된 인덱스
  final Function(int) onTap;           // 탭 이벤트 콜백

  const BottomNavi({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,       // 현재 선택된 인덱스 표시
      onTap: onTap,                     // 아이템 클릭 시 호출될 콜백
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedFontSize: 0,
      items: [
        _buildNavItem('assets/navigation/home.svg', 0),
        _buildNavItem('assets/navigation/month.svg', 1),
        _buildNavItem('assets/navigation/menu - challenge.svg', 2),
        _buildNavItem('assets/navigation/chat.svg', 3),
        _buildNavItem('assets/navigation/profile.svg', 4),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(String assetPath, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetPath,
        color: currentIndex == index ? AppColors.primaryPurple : AppColors.bluegray,  // 선택된 아이콘은 파란색, 나머지는 회색
      ),
      label: '',
    );
  }
}
