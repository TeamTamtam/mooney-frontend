import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:mooney2/services/auth_service.dart';
//
// class LoginScreen extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           '로그인',
//           style: AppFonts.title1_sb,
//           ),
//         ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(height: 30),
//             // 아이디 입력 필드
//             TextField(
//               keyboardType: TextInputType.text,
//               enableSuggestions: false,
//               autocorrect: false,
//               decoration: InputDecoration(
//                 hintText: '아이디',
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(18),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // 비밀번호 입력 필드
//             TextField(
//               obscureText: true,
//               keyboardType: TextInputType.visiblePassword,
//               decoration: InputDecoration(
//                 hintText: '비밀번호',
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(18),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 // 로그인 로직 추가
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryPurple,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18),
//                 ),
//               ),
//               child: Text(
//                 '로그인',
//                 style: AppFonts.title2_sb.copyWith(color: Colors.white),
//               ),
//             ),
//         // 회원가입 텍스트
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               '아직 계정이 없으신가요?',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.black,
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 // 회원가입 페이지로 이동
//                 Navigator.pushNamed(context, '/signupConsent');
//               },
//               child: const Text(
//                 '회원가입',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: AppColors.primaryPurple,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             ],)
//           ],
//         ),
//       ),
//     );
//   }
// }


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // ✅ 로딩 상태 추가

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // ✅ 로딩 시작
    });

    try {
      final success = await authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (success) {
        print("✅ 로그인 성공, 홈 화면으로 이동!");
        Navigator.pushReplacementNamed(context, '/home'); // ✅ 홈 화면으로 이동
      }
    } catch (e) {
      print("❌ 로그인 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 실패: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // ✅ 로딩 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '로그인',
          style: AppFonts.title1_sb,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            // 아이디 입력 필드
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.text,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: '이메일',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 비밀번호 입력 필드
            TextField(
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: '비밀번호',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _login, // ✅ 로딩 중이면 버튼 비활성화
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                disabledBackgroundColor: AppColors.primaryPurple,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                width: 20, // ✅ 크기 조절
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2, // ✅ 선 굵기 조절
                ),
              )
                  : Text(
                '로그인',
                style: AppFonts.title2_sb.copyWith(color: Colors.white),
              ),
            ),
            // 회원가입 텍스트
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '아직 계정이 없으신가요?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signupConsent'); // ✅ 회원가입 페이지 이동
                  },
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
