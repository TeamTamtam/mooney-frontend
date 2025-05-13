// class MissionData {
//   final String title;
//   final String description;
//   final String progressText;
//   final int index;
//
//   MissionData({
//     required this.title,
//     required this.description,
//     required this.progressText,
//     required this.index,
//   });
// }

class MissionData {
  final String title;
  final String description;
  final String progressText;
  final int index;

  MissionData({
    required this.title,
    required this.description,
    required this.progressText,
    required this.index,
  });

  factory MissionData.fromJson(Map<String, dynamic> json, int index) {
    return MissionData(
      title: json['title'],
      description: json['advice'],
      progressText: '현재까지 ${json['numOfExpense']}회 / ${json['amountOfExpense']}원 썼어요',
      index: index,
    );
  }
}
