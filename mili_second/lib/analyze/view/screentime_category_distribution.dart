import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreentimeCategoryDistribution extends StatefulWidget {
  final String categoryDistributionSummary;

  const ScreentimeCategoryDistribution({
    super.key,
    required this.categoryDistributionSummary,
  });

  @override
  State<ScreentimeCategoryDistribution> createState() =>
      _ScreentimeCategoryDistributionState();
}

class _ScreentimeCategoryDistributionState
    extends State<ScreentimeCategoryDistribution> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362.w,
      height: 470.h,
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
            SizedBox(height: 10.h),
            SizedBox(
              // 그래프
            ),
            SizedBox(height: 20.h),
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
      ),
    );
  }
}
