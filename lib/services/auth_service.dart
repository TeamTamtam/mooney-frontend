import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './api_client.dart'; // ✅ api_client.dart 임포트
import '../main.dart';
import 'package:mooney2/config/routes.dart';

class AuthService {
  final Dio _dio = apiClient.dio; // ✅ 전역 인스턴스를 사용하도록 변경
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: false, // 🔥 테스트를 위해 암호화 OFF
    ),
  );

  Future<Map<String, String>?> signup({
    required String email,
    required String password,
    required String confirmPassword,
    required String nickname,
  }) async {
    final body = {
      "termsAgreed": true,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
      "nickname": nickname,
    };

    try {
      final response = await _dio.post('/auth/signup', data: body);

      if (response.statusCode == 200) {
        final accessToken = response.data["accessToken"];
        final refreshToken = response.data["refreshToken"];

        await _saveTokens(accessToken, refreshToken);

        return {
          "accessToken": accessToken,
          "refreshToken": refreshToken,
        };
      }
    } on DioException catch (e) {
      print("❌ 회원가입 실패: ${e.response?.data}");
      throw Exception("회원가입 실패: ${e.response?.data}");
    }
    return null;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final body = {
      "email": email,
      "password": password,
    };

    try {
      final response = await _dio.post('/auth/login', data: body);

      if (response.statusCode == 200) {
        final accessToken = response.data["accessToken"];
        final refreshToken = response.data["refreshToken"];
        print("액세스토큰: ${response.data["accessToken"]}");

        // ✅ 토큰 저장
        await _saveTokens(accessToken, refreshToken);

        return true; // ✅ 로그인 성공
      }
    } on DioException catch (e) {
      print("❌ 로그인 실패: ${e.response?.data}");
      throw Exception("로그인 실패: ${e.response?.data["message"]}");
    }
    return false;
  }


  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: "accessToken", value: accessToken);
    await _secureStorage.write(key: "refreshToken", value: refreshToken);
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: "accessToken");
    await _secureStorage.delete(key: "refreshToken");
  }

  Future<String?> getAccessToken() async {
    print("📦 getAccessToken 시작");
    try {
      final token = await _secureStorage.read(key: "accessToken");
      print("📦 getAccessToken 읽은 값: $token");
      return token;
    } catch (e) {
      print("❌ getAccessToken 실패: $e");
      return null;
    }
  }



  // 로그인 상태 확인 (토큰 존재 여부/유효성검사)
  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();

    if (accessToken == null) return false;

    // ✅ 액세스 토큰이 만료됐고 리프레시도 실패했는지 검사
    try {
      final response = await apiClient.dio.get('/users/nickname'); // 예시: 토큰 확인용 API
      return response.statusCode == 200;
    } catch (e) {
      print("❌ 토큰 유효성 검사 실패: $e");
      await logout(); // 🔥 스토리지 비우고 로그아웃 처리

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
            (route) => false,
      );

      return false;
    }
  }

  Future<bool> hasValidAccessToken() async {
    print("📦 hasValidAccessToken 호출됨");
    final accessToken = await getAccessToken();
    print("📦 getAccessToken 결과: $accessToken");
    return accessToken != null;
  }



  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: "refreshToken");
  }
}

final authService = AuthService();
