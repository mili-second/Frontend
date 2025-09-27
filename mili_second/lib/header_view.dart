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
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // 프로필 수정 화면으로 이동
                },
                icon: Image.asset(
                  'assets/icons/${userProfileImage}',
                  width: 70.w,
                  height: 70.h,
                ),
              ),
              Positioned(
                left: 50,
                top: 45,
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
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '오늘의 디지털 습관을 분석했어요',
                    style: TextStyle(
                      color: Color(0xFF524E4E),
                      fontSize: 12,
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
