import 'package:flutter/material.dart';
import './screens/profile_main_screen.dart';
import './screens/character_edit_screen.dart';
import './screens/profile_edit_screen.dart';
import 'package:mooney2/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentProfileIndex = 0; // 프로필 내 화면 상태 관리 (0: 기본, 1: 캐릭터 변경, 2: 개인 정보 수정)
  String _nickname = '이화연'; // 닉네임 기본값 (API 호출 전)

  void _navigateTo(int index) {
    setState(() {
      _currentProfileIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: _currentProfileIndex != 2 ? AppColors.grey50 : null,
        automaticallyImplyLeading: _currentProfileIndex != 0, // ✅ index가 0이면 이전 버튼 숨김
        leading: _currentProfileIndex != 0 // 뒤로가기 버튼 표시
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _navigateTo(0),
        )
            : null,
        actions: _currentProfileIndex == 1 || _currentProfileIndex == 2 // ✅ index가 1 또는 2일 때만 "확인" 버튼 표시
            ? [
          TextButton(
            onPressed: () => _navigateTo(0), // "확인" 버튼 클릭 시 프로필 메인 화면으로 이동
            child: const Text(
              '확인',
              style: TextStyle(fontSize: 16, color: Colors.black), // ✅ 스타일 적용
            ),
          ),
        ]
            : null, // index가 0이면 actions 비활성화
      ),
      body: IndexedStack(
        index: _currentProfileIndex,
        children: [
          ProfileMainScreen(onNavigate: _navigateTo,nickname: _nickname,),  // 메인 화면
          CharacterEditScreen(),  // 캐릭터 변경 화면
          ProfileEditScreen(),    // 개인 정보 수정 화면
        ],
      ),
    );
  }
}
