import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../viewmodel/usage_data_viewmodel.dart'; // ViewModel import
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
              padding: const EdgeInsets.fromLTRB(5, 5, 15, 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  viewModel.status, // ViewModel의 데이터 사용
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isfront = !isfront;
                    });
                  },
                  child: Image.asset(
                    isfront
                        ? 'assets/icons/character/shoppingAddictType_front.png'
                        : 'assets/icons/character/shoppingAddictType_back.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "실시간 사용 현황",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '총 사용 시간',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            viewModel.totalUsageTime, // ViewModel의 데이터 사용
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '오늘 unlock',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "test", // ViewModel의 데이터 사용
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '평균 세션',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "test", // ViewModel의 데이터 사용
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("테스트 로그아웃"),
                        ),
                      ),
                    ],
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
