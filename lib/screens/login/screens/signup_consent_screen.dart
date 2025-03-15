import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/constants/app_fonts.dart';

class SignupConsentScreen extends StatefulWidget {
  const SignupConsentScreen({super.key});

  @override
  _SignupConsentScreenState createState() => _SignupConsentScreenState();
}

class _SignupConsentScreenState extends State<SignupConsentScreen> {
  bool isTermsChecked = false; // 이용약관 동의 상태
  bool isPrivacyChecked = false; // 개인정보 처리 방침 동의 상태

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '회원가입',
          style: AppFonts.title1_sb
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '환영해요!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '서비스 이용을 위해 약관 동의가 필요해요',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 약관 동의 옵션
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Text(
                      '(필수)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    title: const Text(
                      '이용약관 동의',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    trailing: Checkbox(
                      value: isTermsChecked,
                      activeColor: AppColors.primaryPurple,
                      onChanged: (bool? value) {
                        setState(() {
                          isTermsChecked = value ?? false;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Text(
                      '(필수)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    title: const Text(
                      '개인정보 수집 및 이용 동의',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    trailing: Checkbox(
                      value: isPrivacyChecked,
                      activeColor: AppColors.primaryPurple,
                      onChanged: (bool? value) {
                        setState(() {
                          isPrivacyChecked = value ?? false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 전체 동의 버튼
            SizedBox(
              width: double.infinity, // 버튼 가로 길이를 화면 전체로 설정
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signupForm'); // 항상 다음 화면으로 이동 가능
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  '전체 동의하고 계속하기',
                  style: AppFonts.title2_sb.copyWith(color : Colors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
