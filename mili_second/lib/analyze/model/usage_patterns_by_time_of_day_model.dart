class UsagePatternsByTimeOfDayModel {
  final String categoryName;
  final double ratio;

  UsagePatternsByTimeOfDayModel({
    required this.categoryName,
    required this.ratio,
  });

  factory UsagePatternsByTimeOfDayModel.fromJson(Map<String, dynamic> json) {
    return UsagePatternsByTimeOfDayModel(
      categoryName: json['categoryName'],
      ratio: (json['ratio'] as num).toDouble(), // 안전하게 double 변환
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'ratio': ratio,
  };
}
