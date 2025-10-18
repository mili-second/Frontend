import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatternAnalysisByDayOfTheWeek extends StatelessWidget {
  final String comment;

  const PatternAnalysisByDayOfTheWeek({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362.w,
      height: 440.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(0xFFA2A2A2), width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: 12.h,
          left: 20.w,
          right: 20.w,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/chalendar.png',
                  width: 45.w,
                  height: 45.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  '요일별 패턴 분석',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 17.r,
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
                comment,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 15.r,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 10.h),

            DayOfTheWeek(day: '월요일', dayImage: 'monday_lazy'),

            SizedBox(height: 15.h),

            DayOfTheWeek(day: '화요일', dayImage: 'tuesday_flower'),

            SizedBox(height: 15.h),

            DayOfTheWeek(day: '수요일', dayImage: 'wednesday_fighting'),

            SizedBox(height: 15.h),

            DayOfTheWeek(day: '목요일', dayImage: 'thursday_letsgo'),

            SizedBox(height: 15.h),

            DayOfTheWeek(day: '금요일', dayImage: 'friday_fire'),

            SizedBox(height: 15.h),

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
      width: 280.w,
      height: 30.h,
      child: Row(
        children: [
          Text(
            day,
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 16.r,
              fontWeight: FontWeight.w700,
            ),
          ),

          if (day == '주말') SizedBox(width: 25.w) else SizedBox(width: 10.w),

          Image.asset(
            'assets/icons/${dayImage}.png',
            width: 25.w,
            height: 25.h,
          ),

          SizedBox(width: 10.w),

          Stack(
            children: [
              Image.asset(
                'assets/icons/speechBubble.png',
                width: 181.w,
                height: 40.h,
              ),
              Positioned(
                top: 4.h,
                left: 30.w,
                child: Text(
                  '늦잠 +  SNS 몰아보기',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 13.r,
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
