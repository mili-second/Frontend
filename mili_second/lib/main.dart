// lib/main.dart (FIXED)

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
// 'views/auth_wrapper.dart'가 맞을 수 있습니다.
import 'package:milli_second/auth_wrapper.dart';
import 'package:milli_second/model/user_model.dart';
import 'package:provider/provider.dart';
// 'viewmodels/usage_data_viewmodel.dart'가 맞을 수 있습니다.
import 'home/view_model/usage_data_view_model.dart';
import 'package:milli_second/profile/view_model/profile_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProxyProvider<UserModel, UsageDataViewModel>(
          create: (context) => UsageDataViewModel(context.read<UserModel>()),
          update: (context, userModel, previousViewModel) =>
              previousViewModel!..updateUserModel(userModel),
        ),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const MyApp(), // 👈 MultiProvider가 MyApp을 감쌈
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit이 MaterialApp을 감싸도록 설정
    return ScreenUtilInit(
      designSize: const Size(412, 917), // 👈 본인 디자인 사이즈로 수정
      minTextAdapt: true,
      splitScreenMode: true,

      // ✨ 1. builder가 'child' (AuthWrapper)를 받습니다.
      builder: (context, child) {
        // ✨ 2. (웹 경우) FlutterWebFrame이 MaterialApp을 감쌉니다.
        if (kIsWeb) {
          return FlutterWebFrame(
            maximumSize: const Size(412, 917),
            enabled: kIsWeb,
            builder: (context) {
              return MaterialApp(
                title: 'Milli Second',
                color: const Color(0xFFFFFFFF),
                debugShowCheckedModeBanner: false,
                home: child, // 👈 3. (웹) child(AuthWrapper)를 home으로 사용
              );
            },
          );
        }

        // ✨ 4. (모바일 경우) 그냥 MaterialApp을 반환
        return MaterialApp(
          title: 'Milli Second',
          color: const Color(0xFFFFFFFF),
          debugShowCheckedModeBanner: false,
          home: child, // 👈 5. (모바일) child(AuthWrapper)를 home으로 사용
        );
      },

      // ✨ 6. (핵심!) AuthWrapper는 ScreenUtilInit의 "child"로 단 한번만 정의됩니다.
      // 이 위젯이 'builder'의 'child' 매개변수로 전달됩니다.
      child: const AuthWrapper(),
    );
  }
}
