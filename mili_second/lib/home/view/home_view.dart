import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:milli_second/model/user_model.dart';
import 'package:provider/provider.dart';
import '../view_model/usage_data_view_model.dart'; // ViewModel import
import '../view_model/today_usage_stats_view_model.dart';
import '../model/today_usage_stats_model.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // secure storage can't web

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  bool isfront = true; // 카드 앞뒷면 구분
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  //final storage = FlutterSecureStorage();

  // 오늘의 사용 통계 데이터
  final TodayUsageStatsViewModel _todayUsageStatsViewModel = TodayUsageStatsViewModel();
  TodayUsageStatsModel? _todayStats;
  bool _isLoadingStats = true;
  bool _isRefreshing = false; // 새로고침 로딩 상태

  Future<void> _loadTodayUsageStats() async {
    final userModel = context.read<UserModel>();
    final stats = await _todayUsageStatsViewModel.fetchTodayUsageStats(userModel.userToken);

    if (mounted) {
      setState(() {
        _todayStats = stats;
        _isLoadingStats = false;
      });
    }
  }

  // 테스트 계정용 /test-account 엔드포인트 호출
  Future<void> _callTestAccountEndpoint() async {
    final userModel = context.read<UserModel>();
    final url = Uri.parse('${userModel.baseUrl}/usage/raw-data/test-account');
    final body = json.encode([]); // 빈 배열 전송

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userModel.userToken}',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('✅ 홈화면 새로고침: /test-account 호출 성공');
      } else {
        print('❌ 홈화면 새로고침: /test-account 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ 홈화면 새로고침: /test-account 호출 중 오류: $e');
    }
  }

  // 날짜 포맷팅 함수: "2025-10-28" -> "10/28 분석 기준"
  String _formatClassificationDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day} 분석 기준';
    } catch (e) {
      return '분석 기준';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 플립 애니메이션 컨트롤러 초기화
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initState에서는 context.read가 안전합니다.
      context.read<UserModel>().get_phonebti();
      _loadTodayUsageStats(); // API에서 오늘의 사용 통계 로드
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  // 새로고침 처리 함수 (웹/모바일 공통)
  Future<void> _handleRefresh() async {
    if (_isRefreshing) return; // 이미 새로고침 중이면 무시

    setState(() {
      _isRefreshing = true;
    });

    try {
      final userModel = context.read<UserModel>();

      // 웹뷰이고 테스트 유저일 경우에만 /test-account 호출
      if (kIsWeb) {
        final testUsers = ["testuser1", "testuser2", "testuser3"];
        if (testUsers.contains(userModel.userId)) {
          print("웹뷰 새로고침: 테스트 유저 감지. /test-account 호출 중...");
          await _callTestAccountEndpoint();
        }
      }

      // 데이터 새로고침
      await _loadTodayUsageStats();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
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
      body: Stack(
        children: [
          RefreshIndicator(
            // 모바일에서만 작동 (웹에서는 위의 새로고침 버튼 사용)
            onRefresh: _loadTodayUsageStats,
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
                    _isLoadingStats
                      ? '데이터 로딩 중...'
                      : '',
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
                child: Column(
                  children: [
                    // 분류 날짜 표시 (카드 상단에 고정)
                    if (userModel.userTypeDate != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: kIsWeb ? 8 : 8.h),
                        child: Text(
                          _formatClassificationDate(userModel.userTypeDate!),
                          style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: kIsWeb ? 11 : 11.r,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // 카드 플립 애니메이션
                    GestureDetector(
                      onTap: () {
                        if (userModel.userType == null) return;

                        // 애니메이션 시작
                        if (_flipController.status == AnimationStatus.completed) {
                          _flipController.reverse();
                        } else {
                          _flipController.forward();
                        }

                        setState(() {
                          isfront = !isfront;
                        });
                      },
                      child: AnimatedBuilder(
                        animation: _flipAnimation,
                        builder: (context, child) {
                          // 회전 각도 계산
                          double angle = _flipAnimation.value * 3.14159; // 180도 (π 라디안)

                          // 중간 지점에서 앞뒷면 전환 (90도 지점)
                          bool showFront = angle < (3.14159 / 2);

                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // 원근감 추가
                              ..rotateY(angle),
                            child: (userModel.userType == null)
                                // 1. userType이 null일 때 (로딩 중)
                                ? Container(
                                    // 이미지와 비슷한 높이를 주어 UI가 깨지지 않게 함
                                    height: 300.h, // 이 높이는 실제 이미지 높이에 맞게 조절하세요.
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  )
                                // 2. userType이 null이 아닐 때 (로딩 완료)
                                : showFront
                                ? Image.asset(
                                    'assets/icons/character/${userModel.userType}_front.png',
                                    fit: BoxFit.contain,
                                  )
                                : Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..rotateY(3.14159), // 뒷면은 Y축으로 180도 회전
                                    child: Image.asset(
                                      'assets/icons/character/${userModel.userType}_back.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: kIsWeb ? 5 : 15.h),
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
                                _isLoadingStats
                                  ? '로딩 중...'
                                  : (_todayStats?.formattedUsageTime ?? '0분'),
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
                                _isLoadingStats
                                  ? '로딩 중...'
                                  : (_todayStats?.formattedPickupCount ?? '0회'),
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
          // 웹에서만 오른쪽 위에 새로고침 버튼 표시
          if (kIsWeb)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _handleRefresh,
                tooltip: '새로고침',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ),
          // 새로고침 로딩 오버레이
          if (_isRefreshing)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(height: kIsWeb ? 16 : 16.h),
                    Text(
                      '데이터를 불러오는 중...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: kIsWeb ? 16 : 16.r,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
