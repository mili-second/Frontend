import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

class SevenDaysUsageTrends extends StatefulWidget {
  final List<double> datas;
  final List<String> dateLabels;
  const SevenDaysUsageTrends({
    super.key,
    required this.datas,
    required this.dateLabels,
  });

  @override
  State<SevenDaysUsageTrends> createState() => _SevenDaysUsageTrendsState();
}

class _SevenDaysUsageTrendsState extends State<SevenDaysUsageTrends> {
  // 오늘은 항상 마지막 인덱스 (6번째)
  final int todayIndex = 6;

  @override
  Widget build(BuildContext context) {
    // 데이터가 비어있는지 확인
    final bool hasData = widget.datas.isNotEmpty && widget.dateLabels.isNotEmpty;

    // Y축 최댓값 계산 (사용자의 실제 사용량에 맞게 동적 조정)
    double maxY = 24; // 기본값
    if (hasData && widget.datas.isNotEmpty) {
      double maxValue = widget.datas.reduce((a, b) => a > b ? a : b);

      // 적절한 Y축 범위 설정 (4시간 단위로)
      if (maxValue <= 4) {
        maxY = 4;
      } else if (maxValue <= 8) {
        maxY = 8;
      } else if (maxValue <= 12) {
        maxY = 12;
      } else if (maxValue <= 16) {
        maxY = 16;
      } else if (maxValue <= 20) {
        maxY = 20;
      } else {
        maxY = 24;
      }
    }

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
                SizedBox(height: kIsWeb ? 10 : 10.h),
                // 데이터가 없을 때 메시지 표시
                if (!hasData)
                  Padding(
                    padding: EdgeInsets.only(top: kIsWeb ? 60 : 60.h),
                    child: Text(
                      '데이터를 불러오는 중입니다...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: kIsWeb ? 14 : 14.r,
                      ),
                    ),
                  ),
                if (hasData)
                  Row(
                    children: [
                      // Y축 레이블
                      Padding(
                        padding: EdgeInsets.only(top: kIsWeb ? 5 : 5.h),
                        child: SizedBox(
                          width: kIsWeb ? 25 : 25.w,
                          height: kIsWeb ? 142 : 142.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${maxY.toInt()}h',
                                style: TextStyle(
                                  fontSize: kIsWeb ? 10 : 10.r,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${(maxY / 2).toInt()}h',
                                style: TextStyle(
                                  fontSize: kIsWeb ? 10 : 10.r,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '0h',
                                style: TextStyle(
                                  fontSize: kIsWeb ? 10 : 10.r,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 그래프
                      Padding(
                        padding: EdgeInsets.only(left: kIsWeb ? 5.0 : 5.0.h),
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
                            top: kIsWeb ? 70 : 70.h,
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
                                minX: -0.5,
                                maxX: 6.5,
                                minY: 0,
                                maxY: maxY,
                                clipData: FlClipData.none(),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: maxY / 2,
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
                                lineTouchData: LineTouchData(
                                  enabled: true,
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipColor: (touchedSpot) => Color(0xFF2F83F7),
                                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        return LineTooltipItem(
                                          '${spot.y.toStringAsFixed(1)}시간',
                                          TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: kIsWeb ? 12 : 12.r,
                                          ),
                                        );
                                      }).toList();
                                    },
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
                                    isCurved: false,
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
        if (hasData)
          Positioned(
            top: kIsWeb ? 200 : 200.h,
            left: kIsWeb ? 50 : 50.w,
            child: SizedBox(
              width: kIsWeb ? 285 : 285.w,
              height: kIsWeb ? 50 : 50.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  widget.dateLabels.length > 7 ? 7 : widget.dateLabels.length,
                  (index) {
                    final isToday = index == todayIndex;
                    return SizedBox(
                      width: kIsWeb ? 40 : 40.w,
                      child: Text(
                        widget.dateLabels.length > index ? widget.dateLabels[index] : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: kIsWeb ? 13 : 13.r,
                          fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
                          color: isToday ? Color(0xFF2F83F7) : Color(0xFF000000),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
