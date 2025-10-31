import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:milli_second/analyze/view_model/seven_days_usage_view_model.dart';
import 'package:milli_second/analyze/view_model/usage_patterns_by_time_of_day_view_model.dart';
import 'package:milli_second/analyze/view_model/top3_app_usage_view_model.dart';
import 'package:milli_second/analyze/view_model/screentime_category_distribution_view_model.dart';
import 'package:milli_second/analyze/model/top3_app_usage_model.dart';
import 'package:milli_second/analyze/model/screentime_category_distribution_model.dart';
import '/analyze/view/seven_days_usage_trends.dart';
import '/analyze/view/usage_patterns_by_time_of_day.dart';
import '/analyze/view/top3_app_usage_trends.dart';
import '/analyze/view/screentime_category_distribution.dart';
import '/model/user_model.dart';
import '/home/view_model/today_usage_stats_view_model.dart';
import '/home/model/today_usage_stats_model.dart';

class AnalyzeView extends StatefulWidget {
  const AnalyzeView({super.key});

  @override
  State<AnalyzeView> createState() => _AnalyzeViewState();
}

class _AnalyzeViewState extends State<AnalyzeView> {
  // 7일간 사용 트렌트 데이터
  final SevenDaysUsageViewModel _sevenDaysUsageViewModel = SevenDaysUsageViewModel();
  final TodayUsageStatsViewModel _todayUsageStatsViewModel = TodayUsageStatsViewModel();

  List<double> _sevenDaysUsageTrendDatas = [];
  List<String> _sevenDaysDateLabels = [];
  TodayUsageStatsModel? _todayStats;
  bool _isLoadingWeekly = true;

  Future<void> _loadWeeklyUsage() async {
    setState(() {
      _isLoadingWeekly = true;
    });

    // 먼저 오늘 데이터를 가져옴
    final userModel = context.read<UserModel>();
    _todayStats = await _todayUsageStatsViewModel.fetchTodayUsageStats(userModel.userToken);

    // 오늘 데이터를 포함한 7일 트렌드 가져오기
    final result = await _sevenDaysUsageViewModel.fetchWeeklyUsageTrend(
      todayUsageMinutes: _todayStats?.totalUsageMinutes,
    );

    setState(() {
      _sevenDaysUsageTrendDatas = (result['data'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? [];
      _sevenDaysDateLabels = (result['labels'] as List?)?.map((e) => e.toString()).toList() ?? [];
      _isLoadingWeekly = false;
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
  bool _isLoadingTop3 = true;

  Future<void> _loadTop3Usage() async {
    setState(() {
      _isLoadingTop3 = true;
    });
    final data = await _top3AppUsageViewModel.fetchTop3AppUsageTrend();
    setState(() {
      _top3AppsDatas = data;
      _isLoadingTop3 = false;
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
  List<DateTime> _timeOfDayPatternDates = [];
  String _timeOfDayPatternPeakTime = '';
  bool _isLoadingTimePattern = true;

  final UsagePatternsByTimeOfDayViewModel _usagePatternsByTimeOfDayViewModel =
      UsagePatternsByTimeOfDayViewModel();

  Future<void> _usagePatternsUsage() async {
    setState(() {
      _isLoadingTimePattern = true;
    });
    final data = await _usagePatternsByTimeOfDayViewModel
        .fetchUsagePatternsByTimeOfDay();
    setState(() {
      if (data.isNotEmpty) {
        _timeOfDayPatternDatas = data.map((day) {
          return [
            day.dawnMinutes,
            day.morningMinutes,
            day.afternoonMinutes,
            day.eveningMinutes,
          ];
        }).toList();

        _timeOfDayPatternDates = data.map((day) => day.date).toList();

        _timeOfDayPatternPeakTime =
            data.first.mostActiveHourStart ?? '데이터 없음';
      } else {
        print('⚠️ 서버에서 빈 데이터가 반환되었습니다.');
        _timeOfDayPatternDatas = [];
        _timeOfDayPatternPeakTime = '데이터 없음';
      }
      _isLoadingTimePattern = false;
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
  bool _isLoadingCategory = true;

  Future<void> _loadCategoryUsage() async {
    setState(() {
      _isLoadingCategory = true;
    });
    final data = await _categoryViewModel.fetchScreentimeCategoryDistribution();
    setState(() {
      _categoryDistribution = data;
      _isLoadingCategory = false;
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
          _isLoadingWeekly
              ? Container(
                  width: kIsWeb ? 362 : 362.w,
                  height: kIsWeb ? 250 : 250.h,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: kIsWeb ? 10 : 10.h),
                      Text(
                        '데이터 로딩 중...',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: kIsWeb ? 14 : 14.r,
                        ),
                      ),
                    ],
                  ),
                )
              : SevenDaysUsageTrends(
                  datas: _sevenDaysUsageTrendDatas,
                  dateLabels: _sevenDaysDateLabels,
                ),

          SizedBox(height: kIsWeb ? 20 : 20.h),

          // 시간대별 사용 패턴
          _isLoadingTimePattern
              ? Container(
                  width: kIsWeb ? 362 : 362.w,
                  height: kIsWeb ? 280 : 280.h,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: kIsWeb ? 10 : 10.h),
                      Text(
                        '데이터 로딩 중...',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: kIsWeb ? 14 : 14.r,
                        ),
                      ),
                    ],
                  ),
                )
              : UsagePatternsByTimeOfDay(
                  datas: _timeOfDayPatternDatas,
                  dates: _timeOfDayPatternDates,
                  timeOfDayPatternPeakTime: _timeOfDayPatternPeakTime,
                ),
          SizedBox(height: kIsWeb ? 20 : 20.h),

          // Top3 앱 사용 트렌드
          _isLoadingTop3
              ? Container(
                  width: kIsWeb ? 362 : 362.w,
                  height: kIsWeb ? 270 : 270.h,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: kIsWeb ? 10 : 10.h),
                      Text(
                        '데이터 로딩 중...',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: kIsWeb ? 14 : 14.r,
                        ),
                      ),
                    ],
                  ),
                )
              : Top3AppUsageTrends(
                  datas: _top3AppsDatas,
                ),
          SizedBox(height: kIsWeb ? 20 : 20.h),

          // 스크린타임 카테고리 분포
          _isLoadingCategory
              ? Container(
                  width: kIsWeb ? 362 : 362.w,
                  height: kIsWeb ? 500 : 500.h,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: kIsWeb ? 10 : 10.h),
                      Text(
                        '데이터 로딩 중...',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: kIsWeb ? 14 : 14.r,
                        ),
                      ),
                    ],
                  ),
                )
              : ScreentimeCategoryDistribution(
                  chartData: _categoryDistribution,
                ),
          SizedBox(height: kIsWeb ? 30 : 30.h),
        ],
      ),
    );
  }
}
