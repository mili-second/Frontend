import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Top3AppUsageTrends extends StatefulWidget {
  final String top3AppSummary;
  const Top3AppUsageTrends({super.key, required this.top3AppSummary});

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
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 50.h,
              child: Text(
                textAlign: TextAlign.center,
                widget.top3AppSummary.replaceAll('.', '.\n'),
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
