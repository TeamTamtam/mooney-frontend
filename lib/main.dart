import 'package:flutter/material.dart';
import 'package:mooney2/screens/splash_screen.dart';
import 'config/routes.dart';
import 'constants/app_fonts.dart';
import 'package:mooney2/services/notification_plugin.dart';
import 'package:mooney2/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
 // 앱 실행 파일


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // ✅ .env 파일 로드
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool loggedIn = await authService.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
    });

    if (loggedIn) {
      NotificationPlugin.startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: AppFonts.fontFamily, // ✅ 폰트 설정 올바르게 적용
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const SplashScreen()); // ✅ 올바른 화면으로 연결
        }
        return AppRoutes.generateRoute(settings); // ✅ 경로 설정
      },
    );
  }
}

