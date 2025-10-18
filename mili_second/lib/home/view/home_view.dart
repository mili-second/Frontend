import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../viewmodel/usage_data_viewmodel.dart'; // ViewModel import
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mili_second/login_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isfront = true;

  final storage = FlutterSecureStorage();

  Future<void> test_logout() async {
    print("logout");
    await storage.delete(key: "token");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    test_logout();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel의 데이터가 변경될 때마다 이 위젯을 다시 빌드하도록 설정
    final viewModel = context.watch<UsageDataViewModel>();

    return Scaffold(
      body: RefreshIndicator(
        // 새로고침 시 ViewModel의 함수 호출
        onRefresh: () => context.read<UsageDataViewModel>().fetchNewUsageData(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: kIsWeb
                  ? EdgeInsets.fromLTRB(5, 5, 10, 5)
                  : EdgeInsets.fromLTRB(5.w, 5.h, 10.w, 5.h),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: kIsWeb ? 20 : 20.h,
                  child: Text(
                    viewModel.status, // ViewModel의 데이터 사용
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: kIsWeb ? 14 : 14.r,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: kIsWeb ? 45 : 45.w,
                  right: kIsWeb ? 45 : 45.w,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isfront = !isfront;
                    });
                  },
                  child: isfront
                      ? SizedBox(
                          height: kIsWeb ? 0.5 : 0.5.h,
                          child: Image.asset(
                            'assets/icons/character/shoppingAddictType_front.png',
                            fit: BoxFit.contain,
                          ),
                        )
                      : SizedBox(
                          height: kIsWeb ? 0.5 : 0.5.h,
                          child: Image.asset(
                            'assets/icons/character/shoppingAddictType_back.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: kIsWeb
                  ? EdgeInsets.fromLTRB(45, 0, 45, 0)
                  : EdgeInsets.fromLTRB(45.w, 0, 45.w, 0),
              child: Center(
                child: Container(
                  width: kIsWeb ? 0.4 : 0.4.w,
                  height: kIsWeb ? 125 : 125.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A78EB).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.all(
                      Radius.circular(kIsWeb ? 10.0 : 10.0.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: kIsWeb ? 8.0 : 8.0.h,
                      left: kIsWeb ? 8 : 8.h,
                      right: kIsWeb ? 8 : 8.h,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "실시간 사용 현황",
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: kIsWeb ? 17 : 17.r,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        SizedBox(height: kIsWeb ? 5 : 5.h),

                        SizedBox(
                          width: kIsWeb ? 290 : 290.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '총 사용 시간',
                                style: TextStyle(
                                  fontSize: kIsWeb ? 15 : 15.r,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              Text(
                                viewModel.totalUsageTime, // ViewModel의 데이터 사용
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: kIsWeb ? 15 : 15.r,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: kIsWeb ? 290 : 290.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '오늘 unlock',
                                style: TextStyle(
                                  fontSize: kIsWeb ? 15 : 15.r,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              Text(
                                "test", // ViewModel의 데이터 사용
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: kIsWeb ? 15 : 15.r,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: kIsWeb ? 290 : 290.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '평균 세션',
                                style: TextStyle(
                                  fontSize: kIsWeb ? 15 : 15.r,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              Text(
                                "test", // ViewModel의 데이터 사용
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: kIsWeb ? 15 : 15.r,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Center(
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       test_logout();

                        //       // 현재까지의 모든 페이지 기록을 삭제하고 LoginView로 이동합니다.
                        //       Navigator.pushAndRemoveUntil(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => LoginView(),
                        //         ),
                        //         (route) => false, // false를 반환하면 이전 모든 라우트를 제거합니다.
                        //       );
                        //     },
                        //     child: Text("테스트 로그아웃"),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
