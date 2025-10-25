import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mili_second/model/user_model.dart';
import 'package:provider/provider.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: kIsWeb ? 8.0 : 8.h,
          left: kIsWeb ? 20 : 20.w,
          right: kIsWeb ? 20 : 20.w,
        ),
        child: SizedBox(
          width: kIsWeb ? 500 : 500.w,
          height: kIsWeb ? 600 : 600.w,
          child: Column(
            children: [
              Container(
                width: kIsWeb ? 500 : 500.w,
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    'assets/icons/cancel.png',
                    width: kIsWeb ? 40 : 40.w,
                    height: kIsWeb ? 40 : 40.h,
                  ),
                ),
              ),
              SizedBox(height: kIsWeb ? 20 : 20.h),
              SizedBox(
                width: kIsWeb ? 350 : 350.w,
                child: Row(
                  children: [
                    Text(
                      '탈퇴 시',
                      style: TextStyle(
                        color: Color(0xFF007BFF),
                        fontSize: kIsWeb ? 32 : 32.r,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' 아래 정보가',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: kIsWeb ? 32 : 32.r,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: kIsWeb ? 350 : 350.w,
                child: Row(
                  children: [
                    Text(
                      '모두 사라져요.',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: kIsWeb ? 32 : 32.r,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // 앱 관련 이미지 넣을 예정
              //SizedBox(height: kIsWeb ? 400 : 400.h),
              SizedBox(
                width: kIsWeb ? 350 : 350.w,
                child: Row(
                  children: [
                    SizedBox(width: kIsWeb ? 5 : 5.w),
                    Text(
                      '그래도 탈퇴하시겠어요?',
                      style: TextStyle(
                        color: Color(0xFF007BFF),
                        fontSize: kIsWeb ? 20 : 20.r,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kIsWeb ? 10 : 10.h),
              GestureDetector(
                onTap: () {
                  // 회원 탈퇴 로직
                  context.read<UserModel>().logout();
                  // 탈퇴 api가 없어서 로그아웃으로 대체

                  if (!context.mounted) return;

                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Container(
                  width: kIsWeb ? 350 : 350.w,
                  height: kIsWeb ? 50 : 50.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
                  ),
                  child: Text(
                    '회원 탈퇴하기',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: kIsWeb ? 20 : 20.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
