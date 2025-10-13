import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EngagementAnalysis extends StatelessWidget {
  final String comment;
  final int SNSTime;
  final int rate;

  const EngagementAnalysis({
    super.key,
    required this.comment,
    required this.SNSTime,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362.w,
      height: 237.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(0xFFC8C8C8), width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 15.h,
          bottom: 8.h,
          left: 20.w,
          right: 20.w,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/socialMedia.png',
                  width: 44.w,
                  height: 44.h,
                ),

                SizedBox(width: 10.w),

                Text(
                  'SNS 몰입도 분석',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            SizedBox(height: 5.h),

            SizedBox(
              width: 280.w,
              height: 60.h,
              child: Text(
                comment.replaceAllMapped(
                  RegExp(r'([.!?])\s*'), // . 또는 ! 또는 ? 뒤의 공백까지 매칭
                  (match) => '${match[1]}\n', // 그 기호 뒤에 줄바꿈 추가
                ),
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Stack(
              children: [
                Container(
                  width: 334.w,
                  height: 95.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFE0F0FF),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                Positioned(
                  top: 12.5.h,
                  left: 166.w,
                  child: Container(
                    width: 1.w,
                    height: 70.h,
                    decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
                  ),
                ),
                Positioned(
                  top: 15.h,
                  left: 25.w,
                  child: Column(
                    children: [
                      Text(
                        '주간 평균 SNS시간',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '${SNSTime}분',
                        style: TextStyle(
                          color: Color(0xFF0080FF),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 15.h,
                  left: 185.w,
                  child: Column(
                    children: [
                      Text(
                        '새벽 시간 접속률',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '${rate}%',
                        style: TextStyle(
                          color: Color(0xFFFFBB00),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
