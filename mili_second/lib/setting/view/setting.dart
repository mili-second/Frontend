import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Setting extends StatelessWidget {
  final String userNickName;
  const Setting({super.key, required this.userNickName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Row(
            children: [
              SizedBox(width: kIsWeb ? 80 : 80.w),
              Text(
                '설정',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: kIsWeb ? 20 : 20.r,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: kIsWeb ? 20 : 20.w),
            ],
          ),
        ),
        toolbarHeight: kIsWeb ? 100 : 100.h,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kIsWeb ? 1 : 1.h),
          child: Container(height: kIsWeb ? 1 : 1.h, color: Color(0xFFCDCBCB)),
        ),
      ),
    );
  }
}
