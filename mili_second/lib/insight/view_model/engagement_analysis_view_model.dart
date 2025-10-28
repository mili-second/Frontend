import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:milli_second/insight/model/engagement_analysis_model.dart';

class EngagementAnalysisViewModel {
  Future<EngagementAnalysisModel?> fetchUsageInsight() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String baseUrl = "https://api.yolang.shop";
    final url = Uri.parse('$baseUrl/usage/insight');

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
        return EngagementAnalysisModel.fromJson(jsonData);
      } else {
        print('❌ 인사이트 - sns 서버 오류: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('⚠️ 인사이트 - sns 요청 오류: $e');
      return null;
    }
  }
}
