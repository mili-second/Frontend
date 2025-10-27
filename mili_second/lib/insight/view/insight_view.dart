import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import '/insight/view/special_this_weeks.dart';
import '/insight/view/engagement_analysis.dart';
import '/insight/view/pattern_analysis_by_day_of_the_week.dart';
import '/insight/view/weekly_changing_trends.dart';
import 'package:mili_second/insight/view_model/special_this_weeks_view_model.dart';
import 'package:mili_second/insight/view_model/pattern_analysis_by_day_of_the_week_view_model.dart';
import 'package:mili_second/insight/model/pattern_analysis_by_day_of_the_week_model.dart';
import 'package:mili_second/insight/view_model/engagement_analysis_view_model.dart';

class InsightView extends StatefulWidget {
  const InsightView({super.key});

  @override
  State<InsightView> createState() => _InsightViewState();
}

class _InsightViewState extends State<InsightView> {
  // 이번주 특이사항 데이터
  // final String _specialThisWeeksComment =
  //    '목요일에 사용량이 최대치를 기록했어요. 새 게임 설치 후 다른 앱 사용 패턴이 완전히 바뀌었네요!';
  String _specialThisWeeksComment = '';
  final _specialThisWeeksViewModel = SpecialThisWeeksViewModel();

  Future<void> _loadSpecialThisWeeksComment() async {
    final summary = await _specialThisWeeksViewModel.fetchSpecialThisWeek();
    if (summary != null) {
      setState(() {
        _specialThisWeeksComment = summary;
      });
    } else {
      print("요약 데이터를 가져오지 못했습니다.");
    }
  }

  // SNS 몰입도 분석 데이터
  // final int _averageDailySNSTime = 150;
  // final int _EarlyMorningConnectionRate = 67;
  final EngagementAnalysisViewModel _engagementAnalysisViewModel =
      EngagementAnalysisViewModel();

  int snsUsageRate = 0;
  int dawnAccessRate = 0;

  Future<void> _loadEngagementAnalysis() async {
    final result = await _engagementAnalysisViewModel.fetchUsageInsight();
    if (result != null) {
      setState(() {
        snsUsageRate = result.snsUsageRate;
        dawnAccessRate = result.dawnAccessRate;
      });
    }
  }

  // 요일별 패턴 분석 데이터
  // final List<String> _patternAnalysisByDayOfTheWeekComment = [
  //   '늦잠 + SNS 몰아보기',
  //   '늦잠 + SNS 몰아보기',
  //   '늦잠 + SNS 몰아보기',
  //   '늦잠 + SNS 몰아보기',
  //   '늦잠 + SNS 몰아보기',
  //   '늦잠 + SNS 몰아보기',
  //   '늦잠 + SNS 몰아보기',
  // ];
  final BehaviorPatternsViewModel _behaviorPatternsViewModel =
      BehaviorPatternsViewModel();
  List<BehaviorPatternModel> _patternAnalysisByDayOfTheWeekComment = [];

  Future<void> _loadBehaviorPatterns() async {
    final data = await _behaviorPatternsViewModel.fetchBehaviorPatterns();

    // 날짜순 정렬 (오래된 → 최근)
    data.sort((a, b) {
      final aDate = DateTime.parse(a.date);
      final bDate = DateTime.parse(b.date);
      return aDate.compareTo(bDate);
    });

    setState(() {
      _patternAnalysisByDayOfTheWeekComment = data;
    });
  }

  // 주간 변화 트렌드 데이터
  final String _weeklyChangingTrendsComment =
      '새로운 관심사가 기존 패턴을 자연스럽게 변화시키고 있어요!';
  final String _totalUsageTime = '+2.3 시간';
  final List<List> _categoryAndChangeInUse = [
    ['SNS', '+ 150%'],
    ['독서', '- 60%'],
    ['게임', '+ 35%'],
  ];

  @override
  void initState() {
    super.initState();
    _loadSpecialThisWeeksComment();
    _loadBehaviorPatterns();
    _loadEngagementAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: kIsWeb ? 20 : 20.h),

          // 이번주 특이사항
          SpecialThisWeeks(comment: _specialThisWeeksComment),

          SizedBox(height: kIsWeb ? 20 : 20.h),

          // SNS 몰입도 분석
          EngagementAnalysis(
            snsUsageRate: snsUsageRate,
            dawnAccessRate: dawnAccessRate,
          ),

          SizedBox(height: kIsWeb ? 20 : 20.h),

          // 요일별 패턴 분석
          PatternAnalysisByDayOfTheWeek(
            patterns: _patternAnalysisByDayOfTheWeekComment,
          ),

          SizedBox(height: kIsWeb ? 20 : 20.h),

          // 주간 변화 트렌드
          WeeklyChangingTrends(
            comment: _weeklyChangingTrendsComment,
            totalUsageTime: _totalUsageTime,
            categoryUsageTime: _categoryAndChangeInUse,
          ),

          SizedBox(height: kIsWeb ? 30 : 30.h),
        ],
      ),
    );
  }
}
