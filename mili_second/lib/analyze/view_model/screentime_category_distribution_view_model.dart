import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mili_second/analyze/model/screentime_category_distribution_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreentimeCategoryDistributionViewModel {
  Future<List<ScreentimeCategoryDistributionModel>>
  fetchScreentimeCategoryDistribution() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String baseUrl = "https://api.yolang.shop";
    final url = Uri.parse('$baseUrl/usage/stats/category');

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
        return data
            .map((e) => ScreentimeCategoryDistributionModel.fromJson(e))
            .toList();
      } else {
        print('❌ 분석 - 카테고리 서버 오류: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('⚠️ 분석 - 카테고리 요청 중 오류 발생: $e');
      return [];
    }
  }
}
