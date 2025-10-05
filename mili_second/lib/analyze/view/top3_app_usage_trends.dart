import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Top3AppUsageTrends extends StatefulWidget {
  final String top3AppSummary;
  final List<List> datas;

  const Top3AppUsageTrends({
    super.key,
    required this.top3AppSummary,
    required this.datas,
  });

  @override
  State<Top3AppUsageTrends> createState() => _Top3AppUsageTrendsState();
}

class _Top3AppUsageTrendsState extends State<Top3AppUsageTrends> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362.w,
      height: 351.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(0xFFCDCBCB), width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 12.h, left: 20.w, right: 20.w),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/top3MainIcon.png',
                  width: 30.w,
                  height: 30.w,
                ),
                Text(
                  ' Top3 앱 사용 트렌드',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Stack(
              children: [
                Container(
                  width: 362.w,
                  height: 189.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
                Positioned(
                  top: 63.h,
                  left: 20.w,
                  child: Container(
                    width: 280.w,
                    height: 1,
                    decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                  ),
                ),
                Positioned(
                  top: 126.h,
                  left: 20.w,
                  child: Container(
                    width: 280.w,
                    height: 1,
                    decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                  ),
                ),

                Positioned(
                  left: 13.w,
                  child: top3Info(
                    info_image: 'top1AppIcon',
                    appName: widget.datas[0][1],
                    usageTime: widget.datas[0][2],
                    state: widget.datas[0][3],
                  ),
                ),
                Positioned(
                  top: 63.h,
                  left: 13.w,
                  child: top3Info(
                    info_image: 'top2AppIcon',
                    appName: widget.datas[1][1],
                    usageTime: widget.datas[1][2],
                    state: widget.datas[1][3],
                  ),
                ),
                Positioned(
                  top: 126.h,
                  left: 13.w,
                  child: top3Info(
                    info_image: 'top3AppIcon',
                    appName: widget.datas[2][1],
                    usageTime: widget.datas[2][2],
                    state: widget.datas[2][3],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: 310.w,
              height: 50.h,
              child: Text(
                widget.top3AppSummary.replaceAllMapped(
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
      ),
    );
  }
}

class top3Info extends StatelessWidget {
  final String info_image;
  final String appName;
  final int usageTime;
  final String state;

  const top3Info({
    super.key,
    required this.info_image,
    required this.appName,
    required this.usageTime,
    required this.state,
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
    return Container(
      width: 325.w,
      height: 63.w,
      //decoration: BoxDecoration(color: Colors.yellow),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/${info_image}.png',
            width: 35.w,
            height: 35.w,
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 100.w,
            child: Text(
              appName,
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 70.w,
            child: Text(
              formatMinutes(usageTime),
              style: TextStyle(
                color: Color(0xFFA3A3A3),
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              state,
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
