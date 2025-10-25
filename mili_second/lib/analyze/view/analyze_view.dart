import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:mili_second/analyze/view_model/seven_days_usage_model_view.dart';
import 'package:mili_second/analyze/view_model/usage_patterns_by_time_of_day_view_model.dart';
import 'package:mili_second/analyze/view_model/top3_app_usage_model_view.dart';
import 'package:mili_second/analyze/view_model/screentime_category_distribution_model_view.dart';
import 'package:mili_second/analyze/model/top3_app_usage_model.dart';
import 'package:mili_second/analyze/model/screentime_category_distribution_model.dart';
import '/analyze/view/seven_days_usage_trends.dart';
import '/analyze/view/usage_patterns_by_time_of_day.dart';
import '/analyze/view/top3_app_usage_trends.dart';
import '/analyze/view/screentime_category_distribution.dart';
import '/model/user_model.dart';

class AnalyzeView extends StatefulWidget {
  const AnalyzeView({super.key});

  @override
  State<AnalyzeView> createState() => _AnalyzeViewState();
}

class _AnalyzeViewState extends State<AnalyzeView> {
  // 7일간 사용 트렌트 데이터
  // List<double> _sevenDaysUsageTrendDatas = [0, 6, 12, 18, 24, 0, 18];
  final SevenDaysUsageViewModel _sevenDaysUsageViewModel =
      SevenDaysUsageViewModel();
  List<double> _sevenDaysUsageTrendDatas = [];

  Future<void> _loadWeeklyUsage() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final subjectId = userModel.userId;

    if (subjectId == null) {
      print('subjectId가 없습니다. 로그인 후 시도해주세요.');
      return;
    }
    final trend = await _sevenDaysUsageViewModel.fetchWeeklyUsageTrend(
      subjectId,
    );
    setState(() {
      _sevenDaysUsageTrendDatas = trend;
    });
  }

  // Top3 앱 사용 트렌드 데이터
  // "rank": 1, "appName": "YouTube", "category": "entertain", "minutes": 300, "state": "활발 사용"
  // final List<List> _top3AppDatas = [
  //   ['1', '유튜브', 300, '활발 사용'],
  //   ['2', '인스타그램', 180, '꾸준히 사용'],
  //   ['3', '카카오톡', 150, '유지(-)'],
  // ];

  final Top3AppUsageModelView _top3AppUsageViewModel = Top3AppUsageModelView();
  List<Top3AppUsage> _top3AppsDatas = [];

  Future<void> _loadTop3Usage() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final subjectId = userModel.userId;

    if (subjectId == null) {
      print('⚠️ subjectId가 없습니다.');
      return;
    }
    print('📡 API 요청 시작: /usage/stats/top3/$subjectId');
    final data = await _top3AppUsageViewModel.fetchTop3AppUsageTrend(subjectId);
    setState(() {
      _top3AppsDatas = data;
    });
  }

  // usagePattern은 오늘, 오늘 - 1, 오늘 - 2로 3개의 리스트로 넘겨주며, 분 단위(Date)로 넘겨줌
  // final List<List<int>> _timeOfDayPatternDatas = [
  //   [80, 150, 200, 45],
  //   [0, 210, 30, 75],
  //   [100, 70, 75, 35],
  // ];
  // final String _timeOfDayPatternPeakTime = '오후 2-4시';
  List<List<int>> _timeOfDayPatternDatas = [];
  String _timeOfDayPatternPeakTime = '';

  final UsagePatternsByTimeOfDayViewModel _usagePatternsByTimeOfDayViewModel =
      UsagePatternsByTimeOfDayViewModel();

  Future<void> _usagePatternsUsage() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final subjectId = userModel.userId;

    if (subjectId == null) {
      print('⚠️ subjectId가 없습니다.');
      return;
    }

    final data = await _usagePatternsByTimeOfDayViewModel
        .fetchUsagePatternsByTimeOfDay(subjectId);
    setState(() {
      _timeOfDayPatternDatas = data.map((day) {
        // [dawnMinutes, morningMinutes, afternoonMinutes, eveningMinutes]
        return [
          day.dawnMinutes,
          day.morningMinutes,
          day.afternoonMinutes,
          day.eveningMinutes,
        ];
      }).toList();

      _timeOfDayPatternPeakTime = data[0].mostActiveHourStart ?? 'No data';
    });
  }

  // 스크린타임 카테고리 분포 데이터
  // final String _categoryDistributionSummary =
  //     '현재까지 스크린 타임에서 게임이 45%로 가장 높은 비중을 차지하고 있어요.';
  // final List<List> _categoryDistribution = [
  //   ['SNS', 30],
  //   ['게임', 25],
  //   ['C', 20],
  //   ['D', 15],
  //   ['E', 10],
  // ];

  final ScreentimeCategoryDistributionViewModel _categoryViewModel =
      ScreentimeCategoryDistributionViewModel();
  List<ScreentimeCategoryDistributionModel> _categoryDistribution = [];

  Future<void> _loadCategoryUsage() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final subjectId = userModel.userId;

    if (subjectId == null) {
      print('⚠️ subjectId가 없습니다.');
      return;
    }

    final data = await _categoryViewModel.fetchScreentimeCategoryDistribution(
      subjectId,
    );
    setState(() {
      _categoryDistribution = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWeeklyUsage();
    _loadTop3Usage();
    _loadCategoryUsage();
    _usagePatternsUsage();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: kIsWeb ? 20 : 20.h),
          // 7일간 사용 트렌트
          SevenDaysUsageTrends(datas: _sevenDaysUsageTrendDatas),

          SizedBox(height: kIsWeb ? 20 : 20.h),

          // 시간대별 사용 패턴
          // UsagePatternsByTimeOfDay(
          //   //timeOfDayPatternSummary: _timeOfDayPatternSummary,
          //   datas: _timeOfDayPatternDatas,
          //   timeOfDayPatternPeakTime: _timeOfDayPatternPeakTime,
          // ),
          SizedBox(height: kIsWeb ? 20 : 20.h),

          // Top3 앱 사용 트렌드
          Top3AppUsageTrends(
            //top3AppSummary: _top3AppSummary,
            datas: _top3AppsDatas,
          ),
          SizedBox(height: kIsWeb ? 20 : 20.h),

          // 스크린타임 카테고리 분포
          ScreentimeCategoryDistribution(
            //categoryDistributionSummary: _categoryDistributionSummary,
            chartData: _categoryDistribution,
          ),
          SizedBox(height: kIsWeb ? 30 : 30.h),
        ],
      ),
    );
  }
}
