import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';

class PatternAnalysisByDayOfTheWeek extends StatelessWidget {
  final String comment;

  const PatternAnalysisByDayOfTheWeek({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 440 : 440.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
        border: Border.all(color: Color(0xFFA2A2A2), width: kIsWeb ? 1 : 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: kIsWeb ? 12 : 12.h,
          bottom: kIsWeb ? 12 : 12.h,
          left: kIsWeb ? 20 : 20.w,
          right: kIsWeb ? 20 : 20.w,
        ),
        child: Column(
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
                  '요일별 패턴 분석',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: kIsWeb ? 17 : 17.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: kIsWeb ? 5 : 5.h),
            Container(
              width: kIsWeb ? 310 : 310.w,
              height: kIsWeb ? 1 : 1.h,
              decoration: BoxDecoration(color: Color(0xFFBEBEBE)),
            ),
            SizedBox(height: kIsWeb ? 15 : 15.h),

            SizedBox(
              width: kIsWeb ? 280 : 280.w,
              child: Text(
                comment,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: kIsWeb ? 15 : 15.r,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: kIsWeb ? 10 : 10.h),

            DayOfTheWeek(day: '월요일', dayImage: 'monday_lazy'),

            SizedBox(height: kIsWeb ? 15 : 15.h),

            DayOfTheWeek(day: '화요일', dayImage: 'tuesday_flower'),

            SizedBox(height: kIsWeb ? 15 : 15.h),

            DayOfTheWeek(day: '수요일', dayImage: 'wednesday_fighting'),

            SizedBox(height: kIsWeb ? 15 : 15.h),

            DayOfTheWeek(day: '목요일', dayImage: 'thursday_letsgo'),

            SizedBox(height: kIsWeb ? 15 : 15.h),

            DayOfTheWeek(day: '금요일', dayImage: 'friday_fire'),

            SizedBox(height: kIsWeb ? 15 : 15.h),

            DayOfTheWeek(day: '주말', dayImage: 'weekend_home'),
          ],
        ),
      ),
    );
  }
}

class DayOfTheWeek extends StatelessWidget {
  final String day;
  final String dayImage;
  const DayOfTheWeek({super.key, required this.day, required this.dayImage});

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

          if (day == '주말')
            SizedBox(width: kIsWeb ? 25 : 25.w)
          else
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
                  '늦잠 +  SNS 몰아보기',
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
