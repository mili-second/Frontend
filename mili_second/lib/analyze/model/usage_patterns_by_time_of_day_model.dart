class UsagePatternsByTimeOfDayModel {
  final DateTime date;
  final int dawnMinutes;
  final int morningMinutes;
  final int afternoonMinutes;
  final int eveningMinutes;
  final String mostActiveHourStart;

  UsagePatternsByTimeOfDayModel({
    required this.date,
    required this.dawnMinutes,
    required this.morningMinutes,
    required this.afternoonMinutes,
    required this.eveningMinutes,
    required this.mostActiveHourStart,
  });

  factory UsagePatternsByTimeOfDayModel.fromJson(Map<String, dynamic> json) {
    return UsagePatternsByTimeOfDayModel(
      date: DateTime.parse(json['date']),
      dawnMinutes: json['dawnMinutes'] ?? 0,
      morningMinutes: json['morningMinutes'] ?? 0,
      afternoonMinutes: json['afternoonMinutes'] ?? 0,
      eveningMinutes: json['eveningMinutes'] ?? 0,
      mostActiveHourStart: json['mostActiveHourStart'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'dawnMinutes': dawnMinutes,
    'morningMinutes': morningMinutes,
    'afternoonMinutes': afternoonMinutes,
    'eveningMinutes': eveningMinutes,
    'mostActiveHourStart': mostActiveHourStart,
  };
}
