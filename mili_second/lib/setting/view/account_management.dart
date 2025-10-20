import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mili_second/setting/view/app_information.dart';
import '../../setting/view/terms_and_conditions.dart';

class AccountManagement extends StatelessWidget {
  final String userNickName;
  const AccountManagement({super.key, required this.userNickName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Row(
            children: [
              SizedBox(width: kIsWeb ? 100 : 100.w),
              Text(
                '계정 관리',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: kIsWeb ? 20 : 20.r,
                  fontWeight: FontWeight.w700,
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
      body: Padding(
        padding: EdgeInsets.only(
          top: kIsWeb ? 8.0 : 8.h,
          left: kIsWeb ? 20 : 20.w,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsAndConditions()),
                );
              },
              child: Stack(
                children: [
                  SizedBox(
                    width: kIsWeb ? 500 : 500.w,
                    height: kIsWeb ? 50 : 50.h,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/terms_and_conditions.png',
                          width: kIsWeb ? 30 : 30.w,
                          height: kIsWeb ? 30 : 30.h,
                        ),
                        SizedBox(width: kIsWeb ? 25 : 25.w),
                        Text(
                          '약관 및 정책',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: kIsWeb ? 20 : 20.r,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: kIsWeb ? 10.h : 10,
                    left: kIsWeb ? 350 : 350.w,
                    child: Image.asset(
                      'assets/icons/right.png',
                      width: kIsWeb ? 35 : 35.w,
                      height: kIsWeb ? 35 : 35.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: kIsWeb ? 25 : 25.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AppInformation(userNickName: userNickName),
                  ),
                );
              },
              child: Stack(
                children: [
                  SizedBox(
                    width: kIsWeb ? 500 : 500.w,
                    height: kIsWeb ? 50 : 50.h,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/appInformation.png',
                          width: kIsWeb ? 35 : 35.w,
                          height: kIsWeb ? 35 : 35.h,
                        ),
                        SizedBox(width: kIsWeb ? 23 : 23.w),
                        Text(
                          '앱 정보',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: kIsWeb ? 20 : 20.r,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: kIsWeb ? 10.h : 10,
                    left: kIsWeb ? 350 : 350.w,
                    child: Image.asset(
                      'assets/icons/right.png',
                      width: kIsWeb ? 35 : 35.w,
                      height: kIsWeb ? 35 : 35.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
