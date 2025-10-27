import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/seven_days_usage_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SevenDaysUsageViewModel {
  Future<List<double>> fetchWeeklyUsageTrend() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String baseUrl = "https://api.yolang.shop";
    final url = Uri.parse('$baseUrl/usage/stats/weelky');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // JSON → 모델 변환
        final List<WeeklyUsage> usageList = data
            .map((e) => WeeklyUsage.fromJson(e))
            .toList();

        // 이번주 월 - 일 날짜 리스트 생성
        final now = DateTime.now();
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final List<DateTime> weekDates = List.generate(
          7,
          (i) => monday.add(Duration(days: i)),
        );

        final dateFormatter = DateFormat('yyyy-MM-dd');
        final Map<String, double> usageMap = {
          for (var u in usageList) u.date: u.totalUsageMinutes,
        };

        // 누락된 날짜는 0으로 채움
        final List<double> trendData = weekDates.map((date) {
          final formatted = dateFormatter.format(date);
          return usageMap[formatted] ?? 0.0;
        }).toList();

        return trendData;
      } else {
        print('❌ 분석 - seven_days 서버 응답 오류: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('⚠️ 분석 - seven_days 요청 중 오류 발생: $e');
      return [];
    }
  }
}
