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

class ContentPreferenceModel {
  final String date;
  final String contentPreference;
  final String contentPreferenceKo;

  ContentPreferenceModel({
    required this.date,
    required this.contentPreference,
    required this.contentPreferenceKo,
  });

  factory ContentPreferenceModel.fromJson(Map<String, dynamic> json) {
    return ContentPreferenceModel(
      date: json['date'],
      contentPreference: json['contentPreference'],
      contentPreferenceKo: json['contentPreferenceKo'],
    );
  }
}