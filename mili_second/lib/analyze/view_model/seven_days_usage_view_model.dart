import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/seven_days_usage_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SevenDaysUsageViewModel {
  // 과거 7일 데이터를 가져오는 함수 (오늘 제외)
  Future<Map<String, dynamic>> fetchWeeklyUsageTrend({int? todayUsageMinutes}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String baseUrl = "https://api.yolang.shop";
    final url = Uri.parse('$baseUrl/usage/stats/weekly');

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

        final dateFormatter = DateFormat('yyyy-MM-dd');
        final Map<String, double> usageMap = {
          for (var u in usageList) u.date: u.totalUsageMinutes,
        };

        // 오늘 날짜
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        // 과거 6일 + 오늘 = 총 7일 (오늘이 가장 오른쪽)
        final List<DateTime> last7Days = List.generate(
          7,
          (i) => today.subtract(Duration(days: 6 - i)), // 6일 전부터 오늘까지
        );

        // 각 날짜에 대한 사용 시간 데이터 (분 단위)
        final List<double> trendData = last7Days.asMap().entries.map((entry) {
          final index = entry.key;
          final date = entry.value;
          final formatted = dateFormatter.format(date);

          // 마지막 인덱스(6)가 오늘
          if (index == 6 && todayUsageMinutes != null) {
            return todayUsageMinutes.toDouble();
          }

          return usageMap[formatted] ?? 0.0;
        }).toList();

        // 시간 단위로 변환 (그래프에서 시간으로 표시)
        final List<double> trendDataInHours = trendData.map((minutes) => minutes / 60.0).toList();

        // 요일 레이블 생성 (월, 화, 수, ...)
        final List<String> weekDayLabels = ['월', '화', '수', '목', '금', '토', '일'];
        final List<String> dateLabels = last7Days.map((date) {
          // weekday: 1=월요일, 7=일요일
          return weekDayLabels[date.weekday - 1];
        }).toList();

        return {
          'data': trendDataInHours,
          'labels': dateLabels,
          'dates': last7Days,
        };
      } else {
        print('❌ 분석 - seven_days 서버 응답 오류: ${response.statusCode}');
        return {'data': [], 'labels': [], 'dates': []};
      }
    } catch (e) {
      print('⚠️ 분석 - seven_days 요청 중 오류 발생: $e');
      return {'data': [], 'labels': [], 'dates': []};
    }
  }
}
