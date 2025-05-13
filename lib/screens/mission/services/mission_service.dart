import '../models/mission_data.dart';
import 'package:mooney2/services/api_client.dart';


class MissionService {
  Future<List<MissionData>> fetchMissions() async {
    try {
      final response = await apiClient.dio.get('/missions');

      if (response.statusCode == 200) {
        final data = response.data;
        print("✅ API 응답: $data");
        final missions = (data['missions'] as List)
            .asMap()
            .entries
            .map((entry) => MissionData.fromJson(entry.value, entry.key + 1))
            .toList();
        return missions;
      } else {
        throw Exception('미션 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      print("❌ API 호출 중 오류 발생: $e");
      throw Exception('네트워크 오류');
    }
  }
  Future<Map<String, dynamic>> fetchMissionsWithStatus() async {
    try {
      final response = await apiClient.dio.get('/missions');

      if (response.statusCode == 200) {
        print("✅ 전체 응답: ${response.data}");
        return response.data; // mooneystatus 포함한 전체 반환
      } else {
        throw Exception('미션 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      print("❌ API 호출 중 오류 발생: $e");
      throw Exception('네트워크 오류');
    }
  }

}

// ✅ 전역 객체로 사용
final missionService = MissionService();