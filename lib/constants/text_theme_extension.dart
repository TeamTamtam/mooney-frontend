import 'package:flutter/material.dart';
import 'app_fonts.dart'; // ✅ AppFonts 사용을 위해 import

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  const AppTextTheme({
    required this.thin,
    required this.extraLight,
    required this.light,
    required this.regular,
    required this.medium,
    required this.semiBold,
    required this.bold,
    required this.extraBold,
    required this.black,
  });

  final TextStyle thin;
  final TextStyle extraLight;
  final TextStyle light;
  final TextStyle regular;
  final TextStyle medium;
  final TextStyle semiBold;
  final TextStyle bold;
  final TextStyle extraBold;
  final TextStyle black;

  @override
  AppTextTheme copyWith({
    TextStyle? thin,
    TextStyle? extraLight,
    TextStyle? light,
    TextStyle? regular,
    TextStyle? medium,
    TextStyle? semiBold,
    TextStyle? bold,
    TextStyle? extraBold,
    TextStyle? black,
  }) {
    return AppTextTheme(
      thin: thin ?? this.thin,
      extraLight: extraLight ?? this.extraLight,
      light: light ?? this.light,
      regular: regular ?? this.regular,
      medium: medium ?? this.medium,
      semiBold: semiBold ?? this.semiBold,
      bold: bold ?? this.bold,
      extraBold: extraBold ?? this.extraBold,
      black: black ?? this.black,
    );
  }

  @override
  ThemeExtension<AppTextTheme> lerp(ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) {
      return this;
    }
    return this;
  }
}

// BuildContext extension 추가
extension BuildContextExt on BuildContext {
  AppTextTheme get textTheme => Theme.of(this).extension<AppTextTheme>()!;
}