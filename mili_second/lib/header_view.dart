import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderView extends StatelessWidget {
  final String userName;
  final String userProfileImage;

  const HeaderView({
    super.key,
    required this.userName,
    required this.userProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0.w),
      child: Row(
        children: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // 프로필 수정 화면으로 이동
                },
                icon: Image.asset(
                  '${userProfileImage}',
                  width: 70.w,
                  height: 70.h,
                ),
              ),
              Positioned(
                left: 50.w,
                top: 45.h,
                child: Image.asset('assets/icons/profileEdit.png'),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$userName',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '오늘의 디지털 습관을 분석했어요',
                    style: TextStyle(
                      color: Color(0xFF524E4E),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 30.w),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  // 설정 창이 오른쪽 -> 왼쪽으로 나옴
                },
                icon: Image.asset('assets/icons/settingButton.png'),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ],
      ),
    );
  }
}
