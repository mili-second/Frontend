import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/insight/view/special_this_weeks.dart';
import '/insight/view/engagement_analysis.dart';
import '/insight/view/pattern_analysis_by_day_of_the_week.dart';
import '/insight/view/weekly_changing_trends.dart';

class InsightView extends StatefulWidget {
  const InsightView({super.key});

  @override
  State<InsightView> createState() => _InsightViewState();
}

class _InsightViewState extends State<InsightView> {
  // 이번주 특이사항 데이터
  final String _specialThisWeeksComment =
      '목요일에 사용량이 최대치를 기록했어요. 새 게임 설치 후 다른 앱 사용 패턴이 완전히 바뀌었네요!';

  // SNS 몰입도 분석 데이터
  final String _engagementAnalysisComment =
      '인스타 그램 실행횟수 30회 증가! 이번주는 SNS에 유독 많이들어가는군요!';

  // 요일별 패턴 분석 데이터
  final String _patternAnalysisByDayOfTheWeekComment =
      '목요일에 스트레스가 쌓여 폰 사용이 급증하고, 금요일엔 해방감으로 엔터테인먼트에 몰두하는 패턴이 뚜렷해요.';
  final int _averageDailySNSTime = 150;
  final int _EarlyMorningConnectionRate = 67;

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20.h),

          // 이번주 특이사항
          SpecialThisWeeks(comment: _specialThisWeeksComment),

          SizedBox(height: 20.h),

          // SNS 몰입도 분석
          EngagementAnalysis(
            comment: _engagementAnalysisComment,
            SNSTime: _averageDailySNSTime,
            rate: _EarlyMorningConnectionRate,
          ),

          SizedBox(height: 20.h),

          // 요일별 패턴 분석
          PatternAnalysisByDayOfTheWeek(
            comment: _patternAnalysisByDayOfTheWeekComment,
          ),

          SizedBox(height: 20.h),

          // 주간 변화 트렌드
          WeeklyChangingTrends(
            comment: _weeklyChangingTrendsComment,
            totalUsageTime: _totalUsageTime,
            categoryUsageTime: _categoryAndChangeInUse,
          ),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
