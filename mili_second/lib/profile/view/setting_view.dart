import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:mili_second/model/user_model.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext contet) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '설정',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: kIsWeb ? 20 : 20.r,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: kIsWeb ? 20 : 50.w),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: kIsWeb ? 10 : 10.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountSetting()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: kIsWeb ? 10 : 10.w),
                      Text(
                        "계정 관리",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 20 : 20.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_right_rounded, size: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountSetting extends StatefulWidget {
  @override
  State<AccountSetting> createState() => _AccountSetting();
}

class _AccountSetting extends State<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel>();
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '계정 관리',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: kIsWeb ? 20 : 20.r,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: kIsWeb ? 20 : 50.w),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: kIsWeb ? 10 : 10.h),
            GestureDetector(
              onTap: () {
                context.read<UserModel>().logout();
                // 탈퇴 api가 없어서 로그아웃으로 대체

                if (!context.mounted) return;

                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_2_outlined),
                      SizedBox(width: kIsWeb ? 10 : 10.w),
                      Text(
                        "회원 탈퇴",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: kIsWeb ? 20 : 20.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_right_rounded, size: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
