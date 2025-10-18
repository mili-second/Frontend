// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:mili_second/login_view.dart';
import 'package:provider/provider.dart'; // 1. provider import
import 'home/viewmodel/usage_data_viewmodel.dart'; // 2. ViewModel import (경로는 실제 위치에 맞게 수정)

void main() {
  // 3. runApp에 Provider를 추가하여 앱 전체를 감쌉니다.
  runApp(
    ChangeNotifierProvider(
      create: (context) => UsageDataViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return FlutterWebFrame(
        maximumSize: Size(412, 917),
        enabled: kIsWeb,
        builder: (context) {
          return MaterialApp(
            home: LoginView(), // login부터
            color: Color(0xFFFFFFFF),
          );
        },
      );
    } else {
      return ScreenUtilInit(
        designSize: Size(412, 917),
        builder: (_, child) => MaterialApp(
          home: LoginView(), // login부터
          color: Color(0xFFFFFFFF),
        ),
      );
    }
  }
}
