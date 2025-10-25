import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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
  int _currentIndex = 0; // 0: 오늘, 1: 오늘-1, 2: 오늘-2

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

  List<int> getSafeDataForCurrentIndex(int index) {
    // 범위 내에 있으면 해당 데이터 반환, 없으면 기본 값 [0, 0, 0, 0] 반환
    if (index >= 0 && index < widget.datas.length) {
      return widget.datas[index];
    }
    return [0, 0, 0, 0]; // 범위를 벗어나면 기본 값으로 처리
  }

  @override
  Widget build(BuildContext context) {
    // 현재 시간이 어느 구간에 속하는지 계산
    final now = DateTime.now();
    final currentHour = int.parse(DateFormat('HH').format(now));

    String currentPeriod;
    if (currentHour >= 0 && currentHour < 6) {
      currentPeriod = 'night';
    } else if (currentHour >= 6 && currentHour < 12) {
      currentPeriod = 'morning';
    } else if (currentHour >= 12 && currentHour < 18) {
      currentPeriod = 'lunch';
    } else {
      currentPeriod = 'evening';
    }

    Color getTextColor(String period) {
      // 현재 시간대면 강조색, 아니면 기본색
      return currentPeriod == period
          ? const Color(0xFF2F83F7)
          : const Color(0xFF000000);
    }

    // 현재 인덱스의 데이터를 안전하게 가져오기
    List<int> currentData = getSafeDataForCurrentIndex(_currentIndex);

    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 230 : 230.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
        border: Border.all(color: Color(0xFFCDCBCB), width: kIsWeb ? 1 : 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: kIsWeb ? 5 : 5.h,
          bottom: kIsWeb ? 5 : 5.h,
          left: kIsWeb ? 15 : 10.w,
          right: kIsWeb ? 5 : 5.w,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: kIsWeb ? 362 : 362.w,
                  height: kIsWeb ? 45 : 45.h,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: kIsWeb ? 8 : 8.h,
                      left: kIsWeb ? 95.0 : 95.w,
                    ),
                    child: Text(
                      '시간대별 사용 패턴',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: kIsWeb ? 17 : 17.r,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // back으로 넘길게 있으면 해당 버튼 아이콘이 보이게, 없으면 SizedBox로 빈칸
                Positioned(
                  left: kIsWeb ? 10 : 10.w,
                  child: _currentIndex < widget.datas.length - 1
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex++;
                            });
                          },
                          icon: Image.asset(
                            'assets/icons/arrow_back_gray.png',
                            width: kIsWeb ? 25 : 25.w,
                            height: kIsWeb ? 25 : 25.h,
                          ),
                        )
                      : SizedBox(width: kIsWeb ? 25 : 25.w),
                ),
                // front로 넘길게 있으면 해당 버튼 아이콘이 보이게, 없으면 SizedBox로 빈칸
                Positioned(
                  left: kIsWeb ? 280 : 280.w,
                  child: _currentIndex > 0
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex--;
                            });
                          },
                          icon: Image.asset(
                            'assets/icons/arrow_front_gray.png',
                            width: kIsWeb ? 25 : 25.w,
                            height: kIsWeb ? 25 : 25.h,
                          ),
                        )
                      : SizedBox(width: kIsWeb ? 25 : 25.w),
                ),
              ],
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
                          color: getTextColor('night'),
                          fontSize: kIsWeb ? 12 : 12.r,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      // 현재 핸드폰 사용 시간일 경우 다른 색상으로 표현하기
                      Text(
                        formatMinutes(currentData[0]),
                        style: TextStyle(
                          color: getTextColor('night'),
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
                          color: getTextColor('morning'),
                          fontSize: kIsWeb ? 12 : 12.r,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      // 현재 핸드폰 사용 시간일 경우 다른 색상으로 표현하기
                      Text(
                        formatMinutes(currentData[1]),
                        style: TextStyle(
                          color: getTextColor('morning'),
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
                          color: getTextColor('lunch'),
                          fontSize: kIsWeb ? 12 : 12.r,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      // 현재 핸드폰 사용 시간일 경우 다른 색상으로 표현하기
                      Text(
                        formatMinutes(currentData[2]),
                        style: TextStyle(
                          color: getTextColor('lunch'),
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
                          color: getTextColor('evening'),
                          fontSize: kIsWeb ? 12 : 12.r,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 5 : 5.h),
                      Text(
                        formatMinutes(currentData[3]),
                        style: TextStyle(
                          color: getTextColor('evening'),
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
                  _currentIndex == 0
                      ? Text(
                          ' 오늘 가장 활발한 시간 : ',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: kIsWeb ? 15 : 15.r,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : _currentIndex == 1
                      ? Text(
                          ' 1일전 가장 활발한 시간 : ',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: kIsWeb ? 15 : 15.r,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : Text(
                          ' 2일전 활발한 시간 : ',
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
