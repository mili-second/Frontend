// lib/home/model/today_usage_stats_model.dart

class TodayUsageStatsModel {
  final String date;
  final int totalUsageMinutes;
  final int pickupCount;

  TodayUsageStatsModel({
    required this.date,
    required this.totalUsageMinutes,
    required this.pickupCount,
  });

  factory TodayUsageStatsModel.fromJson(Map<String, dynamic> json) {
    return TodayUsageStatsModel(
      date: json['date'] ?? '',
      totalUsageMinutes: (json['totalUsageMinutes'] ?? 0).toInt(),
      pickupCount: (json['pickupCount'] ?? 0).toInt(),
    );
  }

  // 사용 시간을 포맷팅하는 헬퍼 함수
  String get formattedUsageTime {
    if (totalUsageMinutes < 60) {
      return '$totalUsageMinutes분';
    } else {
      final hours = totalUsageMinutes ~/ 60;
      final minutes = totalUsageMinutes % 60;
      if (minutes == 0) {
        return '${hours}시간';
      }
      return '${hours}시간 ${minutes}분';
    }
  }

  // unlock 횟수를 포맷팅하는 헬퍼 함수
  String get formattedPickupCount {
    return '${pickupCount}회';
  }
}
