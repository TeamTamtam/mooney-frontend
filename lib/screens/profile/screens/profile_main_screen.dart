import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooney2/providers/character_provider.dart';

class ProfileMainScreen extends ConsumerWidget { // ✅ ConsumerWidget으로 변경
  final Function(int) onNavigate; // 네비게이션 함수
  final String nickname; // API에서 받아온 닉네임

  const ProfileMainScreen({
    super.key,
    required this.onNavigate,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterState = ref.watch(characterProvider); // ✅ 캐릭터 상태 구독

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 🟢 닉네임 + 캐릭터 + 버튼 영역 (연한 회색 배경)
        Container(
          color: AppColors.grey50, // 연한 회색 배경
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              Text(
                nickname, // ✅ API에서 받은 닉네임 표시
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // ✅ 캐릭터 이미지 (Provider에서 받아온 데이터 사용)
              GestureDetector(
                onTap: () => onNavigate(1), // 캐릭터 변경 화면으로 이동
                child: characterState.when(
                  data: (character) => character != null
                      ? CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(character.imgPath), // ✅ 캐릭터 이미지 적용
                    backgroundColor: AppColors.grey50,
                  )
                      : const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey, // 데이터 없을 때 기본 배경
                    child: Icon(Icons.error, color: Colors.white), // 에러 아이콘 표시
                  ),
                  loading: () => const CircularProgressIndicator(), // 로딩 중
                  error: (err, stack) => const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.error, color: Colors.white), // 에러 발생 시 기본 아이콘
                  ),
                ),
              ),

              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => onNavigate(1),
                child: const Text(
                  '캐릭터 변경',
                  style: TextStyle(
                    color: AppColors.grey400,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),

        // 🟣 설정 리스트 (구분선 추가)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              _buildListTile('개인 정보 수정', () => onNavigate(2)),
              _buildDivider(),
              _buildListTile('활동 설정', () {}),
              _buildDivider(),
              _buildListTile('히스토리', () {}),
              _buildDivider(),

              // 🔴 로그아웃 (연한 회색)
              ListTile(
                title: const Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  // 로그아웃 기능 추가 예정
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔹 일반 ListTile 빌드 함수
  Widget _buildListTile(String title, Function()? onTap, [int? index]) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: index != null ? () => onNavigate(index) : onTap,
    );
  }

  /// 🔹 구분선 (연한 회색)
  Widget _buildDivider() {
    return const Divider(color: AppColors.grey50, thickness: 0.5, height: 0);
  }
}
