import 'package:dio/dio.dart';

class EmailService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.mooney.n-e.kr'));

  Future<bool> checkEmailAvailability(String email) async {
    try {
      final response = await _dio.get(
        '/auth/check-email',
        queryParameters: {'email': email},
      );

      if (response.statusCode == 200) {
        return true; // 사용 가능한 이메일
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return false; // 이미 존재하는 이메일
      }
    }
    throw Exception('이메일 확인 중 오류 발생');
  }
}
