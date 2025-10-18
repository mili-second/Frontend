import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';

class SpecialThisWeeks extends StatelessWidget {
  final String comment;
  const SpecialThisWeeks({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 172 : 172.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0DE6FE),
            Color(0xFF4DAEFE),
            Color(0xFF4DAEFE),
            Color(0xFF0DE6FE),
          ],
          stops: [0, 0.23, 0.72, 1],
        ),
        borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: kIsWeb ? 20 : 20.h,
          left: kIsWeb ? 20 : 20.w,
          right: kIsWeb ? 20 : 20.w,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/discover.png',
                  width: kIsWeb ? 40.24 : 40.24.w,
                  height: kIsWeb ? 40.24 : 40.24.h,
                ),
                SizedBox(width: kIsWeb ? 10 : 10.w),
                Text(
                  '이번주 특이사항',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: kIsWeb ? 17 : 17.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: kIsWeb ? 10 : 10.h),

            SizedBox(
              width: kIsWeb ? 280 : 280.w,
              child: Text(
                textAlign: TextAlign.start,
                comment.replaceAllMapped(
                  RegExp(r'([.!?])\s*'), // . 또는 ! 또는 ? 뒤의 공백까지 매칭
                  (match) => '${match[1]}\n', // 그 기호 뒤에 줄바꿈 추가
                ),
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: kIsWeb ? 15 : 15.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
