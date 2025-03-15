// class Mission {
//   final String title;
//   final String emoji;
//
//   Mission({required this.title, required this.emoji});
//
//   // JSON 데이터로부터 객체 생성 (API 연동 시 유용)
//   factory Mission.fromJson(Map<String, dynamic> json) {
//     return Mission(
//       title: json['title'] ?? '',
//       emoji: json['emoji'] ?? '',
//     );
//   }
//
//   // 객체를 JSON으로 변환 (필요한 경우)
//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'emoji': emoji,
//     };
//   }
// }
