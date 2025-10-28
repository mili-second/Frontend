import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:milli_second/insight/model/special_this_weeks_model.dart';

class SpecialThisWeeksViewModel {
  Future<String?> fetchSpecialThisWeek() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String baseUrl = "https://api.yolang.shop";
    final url = Uri.parse('$baseUrl/insights/ai-summary');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['summary'] as String;
      } else {
        print('❌ 인사이트 - 특이사항 오류: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('⚠️ 인사이트 - 특이사항 요청 중 오류 발생: $e');
      return null;
    }
  }
}
