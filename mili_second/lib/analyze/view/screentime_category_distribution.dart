import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:mili_second/analyze/model/screentime_category_distribution_model.dart';

class ScreentimeCategoryDistribution extends StatefulWidget {
  //final String categoryDistributionSummary;

  final List<ScreentimeCategoryDistributionModel> chartData;

  const ScreentimeCategoryDistribution({
    super.key,
    //required this.categoryDistributionSummary,
    required this.chartData,
  });

  @override
  State<ScreentimeCategoryDistribution> createState() =>
      _ScreentimeCategoryDistributionState();
}

// class _ScreentimeCategoryDistributionState
//     extends State<ScreentimeCategoryDistribution> {
//   @override
//   Widget build(BuildContext context) {
//     final data = widget.chartData.isNotEmpty
//         ? [
//             _Slice(
//               widget.chartData[0].categoryName,
//               widget.chartData[0].ratio.toDouble(),
//               Colors.red,
//             ),
//             _Slice(
//               widget.chartData[1].categoryName,
//               widget.chartData[1].ratio.toDouble(),
//               Colors.orange,
//             ),
//             _Slice(
//               widget.chartData[2].categoryName,
//               widget.chartData[2].ratio.toDouble(),
//               Colors.green,
//             ),
//             _Slice(
//               widget.chartData[3].categoryName,
//               widget.chartData[3].ratio.toDouble(),
//               Colors.blue,
//             ),
//             _Slice(
//               widget.chartData[4].categoryName,
//               widget.chartData[4].ratio.toDouble(),
//               Colors.purple,
//             ),
//           ]
//         : [];

//     return Container(
//       width: kIsWeb ? 362 : 362.w,
//       height: kIsWeb ? 420 : 420.h,
//       decoration: BoxDecoration(
//         color: Color(0xFFFFFFFF),
//         borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
//         border: Border.all(color: Color(0xFFCDCBCB), width: kIsWeb ? 1 : 1.w),
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(
//           top: kIsWeb ? 12 : 12.h,
//           left: kIsWeb ? 20 : 20.w,
//           right: kIsWeb ? 20 : 20.w,
//         ),
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       'assets/icons/screenTimeCategoryIcon.png',
//                       width: kIsWeb ? 30 : 30.w,
//                       height: kIsWeb ? 30 : 30.w,
//                     ),
//                     Text(
//                       '  스크린 타임 카테고리 분포',
//                       style: TextStyle(
//                         color: Color(0xFF000000),
//                         fontSize: kIsWeb ? 17 : 17.r,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: kIsWeb ? 275 : 275.h),
//                 // SizedBox(
//                 //   width: 310.w,
//                 //   height: 50.h,
//                 //   child: Text(
//                 //     widget.categoryDistributionSummary.replaceAllMapped(
//                 //       RegExp(r'([.!?])\s*'), // . 또는 ! 또는 ? 뒤의 공백까지 매칭
//                 //       (match) => '${match[1]}\n', // 그 기호 뒤에 줄바꿈 추가
//                 //     ),
//                 //     style: TextStyle(
//                 //       color: Color(0xFF000000),
//                 //       fontSize: 15.r,
//                 //       fontWeight: FontWeight.w500,
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//             Positioned(
//               top: kIsWeb ? 100 : 100.h,
//               left: kIsWeb ? 80 : 80.w,
//               child: SizedBox(
//                 width: kIsWeb ? 150 : 150.w,
//                 height: kIsWeb ? 150 : 150.h,
//                 // 그래프
//                 child: PieChart(
//                   PieChartData(
//                     sectionsSpace: 0,
//                     centerSpaceRadius: 80,
//                     startDegreeOffset: -90,
//                     sections: data.map((e) {
//                       return PieChartSectionData(
//                         value: e.value.toDouble(),
//                         color: e.color,
//                         radius: kIsWeb ? 25 : 25.r,
//                         title: '',
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: kIsWeb ? 145 : 145.h,
//               left: kIsWeb ? 117 : 117.w,
//               child: Column(
//                 children: [
//                   Text(
//                     '75%',
//                     style: TextStyle(
//                       color: Color(0xFF000000),
//                       fontSize: kIsWeb ? 24 : 24.r,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                   Text('엔터테인먼트'),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: kIsWeb ? 320 : 320.h,
//               left: kIsWeb ? 10 : 10.w,
//               child: SizedBox(
//                 child: Column(
//                   children: [
//                     Container(
//                       width: kIsWeb ? 300 : 300.w,
//                       height: kIsWeb ? 1 : 1.h,
//                       decoration: BoxDecoration(color: Color(0xFFBEBEBE)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: kIsWeb ? 330 : 330.h,
//               left: kIsWeb ? 13 : 13.w,
//               child: SizedBox(
//                 width: kIsWeb ? 300 : 300.w,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         ChartInfo(
//                           widget: widget,
//                           colorInfo: Colors.red,
//                           title: widget.chartData[0].categoryName,
//                           percentage: widget.chartData[0].ratio,
//                         ),
//                         SizedBox(width: kIsWeb ? 10 : 10.w),
//                         ChartInfo(
//                           widget: widget,
//                           colorInfo: Colors.orange,
//                           title: widget.chartData[1].categoryName,
//                           percentage: widget.chartData[1].ratio,
//                         ),
//                         SizedBox(width: kIsWeb ? 10 : 10.w),
//                         ChartInfo(
//                           widget: widget,
//                           colorInfo: Colors.green,
//                           title: widget.chartData[2].categoryName,
//                           percentage: widget.chartData[2].ratio,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: kIsWeb ? 10 : 10.h),
//                     Row(
//                       children: [
//                         ChartInfo(
//                           widget: widget,
//                           colorInfo: Colors.blue,
//                           title: widget.chartData[3].categoryName,
//                           percentage: widget.chartData[3].ratio,
//                         ),
//                         SizedBox(width: kIsWeb ? 10 : 10.w),
//                         ChartInfo(
//                           widget: widget,
//                           colorInfo: Colors.purple,
//                           title: widget.chartData[4].categoryName,
//                           percentage: widget.chartData[4].ratio,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class _ScreentimeCategoryDistributionState
    extends State<ScreentimeCategoryDistribution> {
  @override
  Widget build(BuildContext context) {

    List<ScreentimeCategoryDistributionModel> rawData = widget.chartData;
    double sumOfNonOtherPercentages = 0.0;
    List<Map<String, dynamic>> processedData = [];

    // "OTHER"를 제외한 카테고리 처리
    for (var item in rawData) {
      if (item.categoryName != "OTHER") {
        // 비율(ratio)을 퍼센트(%)로 변환 후 정수로 반올림
        int percentage = (item.ratio * 100.0).round();
        sumOfNonOtherPercentages += percentage;
        processedData.add({'name': item.categoryName, 'value': percentage});
      }
    }

    // "OTHER" 카테고리 비율 계산 (100 - 나머지 합)
    double otherPercentage = 100 - sumOfNonOtherPercentages;
    processedData.add({
      'name': 'OTHER',
      'value': (otherPercentage < 0 ? 0 : otherPercentage) // 0% 미만 방지
    });

    // 값(비율)이 큰 순서대로 정렬
    processedData.sort((a, b) => (b['value'] as int).compareTo(a['value'] as int));

    // 2. 변환된 `processedData`를 사용하여 `_Slice` 리스트 생성 (수정)
    List<_Slice> data = List.generate(5, (index) {
      if (index < widget.chartData.length) {
        return _Slice(
          processedData[index]['name'],
          (processedData[index]['value'] as int).toDouble(),
          _getCategoryColor(index), // 정렬된 순서대로 색상 적용
        );
      } else {
        return _Slice(
          'data', // 빈 데이터에 대한 categoryName
          0, // 빈 데이터에 대한 ratio
          Colors.grey, // 빈 데이터에 대한 색상
        );
      }
    });

    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 450 : 450.h,
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
              ],
            ),

            Positioned(
              top: kIsWeb ? 100 : 100.h,
              left: kIsWeb ? 80 : 80.w,
              child: widget.chartData.isEmpty
                  ? Container(
                      alignment: Alignment.bottomLeft,
                      width: kIsWeb ? 380 : 380.w,
                      child: Text('스크린 타임 데이터가 없습니다'),
                    )
                  : SizedBox(
                      width: kIsWeb ? 150 : 150.w,
                      height: kIsWeb ? 150 : 150.h,
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
              // 파이 차트의 SizedBox와 동일한 위치/크기
              top: kIsWeb ? 100 : 100.h,
              left: kIsWeb ? 80 : 80.w,
              width: kIsWeb ? 150 : 150.w,
              height: kIsWeb ? 150 : 150.h,
              child: Center(
                // data[0] (1등)의 값이 있을 때만 표시
                child: (data.isNotEmpty && data[0].value > 0)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 1등 카테고리 퍼센트 (정수로 반올림)
                          Text(
                            '${data[0].value.round()}%',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: kIsWeb ? 24 : 24.r,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: kIsWeb ? 4 : 4.h),
                          Row(
                            // Row가 중앙에 오도록 설정
                            mainAxisSize: MainAxisSize.min, 
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 1등 카테고리 색상 원
                              Container(
                                width: kIsWeb ? 10 : 10.w,
                                height: kIsWeb ? 10 : 10.h,
                                decoration: BoxDecoration(
                                  color: data[0].color, // 1등 색상
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: kIsWeb ? 5 : 5.w),
                              // 1등 카테고리 이름
                              Text(
                                data[0].name,
                                style: TextStyle(
                                  color: Color(0xFF6A6A6A),
                                  fontSize: kIsWeb ? 15 : 15.r,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox.shrink(), // 데이터가 없으면 비움
              ),
            ),
            // Positioned(
            //   top: kIsWeb ? 145 : 145.h,
            //   left: kIsWeb ? 117 : 117.w,
            //   child: Column(
            //     children: [
            //       Text(
            //         '75%',
            //         style: TextStyle(
            //           color: Color(0xFF000000),
            //           fontSize: kIsWeb ? 24 : 24.r,
            //           fontWeight: FontWeight.w900,
            //         ),
            //       ),
            //       Text(
            //         data[0].name,
            //         style: TextStyle(
            //         color: Color(0xFF6A6A6A),
            //         fontSize: kIsWeb ? 15 : 15.r,
            //         fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
              top: kIsWeb ? 335 : 335.h,
              left: kIsWeb ? 11 : 11.w,
              child: SizedBox(
                width: kIsWeb ? 300 : 300.w,
                child: Wrap(
                  spacing: kIsWeb ? 10 : 10.w, // 아이템 간 가로 간격
                  runSpacing: kIsWeb ? 10 : 10.h, // 줄(Row) 간 세로 간격
                  children: data.skip(1).map((slice) {
                  // children: data.map((slice) {
                    // ChartInfo 위젯 생성
                    return ChartInfo(
                      widget: widget,
                      colorInfo: slice.color,
                      title: slice.name,
                      percentage: slice.value,
                    );
                  }).toList(), // List<ChartInfo> 생성
                ),
                // child: Column(
                //   children: [
                //     Row(
                //       children: [
                //         ChartInfo(
                //           widget: widget,
                //           colorInfo: Colors.red,
                //           title: data[0].name,
                //           percentage: data[0].value,
                //         ),
                //         SizedBox(width: kIsWeb ? 10 : 10.w),
                //         ChartInfo(
                //           widget: widget,
                //           colorInfo: Colors.orange,
                //           title: data[1].name,
                //           percentage: data[1].value,
                //         ),
                //         SizedBox(width: kIsWeb ? 10 : 10.w),
                //         ChartInfo(
                //           widget: widget,
                //           colorInfo: Colors.green,
                //           title: data[2].name,
                //           percentage: data[2].value,
                //         ),
                //       ],
                //     ),
                //     SizedBox(height: kIsWeb ? 10 : 10.h),
                //     Row(
                //       children: [
                //         ChartInfo(
                //           widget: widget,
                //           colorInfo: Colors.blue,
                //           title: data[3].name,
                //           percentage: data[3].value,
                //         ),
                //         SizedBox(width: kIsWeb ? 10 : 10.w),
                //         ChartInfo(
                //           widget: widget,
                //           colorInfo: Colors.purple,
                //           title: data[4].name,
                //           percentage: data[4].value,
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 색상 설정 함수 (각 카테고리 색상 지정)
  Color _getCategoryColor(int index) {
    switch (index) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class ChartInfo extends StatelessWidget {
  final Color colorInfo;
  final String title;
  final double percentage;

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
    
    if (title == 'data' || percentage == 0.0 ) {
      return SizedBox.shrink(); // 빈 위젯 반환
    }

    return Row(
      children: [
        Container(
          width: kIsWeb ? 10 : 10.w,
          height: kIsWeb ? 10 : 10.h,
          decoration: BoxDecoration(color: colorInfo, shape: BoxShape.circle),
        ),
        SizedBox(width: kIsWeb ? 5 : 5.w),
        Text('${title}  ${percentage.round()}%'),
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
