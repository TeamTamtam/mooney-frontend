import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooney2/services/api_client.dart'; // API 클라이언트 import

// ✅ 캐릭터 이미지 매핑
final Map<String, String> characterImageMap = {
  '무니': 'assets/mooney.png',
  // 🔥 추가 캐릭터: '다른캐릭터이름': 'assets/other_character.png'
};

// ✅ 캐릭터 상태 모델
class Character {
  final String name;
  final String imgPath;

  Character({required this.name, required this.imgPath});
}

// ✅ 캐릭터 상태 관리 클래스
class CharacterNotifier extends StateNotifier<AsyncValue<Character?>> {
  CharacterNotifier() : super(const AsyncValue.loading()) {
    fetchCharacter(); // 생성 시 자동 실행
  }

  Future<void> fetchCharacter() async {
    try {
      final response = await apiClient.dio.get('/agents/active');
      final data = response.data;
      final name = data['agentName'] as String;

      // ✅ 매핑된 이미지 경로 가져오기 (기본값: 'assets/default.png')
      final imgPath = characterImageMap[name] ?? 'assets/default.png';

      final character = Character(name: name, imgPath: imgPath);
      state = AsyncValue.data(character);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// ✅ 전역 Provider
final characterProvider =
StateNotifierProvider<CharacterNotifier, AsyncValue<Character?>>(
        (ref) => CharacterNotifier());
