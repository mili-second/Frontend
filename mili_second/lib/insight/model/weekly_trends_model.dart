// insight/model/weekly_trends_model.dart

class WeeklyTrendsModel {
  final String baseDate;
  final TotalUsageChange totalUsageChange;
  final List<CategoryChange> top3Categories;

  WeeklyTrendsModel({
    required this.baseDate,
    required this.totalUsageChange,
    required this.top3Categories,
  });

  factory WeeklyTrendsModel.fromJson(Map<String, dynamic> json) {
    var categoryList = json['top3Categories'] as List? ?? []; // null 체크 추가
    List<CategoryChange> categories = categoryList
        .map((i) => CategoryChange.fromJson(i as Map<String, dynamic>)) // 타입 캐스팅
        .toList();

    return WeeklyTrendsModel(
      baseDate: json['baseDate'] ?? '',
      totalUsageChange: TotalUsageChange.fromJson(json['totalUsageChange'] ?? {}), // null 체크 추가
      top3Categories: categories,
    );
  }
}

class TotalUsageChange {
  final int yesterdayMinutes;
  final num weeklyAverageMinutes; // double 가능성
  final int changeMinutes;
  final double changeRate;

  TotalUsageChange({
    required this.yesterdayMinutes,
    required this.weeklyAverageMinutes,
    required this.changeMinutes,
    required this.changeRate,
  });

  factory TotalUsageChange.fromJson(Map<String, dynamic> json) {
    return TotalUsageChange(
      yesterdayMinutes: (json['yesterdayMinutes'] ?? 0).toInt(),
      weeklyAverageMinutes: json['weeklyAverageMinutes'] ?? 0.0,
      changeMinutes: (json['changeMinutes'] ?? 0).toInt(),
      changeRate: ((json['changeRate'] ?? 0) as num).toDouble(), // 안전한 double 변환
    );
  }
  

  // 총 사용 시간 변화율 문자열 생성 (예: "+2.3 시간")
  String get totalUsageTimeString {
    double changeHours = changeMinutes / 60.0;
    String sign = changeHours >= 0 ? '+' : '';
    // 소수점 한 자리까지 표시
    return '$sign${changeHours.toStringAsFixed(1)} 시간';
  }
}

class CategoryChange {
  final int categoryId;
  final String categoryName; // 영어 이름
  final int yesterdayMinutes;
  final num weeklyAverageMinutes; // double 가능성
  final num changeMinutes;        // double 가능성
  final double changeRate;

  CategoryChange({
    required this.categoryId,
    required this.categoryName,
    required this.yesterdayMinutes,
    required this.weeklyAverageMinutes,
    required this.changeMinutes,
    required this.changeRate,
  });

  factory CategoryChange.fromJson(Map<String, dynamic> json) {
    return CategoryChange(
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName'] ?? 'UNKNOWN',
      yesterdayMinutes: (json['yesterdayMinutes'] ?? 0).toInt(),
      weeklyAverageMinutes: json['weeklyAverageMinutes'] ?? 0.0,
      changeMinutes: json['changeMinutes'] ?? 0.0,
      changeRate: ((json['changeRate'] ?? 0) as num).toDouble(), // 안전한 double 변환
    );
  }

  // 카테고리별 변화율 문자열 생성 (예: "+ 150%" 또는 "- 60%")
  String get changeRateString {
    String sign = changeRate >= 0 ? '+' : '-';
    // 소수점 없이 정수로 표시
    return '$sign ${changeRate.abs().toStringAsFixed(0)}%';
  }
}