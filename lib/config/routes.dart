import 'package:flutter/material.dart';
import 'package:mooney2/screens/home/screens/home_screen.dart';
import 'package:mooney2/screens/login/screens/login_screen.dart';
import 'package:mooney2/screens/root_screen.dart';
import 'package:mooney2/screens/notification/screens/notification_screen.dart';
import 'package:mooney2/screens/login/screens/signup_consent_screen.dart';
import 'package:mooney2/screens/login/screens/signup_form_screen.dart';
import 'package:mooney2/screens/first_budget/screens/splash_first_screen.dart';
import 'package:mooney2/screens/first_budget/screens/splash_second_screen.dart';
import 'package:mooney2/screens/first_budget/screens/fixed_budget_setup_screen.dart';
import 'package:mooney2/screens/month/screens/budget_edit_screen.dart';


class AppRoutes {
  static const String notifications = '/notifications';
  static const String home = '/home';
  static const String login = '/login';
  static const String root = '/root';
  static const String signupConsent = '/signupConsent';
  static const String signupForm = '/signupForm';
  static const String firstBudgetSplash = '/firstBudgetSplash';
  static const String firstBudgetSplash2 = '/firstBudgetSplash2';
  static const String fixedBudget = '/fixedBudget';
  static const String budgetEdit = '/budgetEdit';



  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(builder: (_) => RootScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signupConsent:
        return MaterialPageRoute(builder: (_) => SignupConsentScreen());
      case signupForm:
        return MaterialPageRoute(builder: (_) => SignupFormScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case firstBudgetSplash:
        return MaterialPageRoute(builder: (_) => SplashFirstScreen());
      case firstBudgetSplash2:
        return MaterialPageRoute(builder: (_) => SplashSecondScreen());
      case fixedBudget:
        return MaterialPageRoute(builder: (_) => FixedBudgetSetupScreen());
      case budgetEdit:
        return MaterialPageRoute(builder: (_) => BudgetEditScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('404 - 페이지를 찾을 수 없습니다')),
          ),
        );
    }
  }
}