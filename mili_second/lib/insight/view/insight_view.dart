import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import '/insight/view/special_this_weeks.dart';
import '/insight/view/engagement_analysis.dart';
import '/insight/view/pattern_analysis_by_day_of_the_week.dart';
import '/insight/view/weekly_changing_trends.dart';
import 'package:milli_second/insight/view_model/special_this_weeks_view_model.dart';
import 'package:milli_second/insight/model/daily_pattern_comment.dart';
import 'package:milli_second/insight/view_model/pattern_analysis_by_day_of_the_week_view_model.dart';
// BehaviorPatternModel, ContentPreferenceModel import는 ViewModel 안에서 처리될 것이므로 제거 가능
// import 'package:milli_second/insight/model/pattern_analysis_by_day_of_the_week_model.dart';
import 'package:milli_second/insight/view_model/engagement_analysis_view_model.dart';
import 'package:milli_second/insight/model/weekly_trends_model.dart';
import 'package:milli_second/insight/view_model/weekly_trends_view_model.dart';
import 'package:milli_second/insight/view_model/weekly_trends_view_model.dart';
import 'package:milli_second/utils/category_translator.dart';

class InsightView extends StatefulWidget {
  const InsightView({super.key});

  @override
  State<InsightView> createState() => _InsightViewState();
}

class _InsightViewState extends State<InsightView> {
  // 이번주 특이사항 데이터
  String _specialThisWeeksComment = '';
  final _specialThisWeeksViewModel = SpecialThisWeeksViewModel();

  Future<void> _loadSpecialThisWeeksComment() async {
    final summary = await _specialThisWeeksViewModel.fetchSpecialThisWeek();
    if (mounted && summary != null) { // ✨ mounted 체크 추가
      setState(() {
        _specialThisWeeksComment = summary;
      });
    } else {
      print("요약 데이터를 가져오지 못했습니다.");
    }
  }

  // SNS 몰입도 분석 데이터
  final EngagementAnalysisViewModel _engagementAnalysisViewModel =
      EngagementAnalysisViewModel();
  int snsUsageRate = 0;
  int dawnAccessRate = 0;

  Future<void> _loadEngagementAnalysis() async {
    final result = await _engagementAnalysisViewModel.fetchUsageInsight();
    if (mounted && result != null) { // ✨ mounted 체크 추가
      setState(() {
        snsUsageRate = result.snsUsageRate;
        dawnAccessRate = result.dawnAccessRate;
      });
    }
  }

  // 요일별 패턴 분석 데이터
  final BehaviorPatternsViewModel _behaviorPatternsViewModel = BehaviorPatternsViewModel();
  final ContentPreferenceViewModel _contentPreferenceViewModel = ContentPreferenceViewModel();

  // ✨ State 변수: 최종 합쳐진 코멘트 리스트
  List<DailyPatternComment> _combinedPatternComments = [];

  Future<void> _loadBehaviorPatterns() async {
    // 1. Fetch data (same as before)
    final behavior_data = await _behaviorPatternsViewModel.fetchBehaviorPatterns();
    final content_data = await _contentPreferenceViewModel.fetchContentPreference();

    if (behavior_data.isEmpty && content_data.isEmpty) {
      print("요일별 패턴 데이터를 가져오지 못했습니다.");
      return;
    }

    // 2. Sort data (same as before)
    behavior_data.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    content_data.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    // 3. Combine data (modified)
    Map<String, String> behaviorCommentsMap = { for (var item in behavior_data) item.date : item.behaviorPatternKo };
    Map<String, String> contentCommentsMap = { for (var item in content_data) item.date : item.contentPreferenceKo };
    Set<String> allDates = {...behavior_data.map((e) => e.date), ...content_data.map((e) => e.date)};
    List<String> sortedDates = allDates.toList();
    sortedDates.sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

    List<DailyPatternComment> combinedDataResult = [];
    for (String date in sortedDates) {
      String behaviorPart = behaviorCommentsMap[date] ?? ''; // Get behavior comment
      String contentPart = contentCommentsMap[date] ?? '';  // Get content comment

      // Add if at least one comment exists
      if (behaviorPart.isNotEmpty || contentPart.isNotEmpty) {
        combinedDataResult.add(DailyPatternComment(
          date: date,
          behaviorComment: behaviorPart, // Store separately
          contentComment: contentPart,   // Store separately
        ));
      }
    }

    // 4. Update state (same as before)
    if (mounted) {
      setState(() {
        _combinedPatternComments = combinedDataResult;
      });
    }
  }

  // 주간 변화 트렌드 데이터
  final WeeklyTrendsViewModel _weeklyTrendsViewModel = WeeklyTrendsViewModel();
  WeeklyTrendsModel? _weeklyTrendsData; // Nullable로 데이터 저장

  // 로딩 상태 변수 (선택 사항)
  bool _isLoadingTrends = true;

  Future<void> _loadWeeklyTrends() async {
    setState(() { _isLoadingTrends = true; }); // 로딩 시작
    final data = await _weeklyTrendsViewModel.fetchWeeklyTrends();
    if (mounted && data != null) {
      setState(() {
        _weeklyTrendsData = data;
        _isLoadingTrends = false; // 로딩 완료
      });
    } else {
       if (mounted) {
         setState(() { _isLoadingTrends = false; }); // 로딩 완료 (오류)
       }
       print("주간 트렌드 데이터를 가져오지 못했습니다.");
    }
  }

  // 주간 변화 트렌드 데이터 (하드코딩된 예시 유지)
  // final String _weeklyChangingTrendsComment =
  //     '새로운 관심사가 기존 패턴을 자연스럽게 변화시키고 있어요!';
  // final String _totalUsageTime = '+2.3 시간';
  // final List<List> _categoryAndChangeInUse = [
  //   ['SNS', '+ 150%'],
  //   ['독서', '- 60%'],
  //   ['게임', '+ 35%'],
  // ];

  // ✨ initState 하나로 합치기
  @override
  void initState() {
    super.initState();
    _loadSpecialThisWeeksComment();
    _loadBehaviorPatterns(); // 요일별 패턴 로딩 호출
    _loadEngagementAnalysis();
    _loadWeeklyTrends();
  }

  @override
  Widget build(BuildContext context) {
    String weeklyComment = _weeklyTrendsData?.baseDate != null
        ? '${_weeklyTrendsData!.baseDate} 기준 분석 결과입니다.' // 예시 코멘트
        : '데이터를 불러오는 중입니다...';
    String totalUsageTimeChange = _weeklyTrendsData?.totalUsageChange.totalUsageTimeString ?? '...'; 
    List<List<String>> categoryChanges = _weeklyTrendsData?.top3Categories.map((category) {
          String translatedName = translateCategory(category.categoryName); // 카테고리 이름 번역
          String changeRateStr = category.changeRateString; // 모델에서 계산된 값 사용
          return [translatedName, changeRateStr];
        }).toList() ?? [];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: kIsWeb ? 20 : 20.h),
          SpecialThisWeeks(comment: _specialThisWeeksComment),
          SizedBox(height: kIsWeb ? 20 : 20.h),
          EngagementAnalysis(
            snsUsageRate: snsUsageRate,
            dawnAccessRate: dawnAccessRate,
          ),
          SizedBox(height: kIsWeb ? 20 : 20.h),
          // ✨ PatternAnalysisByDayOfTheWeek 위젯에 수정된 데이터 전달
          PatternAnalysisByDayOfTheWeek(
            patterns: _combinedPatternComments, // List<DailyPatternComment> 전달
          ),
          SizedBox(height: kIsWeb ? 20 : 20.h),
          WeeklyChangingTrends(
            comment: weeklyComment,
            totalUsageTime: totalUsageTimeChange,
            categoryUsageTime: categoryChanges,
          ),
          SizedBox(height: kIsWeb ? 30 : 30.h),
        ],
      ),
    );
  }
}