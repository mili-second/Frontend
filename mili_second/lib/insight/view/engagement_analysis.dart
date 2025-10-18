import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';

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
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 237 : 237.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
        border: Border.all(color: Color(0xFFC8C8C8), width: kIsWeb ? 1 : 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: kIsWeb ? 15 : 15.h,
          bottom: kIsWeb ? 8 : 8.h,
          left: kIsWeb ? 20 : 20.w,
          right: kIsWeb ? 20 : 20.w,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/socialMedia.png',
                  width: kIsWeb ? 44 : 44.w,
                  height: kIsWeb ? 44 : 44.h,
                ),

                SizedBox(width: kIsWeb ? 10 : 10.w),

                Text(
                  'SNS 몰입도 분석',
                  style: TextStyle(
                    color: Color(0xFF0090FF),
                    fontSize: kIsWeb ? 17 : 17.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            SizedBox(height: kIsWeb ? 5 : 5.h),

            SizedBox(
              width: kIsWeb ? 280 : 280.w,
              height: kIsWeb ? 60 : 60.h,
              child: Text(
                comment.replaceAllMapped(
                  RegExp(r'([.!?])\s*'), // . 또는 ! 또는 ? 뒤의 공백까지 매칭
                  (match) => '${match[1]}\n', // 그 기호 뒤에 줄바꿈 추가
                ),
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: kIsWeb ? 15 : 15.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Stack(
              children: [
                Container(
                  width: kIsWeb ? 334 : 334.w,
                  height: kIsWeb ? 95 : 95.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFE0F0FF),
                    borderRadius: BorderRadius.circular(kIsWeb ? 14 : 14.r),
                  ),
                ),
                Positioned(
                  top: kIsWeb ? 12.5 : 12.5.h,
                  left: kIsWeb ? 166 : 166.w,
                  child: Container(
                    width: kIsWeb ? 1 : 1.w,
                    height: kIsWeb ? 70 : 70.h,
                    decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
                  ),
                ),
                Positioned(
                  top: kIsWeb ? 15 : 15.h,
                  left: kIsWeb ? 25 : 25.w,
                  child: Column(
                    children: [
                      Text(
                        '주간 평균 SNS시간',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 16 : 16.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      Text(
                        '${SNSTime}분',
                        style: TextStyle(
                          color: Color(0xFF0080FF),
                          fontSize: kIsWeb ? 20 : 20.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: kIsWeb ? 15 : 15.h,
                  left: kIsWeb ? 185 : 185.w,
                  child: Column(
                    children: [
                      Text(
                        '새벽 시간 접속률',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 16 : 16.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      Text(
                        '${rate}%',
                        style: TextStyle(
                          color: Color(0xFFFFBB00),
                          fontSize: kIsWeb ? 20 : 20.r,
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
