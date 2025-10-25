class Top3AppUsage {
  final int rank;
  final String appName;
  final String packageName;
  final int usageMinutes;

  Top3AppUsage({
    required this.rank,
    required this.appName,
    required this.packageName,
    required this.usageMinutes,
  });

  factory Top3AppUsage.fromJson(Map<String, dynamic> json) {
    return Top3AppUsage(
      rank: json['rank'],
      appName: json['appName'],
      packageName: json['packageName'],
      usageMinutes: json['usageMiniutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'appName': appName,
      'packageName': packageName,
      'usageMinutes': usageMinutes,
    };
  }
}
