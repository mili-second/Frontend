import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

class SevenDaysUsageTrends extends StatefulWidget {
  final List<double> datas;
  const SevenDaysUsageTrends({super.key, required this.datas});

  @override
  State<SevenDaysUsageTrends> createState() => _SevenDaysUsageTrendsState();
}

class _SevenDaysUsageTrendsState extends State<SevenDaysUsageTrends> {
  // Monday=1, Sunday=7 인데, 0~6 범위로 변환 (월=0, 일=6)
  final todayIndex = DateTime.now().weekday - 1;

  @override
  Widget build(BuildContext context) {
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
                                  LineChartBarData(
                                    spots: widget.datas.asMap().entries.map((
                                      e,
                                    ) {
                                      final index = e.key;
                                      final value = e.value;
                                      return FlSpot(index.toDouble(), value);
                                    }).toList(),
                                    isCurved: true,
                                    color: Color(
                                      0xFF524E4E,
                                    ).withValues(alpha: 0.5),
                                    barWidth: 2,
                                    isStrokeCapRound: false,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                            if (index == todayIndex) {
                                              return FlDotCirclePainter(
                                                color: Color(0xFF2F83F7),
                                                radius: 4,
                                                strokeWidth: 4,
                                                strokeColor: Color(
                                                  0xFFD9D9D9,
                                                ).withValues(alpha: 0.4),
                                              );
                                            } else {
                                              return FlDotCirclePainter(
                                                color: Color(
                                                  0xFF000000,
                                                ).withValues(alpha: 0.5),
                                                radius: 3,
                                                strokeWidth: 4,
                                                strokeColor: Color(
                                                  0xFFD9D9D9,
                                                ).withValues(alpha: 0.4),
                                              );
                                            }
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
                //SizedBox(height: 12.h),

                // SizedBox(
                //   width: 310.w,
                //   child: Text(
                //     widget.sevendaysUsingSummary.replaceAllMapped(
                //       RegExp(r'([.!?])\s*'), // . 또는 ! 또는 ? 뒤의 공백까지 매칭
                //       (match) => '${match[1]}\n', // 그 기호 뒤에 줄바꿈 추가
                //     ),
                //     style: TextStyle(
                //       color: Color(0xFF000000),
                //       fontSize: 15.r,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
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
                final dayLabels = ['월', '화', '수', '목', '금', '토', '일'];
                final isToday = index == todayIndex;
                return Text(
                  dayLabels[index],
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
