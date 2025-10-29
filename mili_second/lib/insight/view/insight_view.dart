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
  bool _isLoadingSpecial = true;

  Future<void> _loadSpecialThisWeeksComment() async {
    setState(() {
      _isLoadingSpecial = true;
    });

    final summary = await _specialThisWeeksViewModel.fetchSpecialThisWeek();
    if (mounted && summary != null) { // ✨ mounted 체크 추가
      setState(() {
        _specialThisWeeksComment = summary;
        _isLoadingSpecial = false;
      });
    } else {
      if (mounted) {
        setState(() {
          _isLoadingSpecial = false;
        });
      }
      print("요약 데이터를 가져오지 못했습니다.");
    }
  }

  // SNS 몰입도 분석 데이터
  final EngagementAnalysisViewModel _engagementAnalysisViewModel =
      EngagementAnalysisViewModel();
  int snsUsageRate = 0;
  int dawnAccessRate = 0;
  bool _isLoadingEngagement = true;

  Future<void> _loadEngagementAnalysis() async {
    setState(() {
      _isLoadingEngagement = true;
    });

    final result = await _engagementAnalysisViewModel.fetchUsageInsight();
    if (mounted && result != null) { // ✨ mounted 체크 추가
      setState(() {
        snsUsageRate = result.snsUsageRate;
        dawnAccessRate = result.dawnAccessRate;
        _isLoadingEngagement = false;
      });
    } else {
      if (mounted) {
        setState(() {
          _isLoadingEngagement = false;
        });
      }
    }
  }

  // 요일별 패턴 분석 데이터
  final BehaviorPatternsViewModel _behaviorPatternsViewModel = BehaviorPatternsViewModel();
  final ContentPreferenceViewModel _contentPreferenceViewModel = ContentPreferenceViewModel();

  // ✨ State 변수: 최종 합쳐진 코멘트 리스트
  List<DailyPatternComment> _combinedPatternComments = [];
  bool _isLoadingPatterns = true;

  Future<void> _loadBehaviorPatterns() async {
    setState(() {
      _isLoadingPatterns = true;
    });

    // 1. Fetch data (same as before)
    final behavior_data = await _behaviorPatternsViewModel.fetchBehaviorPatterns();
    final content_data = await _contentPreferenceViewModel.fetchContentPreference();

    if (behavior_data.isEmpty && content_data.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoadingPatterns = false;
        });
      }
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
        _isLoadingPatterns = false;
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

          // 이번주 특이사항
          _isLoadingSpecial
              ? Container(
                  width: kIsWeb ? 362 : 362.w,
                  height: kIsWeb ? 150 : 150.h,
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
              : SpecialThisWeeks(comment: _specialThisWeeksComment),

          SizedBox(height: kIsWeb ? 20 : 20.h),

          // SNS 몰입도 분석
          _isLoadingEngagement
              ? Container(
                  width: kIsWeb ? 362 : 362.w,
                  height: kIsWeb ? 180 : 180.h,
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
              : EngagementAnalysis(
                  snsUsageRate: snsUsageRate,
                  dawnAccessRate: dawnAccessRate,
                ),

          SizedBox(height: kIsWeb ? 20 : 20.h),

          // 요일별 패턴 분석
          _isLoadingPatterns
              ? Container(
                  width: kIsWeb ? 362 : 362.w,
                  height: kIsWeb ? 400 : 400.h,
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
              : PatternAnalysisByDayOfTheWeek(
                  patterns: _combinedPatternComments,
                ),

          SizedBox(height: kIsWeb ? 20 : 20.h),

          // 주간 변화 트렌드
          _isLoadingTrends
              ? Container(
                  width: kIsWeb ? 362 : 362.w,
                  height: kIsWeb ? 300 : 300.h,
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
              : WeeklyChangingTrends(
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