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
      // 2. 비율(0~1)을 퍼센트로 변환: 100을 곱하고 반올림하여 정수로 변환
      snsUsageRate: (snsRateNum * 100).round(),
      dawnAccessRate: (dawnRateNum * 100).round(),
      calculatedDate: json['calculatedDate'] ?? '',
    );
  }
}
