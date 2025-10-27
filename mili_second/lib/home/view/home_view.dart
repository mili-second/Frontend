import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mili_second/model/user_model.dart';
import 'package:provider/provider.dart';
import '../view_model/usage_data_view_model.dart'; // ViewModel import
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // secure storage can't web

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isfront = true; // 카드 앞뒷면 구분

  //final storage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initState에서는 context.read가 안전합니다.
      context.read<UserModel>().get_phonebti();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel의 데이터가 변경될 때마다 이 위젯을 다시 빌드하도록 설정
    final viewModel = context.watch<UsageDataViewModel>();
    final userModel = context.watch<UserModel>();

    final String imageBasePath = kIsWeb
        ? 'icons/character/' // 👈 웹(Web)일 때 경로
        : 'assets/icons/character/'; // 👈 모바일(Mobile)일 때 경로

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
                  left: kIsWeb ? 55 : 20.w,
                  right: kIsWeb ? 55 : 20.w,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (userModel.userType == null) return;
                    setState(() {
                      isfront = !isfront;
                    });
                  },
                  child: (userModel.userType == null)
                      // 1. userType이 null일 때 (로딩 중)
                      ? Container(
                          // 이미지와 비슷한 높이를 주어 UI가 깨지지 않게 함
                          height: 300.h, // 이 높이는 실제 이미지 높이에 맞게 조절하세요.
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )
                      // 2. userType이 null이 아닐 때 (로딩 완료)
                      : isfront
                      ? Image.asset(
                          'assets/icons/character/${userModel.userType}_front.png',
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          'assets/icons/character/${userModel.userType}_back.png',
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
            SizedBox(height: kIsWeb ? 5 : 20.h),
            Padding(
              padding: kIsWeb
                  ? EdgeInsets.fromLTRB(55, 0, 55, 0)
                  : EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
              child: Center(
                child: Container(
                  //width: kIsWeb ? 275 : 275.w,
                  //height: kIsWeb ? 90 : 90.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A78EB).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.all(
                      Radius.circular(kIsWeb ? 10.0 : 10.0.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(kIsWeb ? 10.0 : 10.0.h),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '오늘 unlock 횟수',
                                style: TextStyle(
                                  fontSize: kIsWeb ? 15 : 15.r,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              Text(
                                viewModel.totalUnlockCount, // ViewModel의 데이터 사용
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: kIsWeb ? 15 : 15.r,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SizedBox(
                        //   width: kIsWeb ? 290 : 290.w,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         '평균 세션',
                        //         style: TextStyle(
                        //           fontSize: kIsWeb ? 15 : 15.r,
                        //           color: Color(0xFFFFFFFF),
                        //         ),
                        //       ),
                        //       Text(
                        //         "test", // ViewModel의 데이터 사용
                        //         style: TextStyle(
                        //           color: Color(0xFFFFFFFF),
                        //           fontSize: kIsWeb ? 15 : 15.r,
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

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
