import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

class SevenDaysUsageTrends extends StatefulWidget {
  const SevenDaysUsageTrends({super.key});

  @override
  State<SevenDaysUsageTrends> createState() => _SevenDaysUsageTrendsState();
}

class _SevenDaysUsageTrendsState extends State<SevenDaysUsageTrends> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 220 : 220.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
        border: Border.all(color: Color(0xFFCDCBCB), width: kIsWeb ? 1 : 1.w),
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
            Row(
              children: [
                // 그래프
                SizedBox(
                  width: kIsWeb ? 320 : 320.w,
                  height: kIsWeb ? 142 : 142.h,
                  // decoration: BoxDecoration(
                  //   color: Color(0xFFFFFFFF),
                  //   borderRadius: BorderRadius.circular(10.r),
                  //   border: Border.all(color: Color(0xFFCDCBCB), width: 1.w),
                  // ),
                  // child: LineChart(
                  //   LineChartData(
                  //     lineBarsData: [
                  //       LineChartBarData(
                  //         spots: [
                  //           FlSpot(0, 2), // 월
                  //           FlSpot(1, 8), // 화
                  //           FlSpot(2, 14), // 수
                  //           FlSpot(3, 20), // 목
                  //           FlSpot(4, 23), // 금
                  //           FlSpot(5, 6), // 토
                  //         ],
                  //         isCurved: false,
                  //         dotData: FlDotData(show: true),
                  //       ),
                  //     ],
                  //     titlesData: FlTitlesData(
                  //       bottomTitles: AxisTitles(
                  //         sideTitles: SideTitles(
                  //           showTitles: true,
                  //           getTitlesWidget: (value, meta) {
                  //             const days = ['월', '화', '수', '목', '금', '토'];
                  //             return Text(days[value.toInt()]);
                  //           },
                  //         ),
                  //       ),
                  //       leftTitles: AxisTitles(
                  //         sideTitles: SideTitles(
                  //           showTitles: true,
                  //           interval: 6, // 6시간 간격
                  //           getTitlesWidget: (value, meta) {
                  //             return Text('${value.toInt()}h');
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     minY: 0,
                  //     maxY: 24,
                  //   ),
                  // ),
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
    );
  }
}
