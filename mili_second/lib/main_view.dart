import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'header_view.dart';
import 'footer_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: HeaderView(
            userName: 'Mili',
            userProfileImage: 'profile_default.png',
          ), // 사용자 정보 - 이름 (정보가 없을때 'Mili')
          toolbarHeight: 125.h,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(height: 1, color: Color(0xFFCDCBCB)),
          ),
        ),
        body: Center(),
      ),
    );
  }
}
