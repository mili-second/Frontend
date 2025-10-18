import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'profile/view/profile_info.dart';
import 'package:mili_second/login_view.dart';

class HeaderView extends StatefulWidget {
  final String userNickName;
  final String userProfileImage;

  const HeaderView({
    super.key,
    required this.userNickName,
    required this.userProfileImage,
  });

  @override
  State<HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> {
  final storage = FlutterSecureStorage();

  Future<void> test_logout() async {
    print("logout");
    await storage.delete(key: "token");
  }

  @override
  Widget build(BuildContext context) {
    final userGender = '여성';
    final userJob = '주부';
    return Padding(
      padding: EdgeInsets.all(5.0.w),
      child: Row(
        children: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // 프로필 수정 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileInfo(
                        userNickName: widget.userNickName,
                        userProfileImage: widget.userProfileImage,
                        userGender: userGender,
                        userJob: userJob,
                      ),
                    ),
                  );
                },
                icon: Image.asset(
                  widget.userProfileImage,
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
                    widget.userNickName,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 24.r,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '오늘의 디지털 습관을 분석했어요',
                    style: TextStyle(
                      color: Color(0xFF524E4E),
                      fontSize: 12.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 55.w),
          Column(
            children: [
              SizedBox(height: 5.h),
              IconButton(
                onPressed: () {
                  test_logout();
                  // 현재까지의 모든 페이지 기록을 삭제하고 LoginView로 이동합니다.
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                    (route) => false, // false를 반환하면 이전 모든 라우트를 제거합니다.
                  );
                },
                icon: Image.asset(
                  'assets/icons/logout.png',
                  width: 35.w,
                  height: 35.h,
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ],
      ),
    );
  }
}
