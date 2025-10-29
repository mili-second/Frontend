import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

class SevenDaysUsageTrends extends StatefulWidget {
  final List<double> datas; // 지난 7일 데이터 (월~일 순서로 들어옴)
  final double todayData; // 오늘 데이터

  const SevenDaysUsageTrends({
    super.key, 
    required this.datas,
    required this.todayData,
  });

  @override
  State<SevenDaysUsageTrends> createState() => _SevenDaysUsageTrendsState();
}

class _SevenDaysUsageTrendsState extends State<SevenDaysUsageTrends> {
  // 분을 시간으로 변환
  double minutesToHours(double minutes) {
    return minutes / 60.0;
  }

  // 오늘 요일의 인덱스 (월=0, 일=6)
  int get todayWeekdayIndex => DateTime.now().weekday - 1;

  // 요일 라벨 (오늘 요일이 맨 오른쪽)
  List<String> get dayLabels {
    final dayNames = ['월', '화', '수', '목', '금', '토', '일'];
    final result = <String>[];
    
    // 내일부터 오늘까지 (7일 순환)
    for (int i = 0; i < 7; i++) {
      // (오늘+1) % 7 부터 시작해서 오늘까지
      final index = (todayWeekdayIndex + 1 + i) % 7;
      result.add(dayNames[index]);
    }
    
    return result;
  }

 // 데이터 재배열
  List<double> get reorderedDatasInHours {
    if (widget.datas.isEmpty || widget.datas.length < 7) {
      return List.filled(7, 0.0);
    }
    
    // widget.datas = [어제, 그저께, ..., 저번주 같은 요일] (최신→과거)
    // 1단계: 역순으로 변환 (과거→최신)
    final reversed = <double>[];
    for (int i = 6; i >= 0; i--) {
      reversed.add(minutesToHours(widget.datas[i]));
    }
    
    // 2단계: 저번주 다음날이 맨 왼쪽에 오도록 회전
    final startIndex = (todayWeekdayIndex + 1) % 7; // (2+1) % 7 = 3
    
    final rotated = <double>[];
    for (int i = 0; i < 7; i++) {
      rotated.add(reversed[(startIndex + i) % 7]);
    }
    
    return rotated;
  }

  @override
  Widget build(BuildContext context) {
    final displayData = reorderedDatasInHours;
    final labels = dayLabels;
    final todayDataInHours = minutesToHours(widget.todayData);

    return Stack(
      children: [
        Container(
          width: kIsWeb ? 362 : 362.w,
          height: kIsWeb ? 250 : 250.h,
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
            border: Border.all(
              color: Color(0xFFCDCBCB),
              width: kIsWeb ? 1 : 1.w,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: kIsWeb ? 12 : 12.h,
              left: kIsWeb ? 20 : 20.w,
              right: kIsWeb ? 20 : 20.w,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/7daysUsingIcon.png',
                      width: kIsWeb ? 30 : 30.w,
                      height: kIsWeb ? 30 : 30.h,
                    ),
                    SizedBox(width: kIsWeb ? 10 : 10.w),
                    Text(
                      '7일간 사용 트렌드',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: kIsWeb ? 17 : 17.r,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kIsWeb ? 15 : 15.h),
                Row(
                  children: [
                    // 그래프
                    Padding(
                      padding: EdgeInsets.only(left: kIsWeb ? 20.0 : 20.0.h),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Container(
                              width: kIsWeb ? 280 : 280.w,
                              height: kIsWeb ? 1.5 : 1.5.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                          Positioned(
                            top: kIsWeb ? 140 : 140.h,
                            child: Container(
                              width: kIsWeb ? 280 : 280.w,
                              height: kIsWeb ? 1.5 : 1.5.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: kIsWeb ? 280 : 280.w,
                            height: kIsWeb ? 142 : 142.h,
                            child: LineChart(
                              LineChartData(
                                minY: 0,
                                maxY: 24,
                                clipData: FlClipData.none(),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 6,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    strokeWidth: 1,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineBarsData: [
                                  // 7일 데이터 (회색 선)
                                  LineChartBarData(
                                    spots: displayData.asMap().entries.map((e) {
                                      return FlSpot(e.key.toDouble(), e.value);
                                    }).toList(),
                                    isCurved: true,
                                    color: Color(0xFF524E4E).withValues(alpha: 0.5),
                                    barWidth: 2,
                                    isStrokeCapRound: false,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          color: Color(0xFF000000).withValues(alpha: 0.5),
                                          radius: 3,
                                          strokeWidth: 4,
                                          strokeColor: Color(0xFFD9D9D9).withValues(alpha: 0.4),
                                        );
                                      },
                                    ),
                                  ),
                                  // 오늘 데이터 (파란색 점만)
                                  LineChartBarData(
                                    spots: [
                                      FlSpot(6.0, todayDataInHours),
                                    ],
                                    isCurved: false,
                                    color: Colors.transparent,
                                    barWidth: 0,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          color: Color(0xFF2F83F7),
                                          radius: 5,
                                          strokeWidth: 6,
                                          strokeColor: Color(0xFFD9D9D9).withValues(alpha: 0.4),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
        ),
        Positioned(
          top: kIsWeb ? 200 : 200.h,
          left: kIsWeb ? 35 : 35.w,
          child: SizedBox(
            width: kIsWeb ? 290 : 290.w,
            height: kIsWeb ? 50 : 50.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final isToday = index == 6; // 마지막이 저번주 같은 요일
                return Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
                    color: isToday ? Color(0xFF2F83F7) : Color(0xFF000000),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
