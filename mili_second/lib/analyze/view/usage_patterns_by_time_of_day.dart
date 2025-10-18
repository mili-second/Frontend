import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      width: 362.w,
      height: 240.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(0xFFCDCBCB), width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 10.w, right: 5.w),
        child: Column(
          children: [
            SizedBox(
              width: 355.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // back으로 넘길게 있으면 해당 버튼 아이콘이 보이게, 없으면 SizedBox로 빈칸
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/icons/arrow_back_gray.png',
                      width: 25.w,
                      height: 25.h,
                    ),
                  ),
                  SizedBox(width: 40.w),
                  Text(
                    '시간대별 사용 패턴',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 17.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 45.w),
                  // front로 넘길게 있으면 해당 버튼 아이콘이 보이게, 없으면 SizedBox로 빈칸
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/icons/arrow_front_gray.png',
                      width: 25.w,
                      height: 25.h,
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
            SizedBox(height: 10.w),
            SizedBox(
              width: 355.w,
              height: 110.h,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Image.asset(
                        'assets/icons/night.png',
                        width: 40.w,
                        height: 41.h,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '야간 (24-06시)',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 12.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      // 현재 핸드폰 사용 시간일 경우 다른 색상으로 표현하기
                      Text(
                        '0 분',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/morning.png',
                        width: 44.w,
                        height: 44.h,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '오전 (6-12시)',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 12.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      // 현재 핸드폰 사용 시간일 경우 다른 색상으로 표현하기
                      Text(
                        '2시간',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/lunch.png',
                        width: 44.w,
                        height: 44.h,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '오후 (12-18시)',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 12.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      // 현재 핸드폰 사용 시간일 경우 다른 색상으로 표현하기
                      Text(
                        '1.2시간',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    children: [
                      SizedBox(height: 1.5.h),
                      Image.asset(
                        'assets/icons/evening.png',
                        width: 42.w,
                        height: 43.h,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '저녁 (18-24시)',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 12.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '4.5시간',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16.r,
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
            SizedBox(height: 10.h),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/top3MainIcon.png',
                    width: 20.w,
                    height: 20.w,
                  ),
                  Text(
                    ' 가장 활발한 시간 : ',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 15.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.timeOfDayPatternPeakTime,
                    style: TextStyle(
                      color: Color(0xFFF23C14),
                      fontSize: 17.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
