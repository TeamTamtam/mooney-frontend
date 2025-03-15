import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';

class ChatbotScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
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
      body: Stack(
        children: [
          // 가운데 네모 컴포넌트 (고정된 콘텐츠)
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightPurple,
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/question.png',
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '고민되는 소비가 있다면\n',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '똑똑소비봇',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        TextSpan(
                          text: '에게\n조언을 구해보세요!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '이렇게 질문해 보세요 :\n"A는 10000원, B는 15000원인데\n둘 중에 뭘 살까?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 입력창 및 채팅 내용 (스크롤 가능)
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true, // 키보드가 올라왔을 때 입력창 보이기
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height, // 전체 화면 크기
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // 입력창
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.lightPurple),
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLines: 5, // 최대 5줄까지만 늘어남
                          minLines: 1, // 최소 1줄 크기 유지
                          keyboardType: TextInputType.multiline,
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '메시지 입력',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 전송 버튼
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryPurple,
                      ),
                      child: IconButton(
                        onPressed: () {
                          print("메시지 전송");
                          final userInput = _controller.text;
                          Navigator.pushNamed(
                            context,
                            '/chatbotResult',
                            arguments: userInput,
                          );
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
