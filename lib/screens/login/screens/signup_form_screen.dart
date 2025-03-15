import 'dart:async'; // Timer 사용
import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/constants/app_fonts.dart';
import '../services/email_service.dart';
import '../utils/form_validator.dart';
import 'package:mooney2/services/auth_service.dart';

class SignupFormScreen extends StatefulWidget {
  const SignupFormScreen({super.key});

  @override
  _SignupFormScreenState createState() => _SignupFormScreenState();
}

class _SignupFormScreenState extends State<SignupFormScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final EmailService _EmailService = EmailService();
  final AuthService _authService = AuthService();

  String? _emailValidationMessage;
  String? _passwordValidationMessage;
  String? _passwordConfirmValidationMessage;
  String? _nameValidationMessage;
  bool _isCheckingEmail = false;
  Timer? _debounce;
  bool _isLoading = false;

  bool get isFormValid {
    return _emailValidationMessage == '사용할 수 있는 이메일입니다.' &&
        _passwordConfirmValidationMessage == '비밀번호 확인이 일치합니다.' &&
        _passwordValidationMessage == null &&
        _nameValidationMessage == null;
  }

  void _onEmailChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      if (_idController.text.contains('@')) {
        _checkEmailAvailability();
      }
    });
  }

  Future<void> _checkEmailAvailability() async {
    if (_idController.text.isEmpty) return;

    setState(() {
      _isCheckingEmail = true;
      _emailValidationMessage = null;
    });

    try {
      final isAvailable = await _EmailService.checkEmailAvailability(_idController.text);
      setState(() {
        _emailValidationMessage = isAvailable
            ? '사용할 수 있는 이메일입니다.'
            : '사용할 수 없는 이메일입니다.';
      });
    } catch (e) {
      setState(() {
        _emailValidationMessage = '이메일 확인 중 오류가 발생했습니다.';
      });
    } finally {
      setState(() {
        _isCheckingEmail = false;
      });
    }
  }

  void _validateField(String field) {
    setState(() {
      if (field == 'password') {
        _passwordValidationMessage = FormValidator.validatePassword(_passwordController.text);
      } else if (field == 'passwordConfirm') {
        _passwordConfirmValidationMessage = FormValidator.validatePasswordConfirm(
          _passwordController.text,
          _passwordConfirmController.text,
        );
      } else if (field == 'name') {
        _nameValidationMessage = FormValidator.validateName(_nameController.text);
      }
    });
  }

  Future<void> _validateAndSubmit() async {
    _validateField('password');
    _validateField('passwordConfirm');
    _validateField('name');

    if (!isFormValid) return; // 🚫 검증 실패하면 API 호출 안 함

    setState(() {
      _isLoading = true; // ✅ 로딩 상태 ON
    });

    try {
      final response = await _authService.signup(
        email: _idController.text,
        password: _passwordController.text,
        confirmPassword: _passwordConfirmController.text,
        nickname: _nameController.text,
      );

      if (response != null) {
        print("✅ 회원가입 성공, 토큰 저장 완료!");
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print("❌ 회원가입 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("회원가입 실패: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // ✅ 로딩 상태 OFF
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _idController.addListener(_onEmailChanged);
    _passwordController.addListener(() => _validateField('password'));
    _passwordConfirmController.addListener(() => _validateField('passwordConfirm'));
    _nameController.addListener(() => _validateField('name'));
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

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
        title: const Text(
          '회원가입',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // 이메일 입력 필드
                  Text('이메일', style: AppFonts.body1Sb),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _idController,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  if (_emailValidationMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _emailValidationMessage!,
                        style: AppFonts.body2Rg.copyWith(
                          color: _emailValidationMessage == '사용할 수 있는 이메일입니다.'
                              ? AppColors.positiveGreen
                              : AppColors.negativeRed,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // 비밀번호 입력 필드
                  Text('비밀번호', style: AppFonts.body1Sb),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    enableSuggestions: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '8-20자 사이로 입력',
                      filled: true,
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  if (_passwordValidationMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _passwordValidationMessage!,
                        style: AppFonts.body2Rg.copyWith(color: AppColors.negativeRed),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // 비밀번호 확인 입력 필드
                  Text('비밀번호 확인', style: AppFonts.body1Sb),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordConfirmController,
                    enableSuggestions: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  if (_passwordConfirmValidationMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _passwordConfirmValidationMessage!,
                        style: AppFonts.body2Rg.copyWith(
                          color: _passwordConfirmValidationMessage == '비밀번호 확인이 일치합니다.'
                              ? AppColors.positiveGreen
                              : AppColors.negativeRed,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // 이름 입력 필드
                  Text('이름', style: AppFonts.body1Sb),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    enableSuggestions: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: '1~10자 사이로 입력',
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  if (_nameValidationMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _nameValidationMessage!,
                        style: AppFonts.body2Rg.copyWith(color: AppColors.negativeRed),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid
                      ? AppColors.primaryPurple // 활성화 상태
                      : Colors.grey[300], // 비활성화 상태
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  '가입하기',
                  style: AppFonts.title2_sb.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
