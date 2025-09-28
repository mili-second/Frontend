import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'header_view.dart';
import 'home/view/home_view.dart';
import 'analyze/view/analyze_view.dart';
import 'insight/view/insight_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    AnalyzeView(),
    InsightView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: HeaderView(
            userName: 'Mili',
            userProfileImage: 'assets/icons/profile_default.png',
          ), // 사용자 정보 - 보내기
          toolbarHeight: 125.h,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(height: 1.h, color: Color(0xFFCDCBCB)),
          ),
        ),
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 1, color: const Color(0xFFCDCBCB)),
            SizedBox(
              height: 160.h,
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    label: '',
                    icon: Column(
                      children: [
                        _selectedIndex == 0
                            ? Image.asset(
                                'assets/icons/home_blue.png',
                                width: 45.w,
                                height: 45.h,
                              )
                            : Image.asset(
                                'assets/icons/home_gray.png',
                                width: 45.w,
                                height: 45.h,
                              ),
                        SizedBox(height: 15.h),
                        _selectedIndex == 0
                            ? Text(
                                '홈',
                                style: TextStyle(
                                  color: Color(0xFF007BFF),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : Text(
                                '홈',
                                style: TextStyle(
                                  color: Color(0xFF555555),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ],
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: Column(
                      children: [
                        _selectedIndex == 1
                            ? Image.asset(
                                'assets/icons/analyze_blue.png',
                                width: 60.w,
                                height: 60.h,
                              )
                            : Image.asset(
                                'assets/icons/analyze_gray.png',
                                width: 60.w,
                                height: 60.h,
                              ),
                        SizedBox(height: 5.h),
                        _selectedIndex == 1
                            ? Text(
                                '분석',
                                style: TextStyle(
                                  color: Color(0xFF007BFF),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : Text(
                                '분석',
                                style: TextStyle(
                                  color: Color(0xFF555555),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ],
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: Column(
                      children: [
                        _selectedIndex == 2
                            ? Image.asset(
                                'assets/icons/insight_blue.png',
                                width: 60.w,
                                height: 60.h,
                              )
                            : Image.asset(
                                'assets/icons/insight_gray.png',
                                width: 60.w,
                                height: 60.h,
                              ),
                        SizedBox(height: 5.h),
                        _selectedIndex == 2
                            ? Text(
                                '인사이트',
                                style: TextStyle(
                                  color: Color(0xFF007BFF),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : Text(
                                '인사이트',
                                style: TextStyle(
                                  color: Color(0xFF555555),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
