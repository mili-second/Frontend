// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../model/seven_days_usage_model.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SevenDaysUsageViewModel {
//   Future<List<double>> fetchWeeklyUsageTrend() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final String baseUrl = "https://api.yolang.shop";
//     final url = Uri.parse('$baseUrl/usage/stats/weekly');

//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         // JSON → 모델 변환
//         final List<WeeklyUsage> usageList = data
//             .map((e) => WeeklyUsage.fromJson(e))
//             .toList();

//         // 이번주 월 - 일 날짜 리스트 생성
//         final now = DateTime.now();
//         final monday = now.subtract(Duration(days: now.weekday - 1));
//         final List<DateTime> weekDates = List.generate(
//           7,
//           (i) => monday.add(Duration(days: i)),
//         );

//         final dateFormatter = DateFormat('yyyy-MM-dd');
//         final Map<String, double> usageMap = {
//           for (var u in usageList) u.date: u.totalUsageMinutes,
//         };

//         // 누락된 날짜는 0으로 채움
//         final List<double> trendData = weekDates.map((date) {
//           final formatted = dateFormatter.format(date);
//           return usageMap[formatted] ?? 0.0;
//         }).toList();

//         return trendData;
//       } else {
//         print('❌ 분석 - seven_days 서버 응답 오류: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('⚠️ 분석 - seven_days 요청 중 오류 발생: $e');
//       return [];
//     }
//   }

//   /// 오늘 하루의 사용
//   Future<double> fetchTodayUsage() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final String baseUrl = "https://api.yolang.shop";
//     // 오늘 사용량 API 엔드포인트
//     final url = Uri.parse('$baseUrl/usage/stats/weekly/today'); 

//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         // API가 WeeklyUsage 모델과 동일한 JSON 객체 하나를 반환한다고 가정
//         final Map<String, dynamic> data = jsonDecode(response.body);
//         final WeeklyUsage todayUsage = WeeklyUsage.fromJson(data);

//         // "분" 단위를 "시간" 단위로 변환하여 반환
//         return (todayUsage.totalUsageMinutes);
        
//       } else {
//         print('❌ 분석 - today_usage 서버 응답 오류: ${response.statusCode}');
//         return 0.0; // 실패 시 0 반환
//       }
//     } catch (e) {
//       print('⚠️ 분석 - today_usage 요청 중 오류 발생: $e');
//       return 0.0; // 실패 시 0 반환
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/seven_days_usage_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SevenDaysUsageViewModel {
  // Mock 데이터 사용 여부
  final bool useMockData = true; // false로 바꾸면 실제 API 사용

  // Mock 데이터 - 지난 7일
  final String _mockWeeklyJson = '''
  [
    {
      "date": "2025-10-21",
      "totalUsageMinutes": 62
    },
    {
      "date": "2025-10-22",
      "totalUsageMinutes": 62
    },
    {
      "date": "2025-10-23",
      "totalUsageMinutes": 61
    },
    {
      "date": "2025-10-24",
      "totalUsageMinutes": 162
    },
    {
      "date": "2025-10-25",
      "totalUsageMinutes": 67
    },
    {
      "date": "2025-10-26",
      "totalUsageMinutes": 57
    },
    {
      "date": "2025-10-27",
      "totalUsageMinutes": 8
    }
  ]
  ''';

  // Mock 데이터 - 오늘
  final String _mockTodayJson = '''
  {
    "date": "2025-10-28",
    "totalUsageMinutes": 10
  }
  ''';

  Future<List<double>> fetchWeeklyUsageTrend() async {
    // Mock 데이터 사용
    if (useMockData) {
      print('📊 Mock 데이터 사용 - Weekly Usage');
      await Future.delayed(Duration(milliseconds: 500)); // 네트워크 지연 시뮬레이션
      
      final List<dynamic> data = jsonDecode(_mockWeeklyJson);
      final List<WeeklyUsage> usageList = data
          .map((e) => WeeklyUsage.fromJson(e))
          .toList();

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

      final List<double> trendData = weekDates.map((date) {
        final formatted = dateFormatter.format(date);
        return usageMap[formatted] ?? 0.0;
      }).toList();

      return trendData;
    }

    // 실제 API 호출
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
        final List<WeeklyUsage> usageList = data
            .map((e) => WeeklyUsage.fromJson(e))
            .toList();

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

        final List<double> trendData = weekDates.map((date) {
          final formatted = dateFormatter.format(date);
          return usageMap[formatted] ?? 0.0;
        }).toList();

        return trendData;
      } else {
        print('❌ 분석 - seven_days 서버 응답 오류: ${response.statusCode}');
        print('📊 Mock 데이터로 대체');
        // 서버 오류 시 Mock 데이터 반환
        final List<dynamic> data = jsonDecode(_mockWeeklyJson);
        final List<WeeklyUsage> usageList = data
            .map((e) => WeeklyUsage.fromJson(e))
            .toList();
        return usageList.map((e) => e.totalUsageMinutes).toList();
      }
    } catch (e) {
      print('⚠️ 분석 - seven_days 요청 중 오류 발생: $e');
      print('📊 Mock 데이터로 대체');
      // 오류 시 Mock 데이터 반환
      final List<dynamic> data = jsonDecode(_mockWeeklyJson);
      final List<WeeklyUsage> usageList = data
          .map((e) => WeeklyUsage.fromJson(e))
          .toList();
      return usageList.map((e) => e.totalUsageMinutes).toList();
    }
  }

  /// 오늘 하루의 사용
  Future<double> fetchTodayUsage() async {
    // Mock 데이터 사용
    if (useMockData) {
      print('📊 Mock 데이터 사용 - Today Usage');
      await Future.delayed(Duration(milliseconds: 500)); // 네트워크 지연 시뮬레이션
      
      final Map<String, dynamic> data = jsonDecode(_mockTodayJson);
      final WeeklyUsage todayUsage = WeeklyUsage.fromJson(data);
      return todayUsage.totalUsageMinutes;
    }

    // 실제 API 호출
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String baseUrl = "https://api.yolang.shop";
    final url = Uri.parse('$baseUrl/usage/stats/weekly/today');

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
        final WeeklyUsage todayUsage = WeeklyUsage.fromJson(data);
        return todayUsage.totalUsageMinutes;
      } else {
        print('❌ 분석 - today_usage 서버 응답 오류: ${response.statusCode}');
        print('📊 Mock 데이터로 대체');
        // 서버 오류 시 Mock 데이터 반환
        final Map<String, dynamic> data = jsonDecode(_mockTodayJson);
        final WeeklyUsage todayUsage = WeeklyUsage.fromJson(data);
        return todayUsage.totalUsageMinutes;
      }
    } catch (e) {
      print('⚠️ 분석 - today_usage 요청 중 오류 발생: $e');
      print('📊 Mock 데이터로 대체');
      // 오류 시 Mock 데이터 반환
      final Map<String, dynamic> data = jsonDecode(_mockTodayJson);
      final WeeklyUsage todayUsage = WeeklyUsage.fromJson(data);
      return todayUsage.totalUsageMinutes;
    }
  }
}