import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:mili_second/analyze/model/usage_patterns_by_time_of_day_model.dart';

class ScreentimeCategoryDistribution extends StatefulWidget {
  //final String categoryDistributionSummary;

  final List<UsagePatternsByTimeOfDayModel> chartData;

  const ScreentimeCategoryDistribution({
    super.key,
    //required this.categoryDistributionSummary,
    required this.chartData,
  });

  @override
  State<ScreentimeCategoryDistribution> createState() =>
      _ScreentimeCategoryDistributionState();
}

class _ScreentimeCategoryDistributionState
    extends State<ScreentimeCategoryDistribution> {
  @override
  Widget build(BuildContext context) {
    final data = [
      _Slice(
        widget.chartData[0].categoryName,
        widget.chartData[0].ratio.toDouble(),
        Colors.red,
      ),
      _Slice(
        widget.chartData[1].categoryName,
        widget.chartData[1].ratio.toDouble(),
        Colors.orange,
      ),
      _Slice(
        widget.chartData[2].categoryName,
        widget.chartData[2].ratio.toDouble(),
        Colors.green,
      ),
      _Slice(
        widget.chartData[3].categoryName,
        widget.chartData[3].ratio.toDouble(),
        Colors.blue,
      ),
      _Slice(
        widget.chartData[4].categoryName,
        widget.chartData[4].ratio.toDouble(),
        Colors.purple,
      ),
    ];

    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 420 : 420.h,
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
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/screenTimeCategoryIcon.png',
                      width: kIsWeb ? 30 : 30.w,
                      height: kIsWeb ? 30 : 30.w,
                    ),
                    Text(
                      '  스크린 타임 카테고리 분포',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: kIsWeb ? 17 : 17.r,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kIsWeb ? 275 : 275.h),
                // SizedBox(
                //   width: 310.w,
                //   height: 50.h,
                //   child: Text(
                //     widget.categoryDistributionSummary.replaceAllMapped(
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
            Positioned(
              top: kIsWeb ? 100 : 100.h,
              left: kIsWeb ? 80 : 80.w,
              child: SizedBox(
                width: kIsWeb ? 150 : 150.w,
                height: kIsWeb ? 150 : 150.h,
                // 그래프
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 80,
                    startDegreeOffset: -90,
                    sections: data.map((e) {
                      return PieChartSectionData(
                        value: e.value.toDouble(),
                        color: e.color,
                        radius: kIsWeb ? 25 : 25.r,
                        title: '',
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Positioned(
              top: kIsWeb ? 145 : 145.h,
              left: kIsWeb ? 117 : 117.w,
              child: Column(
                children: [
                  Text(
                    '75%',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: kIsWeb ? 24 : 24.r,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text('엔터테인먼트'),
                ],
              ),
            ),
            Positioned(
              top: kIsWeb ? 320 : 320.h,
              left: kIsWeb ? 10 : 10.w,
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      width: kIsWeb ? 300 : 300.w,
                      height: kIsWeb ? 1 : 1.h,
                      decoration: BoxDecoration(color: Color(0xFFBEBEBE)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: kIsWeb ? 330 : 330.h,
              left: kIsWeb ? 13 : 13.w,
              child: SizedBox(
                width: kIsWeb ? 300 : 300.w,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ChartInfo(
                          widget: widget,
                          colorInfo: Colors.red,
                          title: widget.chartData[0].categoryName,
                          percentage: widget.chartData[0].ratio,
                        ),
                        SizedBox(width: kIsWeb ? 10 : 10.w),
                        ChartInfo(
                          widget: widget,
                          colorInfo: Colors.orange,
                          title: widget.chartData[1].categoryName,
                          percentage: widget.chartData[1].ratio,
                        ),
                        SizedBox(width: kIsWeb ? 10 : 10.w),
                        ChartInfo(
                          widget: widget,
                          colorInfo: Colors.green,
                          title: widget.chartData[2].categoryName,
                          percentage: widget.chartData[2].ratio,
                        ),
                      ],
                    ),
                    SizedBox(height: kIsWeb ? 10 : 10.h),
                    Row(
                      children: [
                        ChartInfo(
                          widget: widget,
                          colorInfo: Colors.blue,
                          title: widget.chartData[3].categoryName,
                          percentage: widget.chartData[3].ratio,
                        ),
                        SizedBox(width: kIsWeb ? 10 : 10.w),
                        ChartInfo(
                          widget: widget,
                          colorInfo: Colors.purple,
                          title: widget.chartData[4].categoryName,
                          percentage: widget.chartData[4].ratio,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartInfo extends StatelessWidget {
  final Color colorInfo;
  final title;
  final percentage;

  const ChartInfo({
    super.key,
    required this.widget,
    required this.colorInfo,
    required this.title,
    required this.percentage,
  });

  final ScreentimeCategoryDistribution widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: kIsWeb ? 20 : 20.w,
          height: kIsWeb ? 20 : 20.h,
          decoration: BoxDecoration(color: colorInfo, shape: BoxShape.circle),
        ),
        SizedBox(width: kIsWeb ? 5 : 5.w),
        Text('${title}  ${percentage}%'),
      ],
    );
  }
}

class _Slice {
  final String name;
  final double value;
  final Color color;
  _Slice(this.name, this.value, this.color);
}
