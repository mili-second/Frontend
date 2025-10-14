import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/user/view/edit_profile.dart';

class ProfileInfo extends StatefulWidget {
  final userProfileImage;
  final userNickName;
  final userGender;
  final userJob;

  const ProfileInfo({
    super.key,
    required this.userProfileImage,
    required this.userNickName,
    required this.userGender,
    required this.userJob,
  });

  @override
  State<ProfileInfo> createState() => _EditProfileState();
}

class _EditProfileState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Row(
            children: [
              SizedBox(width: 80.w),
              Text(
                '프로필 정보',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {
                  // 설정창으로 이동
                },
                child: Row(
                  children: [
                    SizedBox(width: 70.w),
                    Image.asset(
                      'assets/icons/setting.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 100.h,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(height: 1.h, color: Color(0xFFCDCBCB)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Row(
              children: [
                SizedBox(width: 55.w),
                SizedBox(
                  child: Image.asset(
                    widget.userProfileImage,
                    width: 250.w,
                    height: 250.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(
                      currentUserNickName: widget.userNickName,
                      currentGender: widget.userGender,
                      currentJob: widget.userJob,
                      currentProfilePath: widget.userProfileImage,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.userNickName,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Image.asset(
                    'assets/icons/profileEdit.png',
                    width: 30.w,
                    height: 30.h,
                  ),
                ],
              ),
            ),

            // SizedBox(height: 50.h),
            // Container(
            //   width: 349.w,
            //   height: 1.h,
            //   decoration: BoxDecoration(color: Color(0xFFB3B3B3)),
            // ),
            // SizedBox(height: 20.h),
            // Row(
            //   children: [
            //     SizedBox(width: 15.w),
            //     Text(
            //       '기본 정보',
            //       style: TextStyle(
            //         color: Color(0xFF000000),
            //         fontSize: 17.sp,
            //         fontWeight: FontWeight.w700,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 20.h),
            // Row(
            //   children: [
            //     SizedBox(width: 15.h),
            //     Text(
            //       '성별',
            //       style: TextStyle(
            //         color: Color(0xFF0090FF),
            //         fontSize: 15.sp,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),

            //     SizedBox(width: 150.w),

            //     Text(
            //       '직업',
            //       style: TextStyle(
            //         color: Color(0xFF0090FF),
            //         fontSize: 15.sp,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 20.h),
            // Row(
            //   children: [
            //     SizedBox(width: 15.h),
            //     Container(
            //       width: 120.w,
            //       height: 50.h,
            //       decoration: BoxDecoration(
            //         color: Color(0xFF0088FF),
            //         borderRadius: BorderRadius.circular(6.r),
            //       ),
            //       child: Center(
            //         child: Text(
            //           widget.userGender,
            //           style: TextStyle(
            //             color: Color(0xFFFFFFFF),
            //             fontSize: 20.sp,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 60.h),
            //     Container(
            //       width: 160.w,
            //       height: 50.h,
            //       decoration: BoxDecoration(
            //         color: Color(0xFF0088FF),
            //         borderRadius: BorderRadius.circular(6.r),
            //       ),
            //       child: Center(
            //         child: Text(
            //           widget.userJob,
            //           style: TextStyle(
            //             color: Color(0xFFFFFFFF),
            //             fontSize: 20.sp,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 40.h),

            // GestureDetector(
            //   onTap: () {},
            //   child: Column(
            //     children: [
            //       Text(
            //         '로그아웃',
            //         style: TextStyle(
            //           color: Color(0xFF686868),
            //           fontSize: 17.sp,
            //           fontWeight: FontWeight.w700,
            //         ),
            //       ),
            //       SizedBox(height: 5.h),
            //       Container(
            //         width: 70.w,
            //         height: 1.h,
            //         decoration: BoxDecoration(color: Color(0xFF686868)),
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   width: 349.w,
            //   height: 1.h,
            //   decoration: BoxDecoration(color: Color(0xFFB3B3B3)),
            // ),
          ],
        ),
      ),
    );
  }
}
