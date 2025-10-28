// insight/view_model/weekly_trends_view_model.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:milli_second/insight/model/weekly_trends_model.dart';

class WeeklyTrendsViewModel {
  Future<WeeklyTrendsModel?> fetchWeeklyTrends() async { // Nullable 반환 타입
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String baseUrl = "https://api.yolang.shop";
    // ✨ API 엔드포인트 확인 필요 (예시: /insights/weekly-trends)
    final url = Uri.parse('$baseUrl/usage/stats/weekly-trend');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WeeklyTrendsModel.fromJson(data);
      } else {
        print('❌ 주간 트렌드 서버 오류: ${response.statusCode}');
        return null; // 오류 시 null 반환
      }
    } catch (e) {
      print('⚠️ 주간 트렌드 요청 중 오류 발생: $e');
      return null; // 오류 시 null 반환
    }
  }
}