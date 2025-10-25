import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/top3_app_usage_model.dart';
import 'package:intl/intl.dart';

class Top3AppUsageModelView {
  Future<List<Top3AppUsage>> fetchTop3AppUsageTrend(String subjectId) async {
    final String baseUrl = "http://api.yolang.shop";
    final url = Uri.parse('$baseUrl/usage/stats/top3/$subjectId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Top3AppUsage.fromJson(e)).toList();
      } else {
        print('❌ 분석 - top3 서버 오류: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('⚠️ 분석 - top3 요청 중 오류 발생: $e');
      return [];
    }
  }
}
