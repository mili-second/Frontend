import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../setting/view/app_information.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Row(
            children: [
              SizedBox(width: kIsWeb ? 85 : 85.w),
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
        child: Column(children: []),
      ),
    );
  }
}
