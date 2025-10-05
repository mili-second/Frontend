import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/insight/view/special_this_weeks.dart';
import '/insight/view/engagement_analysis.dart';
import '/insight/view/pattern_analysis_by_day_of_the_week.dart';

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
          Container(
            width: 362.w,
            height: 304.h,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Color(0xFFA2A2A2), width: 1.w),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/weeklyChangeGraph.png',
                        width: 42.w,
                        height: 42.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '주간 변화 트렌드',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    width: 310.w,
                    height: 1.h,
                    decoration: BoxDecoration(color: Color(0xFFBEBEBE)),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: 280.w,
                    child: Text(
                      _weeklyChangingTrendsComment.replaceAllMapped(
                        RegExp(r'([.!?])\s*'), // . 또는 ! 또는 ? 뒤의 공백까지 매칭
                        (match) => '${match[1]}\n', // 그 기호 뒤에 줄바꿈 추가
                      ),
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
