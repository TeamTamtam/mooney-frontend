import 'package:dio/dio.dart';
import './api_client.dart'; // ✅ API 클라이언트 import

class UserService {
  final Dio _dio = apiClient.dio; // ✅ API 클라이언트 사용

  /// ✅ 닉네임 가져오기
  Future<String> getNickname() async {
    try {
      final response = await _dio.get('/users/nickname');

      if (response.statusCode == 200) {
        return response.data ?? "00"; // ✅ 닉네임 반환 (없으면 기본값)
      }
    } on DioException catch (e) {
      print("❌ 닉네임 불러오기 실패: ${e.response?.data}");
    }
    return ""; // ✅ 오류 시 기본 닉네임 반환
  }
}

final userService = UserService(); // ✅ 전역 인스턴스
