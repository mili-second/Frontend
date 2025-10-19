import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';

class WeeklyChangingTrends extends StatelessWidget {
  final String comment;
  final String totalUsageTime;
  final List<List> categoryUsageTime;

  const WeeklyChangingTrends({
    super.key,
    required this.comment,
    required this.totalUsageTime,
    required this.categoryUsageTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 340 : 340.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
        border: Border.all(color: Color(0xFFA2A2A2), width: kIsWeb ? 1 : 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: kIsWeb ? 15 : 15.h,
          left: kIsWeb ? 20 : 20.w,
          right: kIsWeb ? 20 : 20.w,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/weeklyChangeGraph.png',
                  width: kIsWeb ? 42 : 42.w,
                  height: kIsWeb ? 42 : 42.h,
                ),
                SizedBox(width: kIsWeb ? 10 : 10.w),
                Text(
                  '주간 변화 트렌드',
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
              height: kIsWeb ? 60 : 60.h,
              child: Text(
                comment.replaceAllMapped(
                  RegExp(r'([.!?])\s*'), // . 또는 ! 또는 ? 뒤의 공백까지 매칭
                  (match) => '${match[1]}\n', // 그 기호 뒤에 줄바꿈 추가
                ),
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: kIsWeb ? 15 : 15.r,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(
              width: kIsWeb ? 240 : 240.w,
              height: kIsWeb ? 70 : 70.h,
              child: Row(
                children: [
                  Text(
                    '총 사용 시간',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: kIsWeb ? 20 : 20.r,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: kIsWeb ? 20 : 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '+2.3 시간',
                        style: TextStyle(
                          color: Color(0xFFFF6565),
                          fontSize: kIsWeb ? 24 : 24.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      Text(
                        '(전주 대비)',
                        style: TextStyle(
                          color: Color(0xFFFF6565),
                          fontSize: kIsWeb ? 15 : 15.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: kIsWeb ? 10 : 10.h),
            Stack(
              children: [
                Container(
                  width: kIsWeb ? 300 : 300,
                  height: kIsWeb ? 100 : 100.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
                  ),
                ),
                Positioned(
                  top: kIsWeb ? 5 : 5.h,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: kIsWeb ? 8.0 : 8.0.h,
                      left: kIsWeb ? 15 : 20.w,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: kIsWeb ? 80 : 80.w,
                          height: kIsWeb ? 72 : 72.h,
                          child: Column(
                            children: [
                              Text(
                                categoryUsageTime[0][0],
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: kIsWeb ? 17 : 17.r,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: kIsWeb ? 10 : 10.h),
                              Text(
                                categoryUsageTime[0][1],
                                style: TextStyle(
                                  color: Color(0xFFFF8551),
                                  fontSize: kIsWeb ? 24 : 24.r,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: kIsWeb ? 20 : 20.w),
                        SizedBox(
                          width: kIsWeb ? 80 : 80.w,
                          height: kIsWeb ? 72 : 72.h,
                          child: Column(
                            children: [
                              Text(
                                categoryUsageTime[1][0],
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: kIsWeb ? 17 : 17.r,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: kIsWeb ? 10 : 10.h),
                              Text(
                                categoryUsageTime[1][1],
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: kIsWeb ? 24 : 24.r,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: kIsWeb ? 20 : 20.w),
                        SizedBox(
                          width: kIsWeb ? 80 : 80.w,
                          height: kIsWeb ? 72 : 72.h,
                          child: Column(
                            children: [
                              Text(
                                categoryUsageTime[2][0],
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: kIsWeb ? 17 : 17.r,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: kIsWeb ? 10 : 10.h),
                              Text(
                                categoryUsageTime[2][1],
                                style: TextStyle(
                                  color: Color(0xFF51B4FF),
                                  fontSize: kIsWeb ? 24 : 24.r,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
