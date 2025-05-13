import 'package:flutter/material.dart';
import 'package:mooney2/screens/splash_screen.dart';
import 'config/routes.dart';
import 'constants/app_fonts.dart';
import 'package:mooney2/services/notification_plugin.dart';
import 'package:mooney2/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
 // 앱 실행 파일

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // ✅ .env 파일 로드
  // ✅ 기존에 암호화 방식 다르게 저장된 토큰 삭제 (초기화 용도)
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: false), // 기존 설정
  );
  await storage.deleteAll(); // ⚠️ 기존 잘못된 형식으로 저장된 토큰 초기화
  print("🧹 기존 토큰 삭제 완료");

  // NotificationPlugin.startListening();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
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

