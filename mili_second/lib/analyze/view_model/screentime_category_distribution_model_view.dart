import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mili_second/analyze/model/screentime_category_distribution_model.dart';

class ScreentimeCategoryDistributionViewModel {
  Future<List<ScreentimeCategoryDistributionModel>>
  fetchScreentimeCategoryDistribution(String subjectId) async {
    final String baseUrl = "http://api.yolang.shop";
    final url = Uri.parse('$baseUrl/usage/stats/category/$subjectId');

    try {
      final response = await http.get(url);

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
