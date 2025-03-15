// import 'package:flutter/material.dart';
//
// class ProfileEditScreen extends StatelessWidget {
//   const ProfileEditScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('이름', style: TextStyle(fontSize: 16)),
//           const SizedBox(height: 4),
//           const Text('이화면', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           const Text('아이디', style: TextStyle(fontSize: 16)),
//           const SizedBox(height: 4),
//           const Text('mooney01', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           const Text('계정 삭제', style: TextStyle(color: Colors.red, fontSize: 16)),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    // ✅ 초기 값 설정 (API에서 가져올 데이터 가정)
    _nameController = TextEditingController(text: '이화연');
    _idController = TextEditingController(text: 'mooney01');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // 🟢 이름 입력 필드
          _buildEditableField('이름', _nameController),

          const Divider(thickness: 1, height: 30), // 구분선

          // 🟣 아이디 입력 필드
          _buildEditableField('아이디', _idController),

          const Divider(thickness: 1, height: 30), // 구분선

          // 🔴 계정 삭제 (연한 회색)
          const Text(
            '계정 삭제',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// 🔹 편집 가능한 입력 필드 생성 함수
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
        SizedBox(
          width: 200, // 너비 지정
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: InputBorder.none, // ✅ 입력 필드 테두리 제거
              isDense: true, // 높이 줄이기
            ),
          ),
        ),
      ],
    );
  }
}

