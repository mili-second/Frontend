import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/usage_patterns_by_time_of_day_model.dart';

class UsagePatternsByTimeOfDayViewModel {
  Future<List<UsagePatternsByTimeOfDayModel>> fetchUsagePatternsByTimeOfDay(
    String subjectId,
  ) async {
    final String baseUrl = "http://210.178.40.108:30088";
    final url = Uri.parse('$baseUrl/usage/stats/category/$subjectId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => UsagePatternsByTimeOfDayModel.fromJson(e))
            .toList();
      } else {
        print('❌ 서버 오류: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('⚠️ 요청 중 오류 발생: $e');
      return [];
    }
  }
}
