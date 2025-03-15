enum ExpenseCategory {
  FOOD,
  CAFE_SNACKS,
  ALCOHOL_ENTERTAINMENT,
  LIVING,
  ONLINE_SHOPPING,
  FASHION_SHOPPING,
  BEAUTY_CARE,
  TRANSPORTATION,
  CAR,
  HOUSING_COMMUNICATION,
  HEALTHCARE,
  FINANCE,
  CULTURE_LEISURE,
  TRAVEL_ACCOMMODATION,
  EDUCATION,
  CHILDCARE,
  PET,
  GIFT_CEREMONY,
  OTHER
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.FOOD:
        return "식비";
      case ExpenseCategory.CAFE_SNACKS:
        return "카페/간식";
      case ExpenseCategory.ALCOHOL_ENTERTAINMENT:
        return "술/유흥";
      case ExpenseCategory.LIVING:
        return "생활";
      case ExpenseCategory.ONLINE_SHOPPING:
        return "온라인쇼핑";
      case ExpenseCategory.FASHION_SHOPPING:
        return "패션/쇼핑";
      case ExpenseCategory.BEAUTY_CARE:
        return "뷰티/미용";
      case ExpenseCategory.TRANSPORTATION:
        return "교통";
      case ExpenseCategory.CAR:
        return "자동차";
      case ExpenseCategory.HOUSING_COMMUNICATION:
        return "주거/통신";
      case ExpenseCategory.HEALTHCARE:
        return "의료/건강";
      case ExpenseCategory.FINANCE:
        return "금융";
      case ExpenseCategory.CULTURE_LEISURE:
        return "문화/여가";
      case ExpenseCategory.TRAVEL_ACCOMMODATION:
        return "여행/숙박";
      case ExpenseCategory.EDUCATION:
        return "교육/학습";
      case ExpenseCategory.CHILDCARE:
        return "자녀/육아";
      case ExpenseCategory.PET:
        return "반려동물";
      case ExpenseCategory.GIFT_CEREMONY:
        return "경조/선물";
      case ExpenseCategory.OTHER:
        return "이체";
    }
  }

  String get emoji {
    switch (this) {
      case ExpenseCategory.FOOD:
        return "🍽️";
      case ExpenseCategory.CAFE_SNACKS:
        return "🍩";
      case ExpenseCategory.ALCOHOL_ENTERTAINMENT:
        return "🍻";
      case ExpenseCategory.LIVING:
        return "🛒";
      case ExpenseCategory.ONLINE_SHOPPING:
        return "📦";
      case ExpenseCategory.FASHION_SHOPPING:
        return "👗";
      case ExpenseCategory.BEAUTY_CARE:
        return "💄";
      case ExpenseCategory.TRANSPORTATION:
        return "🚊";
      case ExpenseCategory.CAR:
        return "🚗";
      case ExpenseCategory.HOUSING_COMMUNICATION:
        return "🏡";
      case ExpenseCategory.HEALTHCARE:
        return "🏥";
      case ExpenseCategory.FINANCE:
        return "💰";
      case ExpenseCategory.CULTURE_LEISURE:
        return "🎧";
      case ExpenseCategory.TRAVEL_ACCOMMODATION:
        return "✈️";
      case ExpenseCategory.EDUCATION:
        return "📚";
      case ExpenseCategory.CHILDCARE:
        return "👶";
      case ExpenseCategory.PET:
        return "🐶";
      case ExpenseCategory.GIFT_CEREMONY:
        return "🎁";
      case ExpenseCategory.OTHER:
        return "↔️";
    }
  }

  /// **API 응답 문자열을 ENUM으로 변환하는 함수**
  static ExpenseCategory fromString(String category) {
    return ExpenseCategory.values.firstWhere(
          (e) => e.name == category,
      orElse: () => ExpenseCategory.OTHER, // 매칭되는 값이 없을 경우 기본값
    );
  }
}
