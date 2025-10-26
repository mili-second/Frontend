class WeeklyUsage {
  final String date;
  final double totalUsageMinutes;

  WeeklyUsage({required this.date, required this.totalUsageMinutes});

  factory WeeklyUsage.fromJson(Map<String, dynamic> json) {
    return WeeklyUsage(
      date: json['date'],
      totalUsageMinutes: (json['totalUsageMinutes'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'totalUsageMinutes': totalUsageMinutes};
  }
}
