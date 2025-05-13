import 'package:flutter/material.dart';
import 'package:mooney2/widgets/bottom_navi.dart';
import 'package:mooney2/screens/home/screens/home_screen.dart';
import 'package:mooney2/screens/month/screens/month_screen.dart';
import 'package:mooney2/screens/chatbot/screens/chatbot_screen.dart';
import 'package:mooney2/screens/chatbot/chatbot_stack.dart';
import 'package:mooney2/screens/profile/profile_stack.dart';
import 'package:mooney2/screens/mission/screens/mission_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    MonthScreen(),
    MissionScreen(),
    ChatbotStack(),
    ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavi(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
