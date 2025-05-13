import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../main.dart';
import 'package:mooney2/config/routes.dart';

class ApiClient {
  final Dio dio = Dio(
      BaseOptions(baseUrl: dotenv.env['BASE_URL'] ?? '',)); // ✅ 기본 API URL
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(); // ✅ 보안 저장소

  ApiClient() {
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final accessToken = await _secureStorage.read(key: 'accessToken');
            if (accessToken != null) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            }
          } catch (e) {
            print("❗ accessToken 복호화 중 오류 발생: $e");
            await _secureStorage.deleteAll();

            // 🔥 로그인 화면으로 이동
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AppRoutes.login,
                  (route) => false,
            );

            return; // ❗ handler 호출 없이 return해야 이후 처리 안 됨
          }

          return handler.next(options);
        },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 403) { // 🔥 AccessToken 만료
          print("🔄 AccessToken 만료됨. RefreshToken으로 갱신 시도...");
          final newAccessToken = await _refreshAccessToken();

          if (newAccessToken != null) {
            e.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';
            final retryResponse = await dio.fetch(
                e.requestOptions); // 🔄 실패한 요청 재시도
            return handler.resolve(retryResponse);
          }
        }
        return handler.next(e);
      },
    ));
  }

  /// ✅ `refreshToken`을 사용하여 `accessToken` 갱신 (쿼리 파라미터)
  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _secureStorage.read(key: 'refreshToken');
    if (refreshToken == null) {
      print("❌ RefreshToken 없음. 로그아웃 필요");
      return null;
    }

    try {
      final response = await dio.post('/auth/refresh', queryParameters: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200) {
        final newAccessToken = response.data["accessToken"];
        final newRefreshToken = response.data["refreshToken"];

        await _secureStorage.write(key: "accessToken", value: newAccessToken);
        await _secureStorage.write(key: "refreshToken", value: newRefreshToken);

        print("✅ 새로운 AccessToken 저장 완료");
        return newAccessToken;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final errorData = e.response?.data;
        if (errorData != null && errorData["errorCode"] == "INVALID_TOKEN") {
          print("❌ RefreshToken도 만료됨. 로그아웃 처리 필요");
          await _secureStorage.deleteAll();
        }
      }
      print("❌ 토큰 갱신 실패: ${e.response?.data}");
    }
    return null;
  }
  
}
//전역 인스턴스
final apiClient = ApiClient();