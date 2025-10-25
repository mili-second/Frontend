class ScreentimeCategoryDistributionModel {
  final String categoryName;
  final double ratio;

  ScreentimeCategoryDistributionModel({
    required this.categoryName,
    required this.ratio,
  });

  factory ScreentimeCategoryDistributionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScreentimeCategoryDistributionModel(
      categoryName: json['categoryName'],
      ratio: (json['ratio'] as num).toDouble(), // 안전하게 double 변환
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'ratio': ratio,
  };
}
