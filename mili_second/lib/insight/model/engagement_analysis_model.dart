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
    return EngagementAnalysisModel(
      snsUsageRate: json['snsUsageRate'] ?? 0,
      dawnAccessRate: json['dawnAccessRate'] ?? 0,
      calculatedDate: json['calculatedDate'] ?? '',
    );
  }
}
