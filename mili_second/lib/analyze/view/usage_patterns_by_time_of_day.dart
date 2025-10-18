import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';

class UsagePatternsByTimeOfDay extends StatefulWidget {
  //final String timeOfDayPatternSummary;
  final List<List<int>> datas;
  final String timeOfDayPatternPeakTime;

  const UsagePatternsByTimeOfDay({
    super.key,
    //required this.timeOfDayPatternSummary,
    required this.timeOfDayPatternPeakTime,
    required this.datas,
  });

  @override
  State<UsagePatternsByTimeOfDay> createState() =>
      _UsagePatternsByTimeOfDayState();
}

class _UsagePatternsByTimeOfDayState extends State<UsagePatternsByTimeOfDay> {
  // 60 이상일 때, 시간 단위로 바꾸기 + String 타입의 ' 분' , ' 시간' 추가하기
  String formatMinutes(int minutes) {
    if (minutes < 60) {
      return '${minutes} 분';
    } else {
      double hours = minutes / 60;
      if (hours == hours.roundToDouble()) {
        return "${hours.toInt()}시간"; // 정수면 소수점 제거
      }
      return "${hours.toStringAsFixed(1)}시간";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 240 : 240.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
        border: Border.all(color: Color(0xFFCDCBCB), width: kIsWeb ? 1 : 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: kIsWeb ? 5 : 5.h,
          bottom: kIsWeb ? 5 : 5.h,
          left: kIsWeb ? 10 : 10.w,
          right: kIsWeb ? 5 : 5.w,
        ),
        child: Column(
          children: [
            SizedBox(
              width: kIsWeb ? 355 : 355.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // back으로 넘길게 있으면 해당 버튼 아이콘이 보이게, 없으면 SizedBox로 빈칸
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/icons/arrow_back_gray.png',
                      width: kIsWeb ? 25 : 25.w,
                      height: kIsWeb ? 25 : 25.h,
                    ),
                  ),
                  SizedBox(width: kIsWeb ? 40 : 40.w),
                  Text(
                    '시간대별 사용 패턴',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: kIsWeb ? 17 : 17.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: kIsWeb ? 45 : 45.w),
                  // front로 넘길게 있으면 해당 버튼 아이콘이 보이게, 없으면 SizedBox로 빈칸
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/icons/arrow_front_gray.png',
                      width: kIsWeb ? 25 : 25.w,
                      height: kIsWeb ? 25 : 25.h,
                    ),
                  ),
                  SizedBox(width: kIsWeb ? 10 : 10.w),
                ],
              ),
            ),
            SizedBox(height: kIsWeb ? 10 : 10.w),
            SizedBox(
              width: kIsWeb ? 355 : 355.w,
              height: kIsWeb ? 110 : 110.h,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: kIsWeb ? 2 : 2.h),
                      Image.asset(
                        'assets/icons/night.png',
                        width: kIsWeb ? 40 : 40.w,
                        height: kIsWeb ? 41 : 41.h,
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      Text(
                        '야간 (24-06시)',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 12 : 12.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      // 현재 핸드폰 사용 시간일 경우 다른 색상으로 표현하기
                      Text(
                        '0 분',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 16 : 16.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: kIsWeb ? 8 : 8.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/morning.png',
                        width: kIsWeb ? 44 : 44.w,
                        height: kIsWeb ? 44 : 44.h,
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      Text(
                        '오전 (6-12시)',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 12 : 12.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      // 현재 핸드폰 사용 시간일 경우 다른 색상으로 표현하기
                      Text(
                        '2시간',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 16 : 16.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: kIsWeb ? 8 : 8.w),
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/lunch.png',
                        width: kIsWeb ? 44 : 44.w,
                        height: kIsWeb ? 44 : 44.h,
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      Text(
                        '오후 (12-18시)',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 12 : 12.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      // 현재 핸드폰 사용 시간일 경우 다른 색상으로 표현하기
                      Text(
                        '1.2시간',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 16 : 16.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: kIsWeb ? 8 : 8.w),
                  Column(
                    children: [
                      SizedBox(height: kIsWeb ? 1.5 : 1.5.h),
                      Image.asset(
                        'assets/icons/evening.png',
                        width: kIsWeb ? 42 : 42.w,
                        height: kIsWeb ? 43 : 43.h,
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      Text(
                        '저녁 (18-24시)',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 12 : 12.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      Text(
                        '4.5시간',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 16 : 16.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //SizedBox(height: 5.h),

            // SizedBox(
            //   height: 50.h,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       SizedBox(width: 30.w),
            //       Text(
            //         textAlign: TextAlign.center,
            //         widget.timeOfDayPatternSummary.replaceAllMapped(
            //           RegExp(r'([.!?])\s*'), // . 또는 ! 또는 ? 뒤의 공백까지 매칭
            //           (match) => '${match[1]}\n', // 그 기호 뒤에 줄바꿈 추가
            //         ),
            //         style: TextStyle(
            //           color: Color(0xFF000000),
            //           fontSize: 15.r,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: kIsWeb ? 10 : 10.h),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/top3MainIcon.png',
                    width: kIsWeb ? 20 : 20.w,
                    height: kIsWeb ? 20 : 20.w,
                  ),
                  Text(
                    ' 가장 활발한 시간 : ',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: kIsWeb ? 15 : 15.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.timeOfDayPatternPeakTime,
                    style: TextStyle(
                      color: Color(0xFFF23C14),
                      fontSize: kIsWeb ? 17 : 17.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: kIsWeb ? 10 : 10.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
