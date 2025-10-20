import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../main_view.dart';
import 'login_view.dart'; // (예시) LoginView가 있는 경로

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // initState가 끝난 직후, 딱 한 번만 자동 로그인 검사 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserModel>().checkAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    // UserModel의 상태가 바뀔 때마다 build 함수가 다시 실행됨
    final userModel = context.watch<UserModel>();

    print("in auth_wrapper");

    // 1. 자동 로그인 확인 중... (로딩 중)
    if (userModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 2. 로그인 됨
    if (userModel.isLoggedIn) {
      return MainView(key: UniqueKey());
    }
    // 3. 로그인 안 됨
    else {
      // (주의!) SignInView()가 아닌 LoginView()가 기본값이 되어야 합니다.
      return LoginView(key: UniqueKey());
    }
  }
}
