import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './api_client.dart'; // ✅ api_client.dart 임포트

class AuthService {
  final Dio _dio = apiClient.dio; // ✅ 전역 인스턴스를 사용하도록 변경
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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
    return await _secureStorage.read(key: "accessToken");
  }


  // 로그인 상태 확인 (토큰 존재 여부)
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: "refreshToken");
  }
}

final authService = AuthService();
