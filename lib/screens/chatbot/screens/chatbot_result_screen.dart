import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';

class ChatbotResultScreen extends StatefulWidget {
  final String userInput;

  ChatbotResultScreen({required this.userInput});

  @override
  _ChatbotResultScreenState createState() => _ChatbotResultScreenState();
}

class _ChatbotResultScreenState extends State<ChatbotResultScreen> {
  String? backendResponse; // 백엔드 응답 데이터
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    _fetchBackendResponse(); // 백엔드 응답 요청
  }

  Future<void> _fetchBackendResponse() async {
    // 백엔드 통신 시뮬레이션 (실제로는 API 호출 코드 작성)
    await Future.delayed(Duration(seconds: 4)); // 2초 로딩 시뮬레이션

    setState(() {
      backendResponse = '백엔드에서 받은 응답입니다!';
      isLoading = false; // 로딩 완료
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '알뜰챗봇',
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
                // 사용자 메시지
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      widget.userInput,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                // 백엔드 응답 또는 로딩 애니메이션
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.lightPurple,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: isLoading
                        ? Row(
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
                    )
                        : Text(
                      backendResponse ?? '응답 없음',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,

                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
