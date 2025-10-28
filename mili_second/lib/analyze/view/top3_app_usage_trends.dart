import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:milli_second/analyze/model/top3_app_usage_model.dart';

class Top3AppUsageTrends extends StatefulWidget {
  //final String top3AppSummary;
  final List<Top3AppUsage> datas;

  const Top3AppUsageTrends({
    super.key,
    //required this.top3AppSummary,
    required this.datas,
  });

  @override
  State<Top3AppUsageTrends> createState() => _Top3AppUsageTrendsState();
}

class _Top3AppUsageTrendsState extends State<Top3AppUsageTrends> {
  @override
  Widget build(BuildContext context) {
    List<Top3AppUsage> data = List.generate(3, (index) {
      if (index < widget.datas.length) {
        return widget.datas[index]; // 데이터가 있으면 사용
      } else {
        return Top3AppUsage(
          rank: index + 1, // 빈 데이터에도 rank 추가
          appName: 'No Data',
          packageName: 'No Data',
          usageMinutes: 0,
        ); // 빈 데이터 추가
      }
    });

    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 270 : 270.h,
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
                  'assets/icons/top3MainIcon.png',
                  width: kIsWeb ? 30 : 30.w,
                  height: kIsWeb ? 30 : 30.w,
                ),
                Text(
                  ' Top3 앱 사용 트렌드',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: kIsWeb ? 17 : 17.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: kIsWeb ? 10 : 10.h),
            Stack(
              children: [
                Container(
                  width: kIsWeb ? 362 : 362.w,
                  height: kIsWeb ? 189 : 189.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(kIsWeb ? 5 : 5.r),
                  ),
                ),
                Positioned(
                  top: kIsWeb ? 63 : 63.h,
                  left: kIsWeb ? 20 : 20.w,
                  child: Container(
                    width: kIsWeb ? 280 : 280.w,
                    height: kIsWeb ? 1 : 1.h,
                    decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                  ),
                ),
                Positioned(
                  top: kIsWeb ? 126 : 126.h,
                  left: kIsWeb ? 20 : 20.w,
                  child: Container(
                    width: kIsWeb ? 280 : 280.w,
                    height: kIsWeb ? 1 : 1.h,
                    decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                  ),
                ),
                // top3Info 위젯 생성
                Positioned(
                  left: kIsWeb ? 13 : 13.w,
                  child: top3Info(
                    info_image: 'top1AppIcon',
                    appName: data[0].appName,
                    usageTime: data[0].usageMinutes,
                  ),
                ),
                Positioned(
                  top: kIsWeb ? 63 : 63.h,
                  left: kIsWeb ? 13 : 13.w,
                  child: top3Info(
                    info_image: 'top2AppIcon',
                    appName: data[1].appName,
                    usageTime: data[1].usageMinutes,
                  ),
                ),
                Positioned(
                  top: kIsWeb ? 126 : 126.h,
                  left: kIsWeb ? 13 : 13.w,
                  child: top3Info(
                    info_image: 'top3AppIcon',
                    appName: data[2].appName,
                    usageTime: data[2].usageMinutes,
                  ),
                ),
              ],
            ),
            SizedBox(height: kIsWeb ? 20 : 20.h),
            // SizedBox(
            //   width: 310.w,
            //   height: 50.h,
            //   child: Text(
            //     widget.top3AppSummary.replaceAllMapped(
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

class top3Info extends StatelessWidget {
  final String info_image;
  final String appName;
  final int usageTime;

  const top3Info({
    super.key,
    required this.info_image,
    required this.appName,
    required this.usageTime,
  });

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
    return SizedBox(
      width: kIsWeb ? 325 : 325.w,
      height: kIsWeb ? 63 : 63.w,
      //decoration: BoxDecoration(color: Colors.yellow),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/${info_image}.png',
            width: kIsWeb ? 35 : 35.w,
            height: kIsWeb ? 35 : 35.w,
          ),
          SizedBox(width: kIsWeb ? 20 : 20.w),
          SizedBox(
            width: kIsWeb ? 150 : 150.w,
            child: Text(
              appName,
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: kIsWeb ? 18 : 18.r,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: kIsWeb ? 40 : 40.w),
          SizedBox(
            width: kIsWeb ? 50 : 50.w,
            child: Text(
              formatMinutes(usageTime),
              style: TextStyle(
                color: Color(0xFFA3A3A3),
                fontSize: kIsWeb ? 15 : 15.r,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // SizedBox(
          //   width: kIsWeb ? 100 : 100.w,
          //   child: Text(
          //     state,
          //     style: TextStyle(
          //       color: Color(0xFF000000),
          //       fontSize: kIsWeb ? 15 : 15.r,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
