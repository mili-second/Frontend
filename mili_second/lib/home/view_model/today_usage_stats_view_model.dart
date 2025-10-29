// lib/home/view_model/today_usage_stats_view_model.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/today_usage_stats_model.dart';

class TodayUsageStatsViewModel {
  final String _baseUrl = "https://api.yolang.shop";

  Future<TodayUsageStatsModel?> fetchTodayUsageStats(String? userToken) async {
    if (userToken == null) {
      print('토큰이 없어서 오늘의 사용 통계를 가져올 수 없습니다.');
      return null;
    }

    final url = Uri.parse('$_baseUrl/usage/stats/today');
    final headers = {
      'Authorization': 'Bearer $userToken',
      'accept': '*/*',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('오늘의 사용 통계 가져오기 성공');
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));

        // API 응답이 List 형태인지 Map 형태인지 확인
        if (responseData is List) {
          // List 형태면 첫 번째 요소를 사용
          if (responseData.isNotEmpty) {
            return TodayUsageStatsModel.fromJson(responseData[0]);
          } else {
            print('오늘의 사용 통계 데이터가 비어있습니다.');
            return null;
          }
        } else if (responseData is Map<String, dynamic>) {
          // Map 형태면 그대로 사용
          return TodayUsageStatsModel.fromJson(responseData);
        } else {
          print('예상하지 못한 응답 형식: ${responseData.runtimeType}');
          return null;
        }
      } else {
        print('오늘의 사용 통계 가져오기 실패: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('오늘의 사용 통계 API 호출 중 오류 발생: $e');
      return null;
    }
  }
}
