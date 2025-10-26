import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mili_second/insight/model/pattern_analysis_by_day_of_the_week_model.dart';

class BehaviorPatternsViewModel {
  Future<List<BehaviorPatternModel>> fetchBehaviorPatterns() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String baseUrl = "https://api.yolang.shop";
    final url = Uri.parse('$baseUrl/insights/behavior-patterns');

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
        return data.map((e) => BehaviorPatternModel.fromJson(e)).toList();
      } else {
        print('❌ 행동 패턴 서버 오류: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('⚠️ 행동 패턴 요청 중 오류 발생: $e');
      return [];
    }
  }
}
