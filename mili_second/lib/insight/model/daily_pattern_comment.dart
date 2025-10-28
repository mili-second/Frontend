// insight/model/daily_pattern_comment.dart
class DailyPatternComment {
  final String date;
  final String behaviorComment; // Changed from 'comment'
  final String contentComment;  // Added new field

  DailyPatternComment({
    required this.date,
    required this.behaviorComment,
    required this.contentComment,
  });
}