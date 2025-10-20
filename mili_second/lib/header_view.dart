import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:mili_second/model/user_model.dart';
import 'package:provider/provider.dart';
import 'profile/view/profile_info.dart';

class HeaderView extends StatefulWidget {
  const HeaderView({super.key});

  @override
  State<HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> {
  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel>();
    return Padding(
      padding: EdgeInsets.all(kIsWeb ? 5.0 : 5.0.w),
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
                        userNickName: userModel.userId,
                        userProfileImage: userModel.userProfileImage,
                        userGender: userModel.userGender,
                        userJob: userModel.userJob,
                      ),
                    ),
                  );
                },
                icon: Image.asset(
                  userModel.userProfileImage ??
                      'assets/icons/profile_default.png',
                  width: kIsWeb ? 70 : 70.w,
                  height: kIsWeb ? 70 : 70.h,
                ),
              ),
              Positioned(
                left: kIsWeb ? 50 : 50.w,
                top: kIsWeb ? 45 : 45.h,
                child: Image.asset('assets/icons/profileEdit.png'),
              ),
            ],
          ),
          SizedBox(width: kIsWeb ? 10 : 10.w),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userModel.userId ?? 'Mili',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: kIsWeb ? 24 : 24.r,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: kIsWeb ? 5 : 5.h),
                  Text(
                    '오늘의 디지털 습관을 분석했어요',
                    style: TextStyle(
                      color: Color(0xFF524E4E),
                      fontSize: kIsWeb ? 12 : 12.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: kIsWeb ? 55 : 55.w),
          Column(
            children: [
              SizedBox(height: kIsWeb ? 5 : 5.h),
              IconButton(
                onPressed: () {
                  context.read<UserModel>().logout();
                },
                icon: Image.asset(
                  'assets/icons/logout.png',
                  width: kIsWeb ? 35 : 35.w,
                  height: kIsWeb ? 35 : 35.h,
                ),
              ),
              SizedBox(height: kIsWeb ? 10 : 10.h),
            ],
          ),
        ],
      ),
    );
  }
}
