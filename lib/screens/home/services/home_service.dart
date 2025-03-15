import 'package:dio/dio.dart';
import 'package:mooney2/services/api_client.dart';
import 'dart:convert'; // JSON 변환을 위해 추가

class HomeService {
  Future<Map<String, dynamic>> fetchHomeData() async {
    try {
      final response = await apiClient.dio.get("/users/home");
      print('🏠 홈 요청 성공: ${jsonEncode(response.data)}');
      return response.data;
    } on DioException catch (e) {
      print("❌ 홈 데이터 가져오기 실패: ${e.response?.data}");
      throw Exception("홈 데이터 불러오기 실패");
    }
  }
}

final homeService = HomeService();