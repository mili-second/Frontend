class SpecialThisWeeksModel {
  final String summary;

  SpecialThisWeeksModel({required this.summary});

  factory SpecialThisWeeksModel.fromJson(Map<String, dynamic> json) {
    return SpecialThisWeeksModel(summary: json['summary']);
  }

  Map<String, dynamic> toJson() {
    return {'summary': summary};
  }
}
