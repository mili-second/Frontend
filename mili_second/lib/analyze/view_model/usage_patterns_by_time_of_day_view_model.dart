import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/usage_patterns_by_time_of_day_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsagePatternsByTimeOfDayViewModel {
  Future<List<UsagePatternsByTimeOfDayModel>>
  fetchUsagePatternsByTimeOfDay() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String baseUrl = "https://api.yolang.shop";
    final url = Uri.parse('$baseUrl/usage/stats/3day');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // dailySummaries를 리스트로 꺼내기
        final List<dynamic> summaries = jsonData['dailySummaries'] ?? [];

        // 최신 날짜가 먼저 오도록 정렬
        summaries.sort((a, b) => b['date'].compareTo(a['date']));

        // 모델로 변환
        return summaries
            .map((e) => UsagePatternsByTimeOfDayModel.fromJson(e))
            .toList();
      } else {
        print('❌ 분석 - 시간대별 서버 오류: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('⚠️ 분석 - 시간대별 요청 오류 발생: $e');
      return [];
    }
  }
}
