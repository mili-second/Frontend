// viewmodel에서 가공한 데이터를 가져와서 화면에 뿌려줌

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart'; // ✨ 1. 패키지 import

import 'package:provider/provider.dart';
import '../viewmodel/usage_data_viewmodel.dart'; // ViewModel import

class UsageDataScreen extends StatelessWidget {
  const UsageDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModel의 데이터가 변경될 때마다 이 위젯을 다시 빌드하도록 설정
    final viewModel = context.watch<UsageDataViewModel>();

    return Scaffold(
      body: RefreshIndicator(
        // 새로고침 시 ViewModel의 함수 호출
        onRefresh: () => context.read<UsageDataViewModel>().fetchNewUsageData(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    '오늘 하루 총 사용 시간',
                    style: TextStyle(fontSize: 22, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.totalUsageTime, // ViewModel의 데이터 사용
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.status, // ViewModel의 데이터 사용
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    '생성된 JSON 데이터',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: viewModel.jsonList.length, // ViewModel의 데이터 사용
                  itemBuilder: (context, index) {
                    final item = viewModel.jsonList[index];
                    final itemJsonString = viewModel.encoder.convert(item);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        itemJsonString,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
