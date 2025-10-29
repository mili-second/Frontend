import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:milli_second/insight/model/pattern_analysis_by_day_of_the_week_model.dart';
import 'package:milli_second/insight/model/daily_pattern_comment.dart';

// class PatternAnalysisByDayOfTheWeek extends StatelessWidget {
//   final List<String> comment;

//   const PatternAnalysisByDayOfTheWeek({super.key, required this.comment});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: kIsWeb ? 362 : 362.w,
//       height: kIsWeb ? 440 : 440.h,
//       decoration: BoxDecoration(
//         color: Color(0xFFFFFFFF),
//         borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
//         border: Border.all(color: Color(0xFFA2A2A2), width: kIsWeb ? 1 : 1.w),
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(
//           top: kIsWeb ? 12 : 12.h,
//           bottom: kIsWeb ? 12 : 12.h,
//           left: kIsWeb ? 20 : 20.w,
//           right: kIsWeb ? 20 : 20.w,
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Image.asset(
//                   'assets/icons/chalendar.png',
//                   width: kIsWeb ? 45 : 45.w,
//                   height: kIsWeb ? 45 : 45.h,
//                 ),
//                 SizedBox(width: kIsWeb ? 10 : 10.w),
//                 Text(
//                   '요일별 패턴 분석',
//                   style: TextStyle(
//                     color: Color(0xFF000000),
//                     fontSize: kIsWeb ? 17 : 17.r,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: kIsWeb ? 5 : 5.h),
//             Container(
//               width: kIsWeb ? 310 : 310.w,
//               height: kIsWeb ? 1 : 1.h,
//               decoration: BoxDecoration(color: Color(0xFFBEBEBE)),
//             ),
//             // SizedBox(height: kIsWeb ? 15 : 15.h),

//             // SizedBox(
//             //   width: kIsWeb ? 280 : 280.w,
//             //   child: Text(
//             //     comment,
//             //     style: TextStyle(
//             //       color: Color(0xFF000000),
//             //       fontSize: kIsWeb ? 15 : 15.r,
//             //       fontWeight: FontWeight.w500,
//             //     ),
//             //   ),
//             // ),
//             SizedBox(height: kIsWeb ? 10 : 10.h),

//             DayOfTheWeek(
//               day: '월요일',
//               dayImage: 'monday_lazy',
//               dayComment: comment[0],
//             ),

//             SizedBox(height: kIsWeb ? 15 : 15.h),

//             DayOfTheWeek(
//               day: '화요일',
//               dayImage: 'tuesday_flower',
//               dayComment: comment[1],
//             ),

//             SizedBox(height: kIsWeb ? 15 : 15.h),

//             DayOfTheWeek(
//               day: '수요일',
//               dayImage: 'wednesday_fighting',
//               dayComment: comment[2],
//             ),

//             SizedBox(height: kIsWeb ? 15 : 15.h),

//             DayOfTheWeek(
//               day: '목요일',
//               dayImage: 'thursday_letsgo',
//               dayComment: comment[3],
//             ),

//             SizedBox(height: kIsWeb ? 15 : 15.h),

//             DayOfTheWeek(
//               day: '금요일',
//               dayImage: 'friday_fire',
//               dayComment: comment[4],
//             ),

//             SizedBox(height: kIsWeb ? 15 : 15.h),

//             DayOfTheWeek(
//               day: '주말',
//               dayImage: 'weekend_home',
//               dayComment: comment[5],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class PatternAnalysisByDayOfTheWeek extends StatelessWidget {
  final List<DailyPatternComment> patterns;

  const PatternAnalysisByDayOfTheWeek({super.key, required this.patterns});

  @override
  Widget build(BuildContext context) {
    final weekDays = ["월", "화", "수", "목", "금", "토", "일"];

    String getWeekdayLabel(DateTime date) {
      final index = (date.weekday - 1).clamp(0, weekDays.length - 1);
      return weekDays[index];
    }

    return Container(
      width: kIsWeb ? 355 : 355.w,
      // height: kIsWeb ? 460 : 460.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
        border: Border.all(
          color: const Color(0xFFA2A2A2),
          width: kIsWeb ? 1 : 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(kIsWeb ? 20 : 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/chalendar.png',
                  width: kIsWeb ? 45 : 45.w,
                  height: kIsWeb ? 45 : 45.h,
                ),
                SizedBox(width: kIsWeb ? 10 : 10.w),
                Text(
                  '최근 7일 행동 패턴 \n(확인 빈도 / 분류 유형)',
                  style: TextStyle(
                    fontSize: kIsWeb ? 17 : 17.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: kIsWeb ? 10 : 10.h),
            Container(
              width: kIsWeb ? 330 : 330.w,
              height: kIsWeb ? 1 : 1.h,
              color: const Color(0xFFBEBEBE),
            ),
            SizedBox(height: kIsWeb ? 15 : 15.h),

            // 날짜별 동적 렌더링
            ListView.builder(
              // ✨ 3. shrinkWrap: true 추가 (내용물 크기만큼 높이 차지)
              shrinkWrap: true,
              // ✨ 4. physics: NeverScrollableScrollPhysics() 추가 (독립 스크롤 방지)
              physics: NeverScrollableScrollPhysics(),
              itemCount: patterns.length,
              itemBuilder: (context, index) {
                final pattern = patterns[index];
                final date = DateTime.parse(pattern.date);
                final weekday = weekDays[date.weekday - 1];
                final formattedDate = "${date.month}/${date.day} ($weekday)";

                // 이미지도 인덱스별로 다양하게 (랜덤 또는 요일 매핑)
                final dayImage = [
                  'monday_lazy',
                  'tuesday_flower',
                  'wednesday_fighting',
                  'thursday_letsgo',
                  'friday_fire',
                  'saturday_home',
                  'sunday_relax',
                ][date.weekday - 1];

                return Padding(
                  padding: EdgeInsets.only(bottom: kIsWeb ? 15 : 15.h),
                  child: DayOfTheWeek(
                    day: formattedDate,
                    dayImage: dayImage,
                    behaviorComment: pattern.behaviorComment,
                    contentComment: pattern.contentComment,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// insight/view/pattern_analysis_by_day_of_the_week.dart

class DayOfTheWeek extends StatelessWidget {
  final String day;
  final String dayImage;
  final String behaviorComment;
  final String contentComment;

  const DayOfTheWeek({
    super.key,
    required this.day,
    required this.dayImage,
    required this.behaviorComment,
    required this.contentComment,
  });

  @override
  Widget build(BuildContext context) {
    int lineCount = 0;
    if (behaviorComment.isNotEmpty) lineCount++;
    if (contentComment.isNotEmpty) lineCount++;
    double bubbleHeight = (lineCount > 1) ? (kIsWeb ? 54 : 54.h) : (kIsWeb ? 35 : 35.h); // 높이 조절
    double rowHeight = bubbleHeight;

    // 요일별 색상 결정 (토요일: 파란색, 일요일: 빨간색)
    Color dayColor = Color(0xFF000000); // 기본 검은색
    if (day.contains('토')) {
      dayColor = Color(0xFF2F83F7); // 파란색
    } else if (day.contains('일')) {
      dayColor = Color(0xFFFF6565); // 빨간색
    }

    return SizedBox(
      height: rowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: kIsWeb ? 110 : 110.w, // 날짜 너비
            child: Text(
              day,
              style: TextStyle(
                color: dayColor,
                fontSize: kIsWeb ? 16 : 16.r,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Image.asset(
            'assets/icons/${dayImage}.png',
            width: kIsWeb ? 25 : 25.w,
            height: kIsWeb ? 25 : 25.h,
          ),
          SizedBox(width: kIsWeb ? 10 : 10.w),
          Expanded( // Expanded 유지
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: bubbleHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/speechBubble.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    // ✨ 왼쪽 패딩 조절, 상하 패딩 유지 또는 조절
                    padding: EdgeInsets.only(
                      left: kIsWeb ? 30 : 30.w, // 말풍선 꼬리 부분 감안한 왼쪽 여백
                      right: kIsWeb ? 10 : 10.w, // 오른쪽 여백
                      top: kIsWeb ? 6 : 6.h, // 상하 위치 조절 (Center 제거 후 필요)
                      bottom: kIsWeb ? 6 : 6.h,
                    ),
                    // ✨ Center 위젯 제거
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Column 내용을 수직 중앙 정렬
                      crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬 (이미 설정됨)
                      children: [
                        if (behaviorComment.isNotEmpty)
                          Row(
                            children: [
                              Container(
                                width: kIsWeb ? 4 : 4.w,
                                height: kIsWeb ? 4 : 4.h,
                                decoration: BoxDecoration(
                                  color: Color(0xFF3A78EB), // 파란색 - 행동 패턴
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: kIsWeb ? 5 : 5.w),
                              Expanded(
                                child: Text(
                                  behaviorComment,
                                  style: TextStyle(
                                    color: Color(0xFF3A78EB), // 파란색
                                    fontSize: kIsWeb ? 13 : 13.r,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        if (lineCount > 1) SizedBox(height: kIsWeb ? 2 : 2.h),
                        if (contentComment.isNotEmpty)
                          Row(
                            children: [
                              Container(
                                width: kIsWeb ? 4 : 4.w,
                                height: kIsWeb ? 4 : 4.h,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF8551), // 주황색 - 콘텐츠 유형
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: kIsWeb ? 5 : 5.w),
                              Expanded(
                                child: Text(
                                  contentComment,
                                  style: TextStyle(
                                    color: Color(0xFFFF8551), // 주황색
                                    fontSize: kIsWeb ? 13 : 13.r,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}