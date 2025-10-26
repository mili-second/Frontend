class BehaviorPatternModel {
  final String date;
  final String behaviorPattern;
  final String behaviorPatternKo;

  BehaviorPatternModel({
    required this.date,
    required this.behaviorPattern,
    required this.behaviorPatternKo,
  });

  factory BehaviorPatternModel.fromJson(Map<String, dynamic> json) {
    return BehaviorPatternModel(
      date: json['date'],
      behaviorPattern: json['behaviorPattern'],
      behaviorPatternKo: json['behaviorPatternKo'],
    );
  }
}
