import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import '/analyze/view/seven_days_usage_trends.dart';
import '/analyze/view/usage_patterns_by_time_of_day.dart';
import '/analyze/view/top3_app_usage_trends.dart';
import '/analyze/view/screentime_category_distribution.dart';

class AnalyzeView extends StatefulWidget {
  const AnalyzeView({super.key});

  @override
  State<AnalyzeView> createState() => _AnalyzeViewState();
}

class _AnalyzeViewState extends State<AnalyzeView> {
  // 7일간 사용 트렌트 데이터

  // Top3 앱 사용 트렌드 데이터
  // usagePattern은 오늘, 오늘 - 1, 오늘 - 2로 3개의 리스트로 넘겨주며, 분 단위(Date)로 넘겨줌
  List<List<int>> _timeOfDayPatternDatas = [
    [80, 150, 200, 45],
    [0, 210, 30, 75],
    [100, 70, 75, 35],
  ];
  final String _timeOfDayPatternSummary =
      '현재까지 오후에 사용량이 집중되어 있어요. 지금은 오후 시간대 활동 중입니다.';
  final String _timeOfDayPatternPeakTime = '오후 2-4시';

  // Top3 앱 사용 트렌드 데이터
  // "rank": 1, "appName": "YouTube", "category": "entertain", "minutes": 300, "state": "활발 사용"
  final List<List> _top3AppDatas = [
    ['1', '유튜브', 300, '활발 사용'],
    ['2', '인스타그램', 180, '꾸준히 사용'],
    ['3', '카카오톡', 150, '유지(-)'],
  ];

  // 스크린타임 카테고리 분포 데이터
  // final String _categoryDistributionSummary =
  //     '현재까지 스크린 타임에서 게임이 45%로 가장 높은 비중을 차지하고 있어요.';
  final List<List> _categoryDistribution = [
    ['SNS', 30],
    ['게임', 25],
    ['C', 20],
    ['D', 15],
    ['E', 10],
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: kIsWeb ? 20 : 20.h),
          // 7일간 사용 트렌트
          SevenDaysUsageTrends(),

          SizedBox(height: kIsWeb ? 20 : 20.h),

          // 시간대별 사용 패턴
          UsagePatternsByTimeOfDay(
            //timeOfDayPatternSummary: _timeOfDayPatternSummary,
            datas: _timeOfDayPatternDatas,
            timeOfDayPatternPeakTime: _timeOfDayPatternPeakTime,
          ),

          SizedBox(height: kIsWeb ? 20 : 20.h),

          // Top3 앱 사용 트렌드
          Top3AppUsageTrends(
            //top3AppSummary: _top3AppSummary,
            datas: _top3AppDatas,
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
