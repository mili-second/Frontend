import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:mili_second/model/user_model.dart';
import 'package:provider/provider.dart';
import 'edit_profile.dart';
import '../../setting/view/setting.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _EditProfileState();
}

class _EditProfileState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel>();
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Row(
            children: [
              SizedBox(width: kIsWeb ? 80 : 80.w),
              Text(
                '프로필 정보',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: kIsWeb ? 20 : 20.r,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: kIsWeb ? 20 : 20.w),
              GestureDetector(
                onTap: () {
                  // 설정창으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Setting()),
                  );
                },
                child: Row(
                  children: [
                    SizedBox(width: kIsWeb ? 70 : 70.w),
                    Image.asset(
                      'assets/icons/setting.png',
                      width: kIsWeb ? 30 : 30.w,
                      height: kIsWeb ? 30 : 30.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: kIsWeb ? 100 : 100.h,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kIsWeb ? 1 : 1.h),
          child: Container(height: kIsWeb ? 1 : 1.h, color: Color(0xFFCDCBCB)),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: kIsWeb ? 50 : 50.h),
                Row(
                  children: [
                    SizedBox(width: kIsWeb ? 60 : 60.w),
                    SizedBox(
                      child: Image.asset(
                        userModel.userProfileImage ??
                            'assets/icons/profile_default.png',
                        width: kIsWeb ? 250 : 250.w,
                        height: kIsWeb ? 250 : 250.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kIsWeb ? 30 : 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: kIsWeb ? 30 : 30.w),
                    Text(
                      userModel.userId ?? "Default user",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: kIsWeb ? 32 : 32.r,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: kIsWeb ? 5 : 5.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Setting()),
                        );
                      },
                      child: Image.asset(
                        'assets/icons/setting.png',
                        width: kIsWeb ? 40 : 40.w,
                        height: kIsWeb ? 40 : 40.h,
                      ),
                    ),
                  ],
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
                //         fontSize: 17.r,
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
                //         fontSize: 15.r,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),

                //     SizedBox(width: 150.w),

                //     Text(
                //       '직업',
                //       style: TextStyle(
                //         color: Color(0xFF0090FF),
                //         fontSize: 15.r,
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
                //             fontSize: 20.r,
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
                //             fontSize: 20.r,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: kIsWeb ? 40 : 40.h),

                // GestureDetector(
                //   onTap: () {},
                //   child: Column(
                //     children: [
                //       Text(
                //         '로그아웃',
                //         style: TextStyle(
                //           color: Color(0xFF686868),
                //           fontSize: 17.r,
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
          Positioned(
            top: kIsWeb ? 270 : 270.h,
            left: kIsWeb ? 180 : 180.w,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: kIsWeb ? 70 : 70.w),
                  Image.asset(
                    'assets/icons/profile_edit.png',
                    // widget.userProfileImage = 'assets/icons/profile_default.png' ? 'assets/icons/profileEdit.png' : ,
                    width: kIsWeb ? 45 : 45.w,
                    height: kIsWeb ? 45 : 45.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
