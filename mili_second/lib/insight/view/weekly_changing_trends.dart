import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeeklyChangingTrends extends StatelessWidget {
  final String comment;
  final String totalUsageTime;

  const WeeklyChangingTrends({
    super.key,
    required this.comment,
    required this.totalUsageTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                comment.replaceAllMapped(
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

            SizedBox(
              width: 240.w,
              child: Row(
                children: [
                  Text(
                    '총 사용 시간',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '+2.3 시간',
                        style: TextStyle(
                          color: Color(0xFFFF6565),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      Text(
                        '(전주 대비)',
                        style: TextStyle(
                          color: Color(0xFFFF6565),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Column(children: []),
                Column(children: []),
                Column(children: []),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
