import 'package:mooney2/services/api_client.dart';

class NewMissionService {
  Future<List<String>> fetchMissionTitles() async {
    try {
      final response = await apiClient.dio.get('/missions');

      if (response.statusCode == 200) {
        final List missions = response.data['missions'];
        final titles = missions
            .map<String>((mission) => mission['title'].toString())
            .take(3)
            .toList();

        return titles;
      } else {
        throw Exception('미션을 불러오지 못했습니다: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 미션 가져오기 실패: $e');
      return []; // 에러 시 빈 리스트 반환
    }
  }
}
