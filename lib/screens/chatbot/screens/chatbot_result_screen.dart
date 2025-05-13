import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import 'package:mooney2/services/api_client.dart';
import 'package:mooney2/constants/app_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooney2/providers/character_provider.dart';


class ChatbotResultScreen extends ConsumerStatefulWidget {
  final String userInput;

  ChatbotResultScreen({required this.userInput});

  @override
  _ChatbotResultScreenState createState() => _ChatbotResultScreenState();
}

class _ChatbotResultScreenState extends ConsumerState<ChatbotResultScreen> {
  List<String> backendResponse = [];// 백엔드 응답 데이터
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    _fetchBackendResponse(); // 백엔드 응답 요청
  }

  Future<void> _fetchBackendResponse() async {
    try {
      final response = await apiClient.dio.post(
        '/chat',
        data: {"message": widget.userInput},
      );

      setState(() {
        backendResponse = (response.data['response'] as String).split('\n\n'); // 빈 줄 기준으로 문단 나누기
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        backendResponse = ['응답을 가져오는 데 실패했습니다. 다시 시도해주세요.'];
        isLoading = false;
      });
    }
  }
//연어덮밥은 만원이고 장어덮밥은 2만원인데,이 중에 뭐 먹지
  @override
  Widget build(BuildContext context) {
    final characterState = ref.watch(characterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '똑똑소비봇',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 260,
                    ),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      widget.userInput,
                      style: AppFonts.body1Rg
                    ),
                  ),
                ),
                if (isLoading)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 260,
                      ),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.lightPurple,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            strokeWidth: 4,
                            color: AppColors.primaryPurple,
                          ),
                          const SizedBox(width: 9),
                          const Text(
                            '응답을 기다리는 중...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...backendResponse.asMap().entries.map((entry) {
                  int index = entry.key;
                  String responseText = entry.value;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0)
                          characterState.when(
                            data: (character) => character != null
                                ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Image.asset(
                                character.imgPath,
                                width: 36,
                                height: 34,
                                fit: BoxFit.contain,
                              ),
                            )
                                : SizedBox(width: 40, height: 40),
                            loading: () => SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            error: (e, _) => SizedBox(width: 40, height: 40),
                          ),
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 260,
                          ),
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightPurple,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            responseText,
                            style: AppFonts.body1Sb
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
