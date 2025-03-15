class FormValidator {
  static String? validateEmail(String email) {
    if (!email.contains('@')) {
      return '올바른 이메일 형식을 입력하세요.';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.length < 8 || password.length > 20) {
      return '비밀번호는 8~20자 사이여야 합니다.';
    }
    return null;
  }

  static String? validatePasswordConfirm(String password, String confirmPassword) {
    return password == confirmPassword ? '비밀번호 확인이 일치합니다.' : '비밀번호가 일치하지 않습니다.';
  }

  static String? validateName(String name) {
    if (name.isEmpty || name.length > 10) {
      return '이름은 1~10자 사이여야 합니다.';
    }
    return null;
  }
}
