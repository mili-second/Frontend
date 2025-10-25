import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/usage_patterns_by_time_of_day_model.dart';

class UsagePatternsByTimeOfDayViewModel {
  final String baseUrl = "http://api.yolang.shop";

  Future<List<UsagePatternsByTimeOfDayModel>> fetchUsagePatternsByTimeOfDay(
    String subjectId,
  ) async {
    final url = Uri.parse('$baseUrl/usage/stats/3day/$subjectId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List<dynamic> data = jsonDecode(response.body);
        data.sort((a, b) => b.date.compareTo(a.date)); // 최신 날짜가 먼저 오도록 정렬
        return data
            .map((e) => UsagePatternsByTimeOfDayModel.fromJson(e))
            .toList();
      } else {
        print('❌ 분석 - 3일 서버 오류: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('⚠️ 분석 - 3일 요청 오류 발생: $e');
      return [];
    }
  }
}
