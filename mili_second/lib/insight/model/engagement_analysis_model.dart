class EngagementAnalysisModel {
  final int snsUsageRate;
  final int dawnAccessRate;
  final String calculatedDate;

  EngagementAnalysisModel({
    required this.snsUsageRate,
    required this.dawnAccessRate,
    required this.calculatedDate,
  });

  factory EngagementAnalysisModel.fromJson(Map<String, dynamic> json) {
    // 1. json 값을 num 타입으로 안전하게 읽어옵니다. (null이면 0.0 사용)
    num snsRateNum = json['snsUsageRate'] ?? 0.0;
    num dawnRateNum = json['dawnAccessRate'] ?? 0.0;

    return EngagementAnalysisModel(
      snsUsageRate: (snsRateNum).round(),
      dawnAccessRate: (dawnRateNum).round(),
      calculatedDate: json['calculatedDate'] ?? '',
    );
  }
}
