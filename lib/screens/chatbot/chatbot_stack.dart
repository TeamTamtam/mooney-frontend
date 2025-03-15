// import 'package:flutter/material.dart';
// import './screens/chatbot_screen.dart';
// import './screens/chatbot_result_screen.dart';
//
// class ChatbotStack extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       initialRoute: '/chatbot',
//       onGenerateRoute: (settings) {
//         Widget page;
//         switch (settings.name) {
//           case '/chatbot':
//             page = ChatbotScreen();
//             break;
//           case '/chatbotResult':
//             final userInput = settings.arguments as String;
//             page = ChatbotResultScreen(userInput: userInput);
//             break;
//           default:
//             page = ChatbotScreen();
//         }
//         return MaterialPageRoute(builder: (_) => page);
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import './screens/chatbot_screen.dart';
import './screens/chatbot_result_screen.dart';

class ChatbotStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/chatbot',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/chatbot':
            return MaterialPageRoute(builder: (_) => ChatbotScreen());
          case '/chatbotResult':
            final userInput = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ChatbotResultScreen(userInput: userInput),
            );
          default:
            // return MaterialPageRoute(
            //   builder: (_) => Scaffold(
            //     body: Center(
            //       child: Text('404 - 페이지를 찾을 수 없습니다c'),
            //     ),
            //   ),
            // );
            return MaterialPageRoute(builder: (_) => ChatbotScreen());
        }
      },
    );
  }
}

