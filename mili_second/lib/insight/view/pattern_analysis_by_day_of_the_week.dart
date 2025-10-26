import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:mili_second/insight/model/pattern_analysis_by_day_of_the_week_model.dart';

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
  final List<BehaviorPatternModel> patterns;

  const PatternAnalysisByDayOfTheWeek({super.key, required this.patterns});

  @override
  Widget build(BuildContext context) {
    final weekDays = ["월", "화", "수", "목", "금", "토", "일"];

    String getWeekdayLabel(DateTime date) {
      final index = (date.weekday - 1).clamp(0, weekDays.length - 1);
      return weekDays[index];
    }

    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 440 : 440.h,
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
                  '최근 7일 행동 패턴',
                  style: TextStyle(
                    fontSize: kIsWeb ? 17 : 17.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: kIsWeb ? 10 : 10.h),
            Container(
              width: kIsWeb ? 310 : 310.w,
              height: kIsWeb ? 1 : 1.h,
              color: const Color(0xFFBEBEBE),
            ),
            SizedBox(height: kIsWeb ? 15 : 15.h),

            // 날짜별 동적 렌더링
            Expanded(
              child: ListView.builder(
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
                      dayComment: pattern.behaviorPatternKo,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DayOfTheWeek extends StatelessWidget {
  final String day;
  final String dayImage;
  final String dayComment;
  const DayOfTheWeek({
    super.key,
    required this.day,
    required this.dayImage,
    required this.dayComment,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kIsWeb ? 280 : 280.w,
      height: kIsWeb ? 30 : 30.h,
      child: Row(
        children: [
          Text(
            day,
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: kIsWeb ? 16 : 16.r,
              fontWeight: FontWeight.w700,
            ),
          ),

          // if (day == '주말')
          //   SizedBox(width: kIsWeb ? 25 : 25.w)
          // else
          SizedBox(width: kIsWeb ? 10 : 10.w),

          Image.asset(
            'assets/icons/${dayImage}.png',
            width: kIsWeb ? 25 : 25.w,
            height: kIsWeb ? 25 : 25.h,
          ),

          SizedBox(width: kIsWeb ? 10 : 10.w),

          Stack(
            children: [
              Image.asset(
                'assets/icons/speechBubble.png',
                width: kIsWeb ? 181 : 181.w,
                height: kIsWeb ? 40 : 40.h,
              ),
              Positioned(
                top: kIsWeb ? 4 : 4.h,
                left: kIsWeb ? 30 : 30.w,
                child: Text(
                  dayComment,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: kIsWeb ? 13 : 13.r,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
