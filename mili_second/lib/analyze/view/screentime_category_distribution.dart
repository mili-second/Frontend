import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

class ScreentimeCategoryDistribution extends StatefulWidget {
  final String categoryDistributionSummary;

  final List<List> chartData;

  const ScreentimeCategoryDistribution({
    super.key,
    required this.categoryDistributionSummary,
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
        widget.chartData[0][0],
        widget.chartData[0][1].toDouble(),
        Colors.red,
      ),
      _Slice(
        widget.chartData[1][0],
        widget.chartData[1][1].toDouble(),
        Colors.orange,
      ),
      _Slice(
        widget.chartData[2][0],
        widget.chartData[2][1].toDouble(),
        Colors.green,
      ),
      _Slice(
        widget.chartData[3][0],
        widget.chartData[3][1].toDouble(),
        Colors.blue,
      ),
      _Slice(
        widget.chartData[4][0],
        widget.chartData[4][1].toDouble(),
        Colors.purple,
      ),
    ];

    return Container(
      width: 362.w,
      height: 500.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(0xFFCDCBCB), width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 12.h, left: 20.w, right: 20.w),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/screenTimeCategoryIcon.png',
                      width: 30.w,
                      height: 30.w,
                    ),
                    Text(
                      '  스크린 타임 카테고리 분포',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 375.h),
                SizedBox(
                  width: 310.w,
                  height: 50.h,
                  child: Text(
                    widget.categoryDistributionSummary.replaceAllMapped(
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
              ],
            ),
            Positioned(
              top: 100.h,
              left: 80.w,
              child: SizedBox(
                width: 150.w,
                height: 150.h,
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
                        radius: 25,
                        title: '',
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 145.h,
              left: 117.w,
              child: Column(
                children: [
                  Text(
                    '75%',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text('엔터테인먼트'),
                ],
              ),
            ),
            Positioned(
              top: 320.h,
              left: 10.w,
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      width: 300.w,
                      height: 1.h,
                      decoration: BoxDecoration(color: Color(0xFFBEBEBE)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 330.h,
              left: 13.w,
              child: SizedBox(
                width: 300.w,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ChartInfo(
                          widget: widget,
                          colorInfo: Colors.red,
                          title: widget.chartData[0][0],
                          percentage: widget.chartData[0][1],
                        ),
                        SizedBox(width: 10.w),
                        ChartInfo(
                          widget: widget,
                          colorInfo: Colors.orange,
                          title: widget.chartData[1][0],
                          percentage: widget.chartData[1][1],
                        ),
                        SizedBox(width: 10.w),
                        ChartInfo(
                          widget: widget,
                          colorInfo: Colors.green,
                          title: widget.chartData[2][0],
                          percentage: widget.chartData[2][1],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        ChartInfo(
                          widget: widget,
                          colorInfo: Colors.blue,
                          title: widget.chartData[3][0],
                          percentage: widget.chartData[3][1],
                        ),
                        SizedBox(width: 10.w),
                        ChartInfo(
                          widget: widget,
                          colorInfo: Colors.purple,
                          title: widget.chartData[4][0],
                          percentage: widget.chartData[4][1],
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
          width: 20.w,
          height: 20.h,
          decoration: BoxDecoration(color: colorInfo, shape: BoxShape.circle),
        ),
        SizedBox(width: 5.w),
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
