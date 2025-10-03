// lib/viewmodels/usage_data_viewmodel.dart

import 'dart:convert';
import 'dart:math'; // ✨ max 함수 사용을 위해 import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✨ 1. 패키지 import
import '../model/usage_event_info.dart';

class UsageDataViewModel extends ChangeNotifier {
  // ... (기존 변수들은 동일) ...
  static const _platform = MethodChannel('com.example.mili_second/usagestats');
  final _encoder = const JsonEncoder.withIndent('  ');

  String _status = '앱 사용 기록을 불러오는 중...';
  final List<Map<String, dynamic>> _jsonList = [];
  String _totalUsageTime = '계산 중...';
  String _sourceInfo = '기기 정보 로딩 중...';

  String get status => _status;
  List<Map<String, dynamic>> get jsonList => _jsonList;
  String get totalUsageTime => _totalUsageTime;
  JsonEncoder get encoder => _encoder;

  // ✨ 2. SharedPreferences 인스턴스를 저장할 변수
  late SharedPreferences _prefs;

  UsageDataViewModel() {
    // ViewModel이 생성될 때 데이터 로딩 시작
    initializeAndFetchData();
  }

  // ✨ 3. SharedPreferences 초기화 및 데이터 로딩을 함께 처리하는 함수
  Future<void> initializeAndFetchData() async {
    _prefs = await SharedPreferences.getInstance(); // SharedPreferences 인스턴스화
    await _initSourceInfo();
    await fetchNewUsageData(); // 기존 함수 대신 새로운 함수 호출
  }

  // ✨ 4. 마지막으로 저장된 타임스탬프를 불러오는 함수
  Future<int> _getLastFetchTimestamp() async {
    // 'last_fetch_timestamp' 키로 저장된 값을 불러옴. 만약 값이 없다면(최초 실행), 오늘 날짜의 0시를 반환
    final lastTimestamp = _prefs.getInt('last_fetch_timestamp');
    if (lastTimestamp == null) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    }
    return lastTimestamp;
  }

  // ✨ 5. 새로운 타임스탬프를 저장하는 함수
  Future<void> _saveLastFetchTimestamp(int timestamp) async {
    await _prefs.setInt('last_fetch_timestamp', timestamp);
  }

  // 기존 getTodaysUsage 함수를 대체할 새로운 데이터 fetch 함수
  Future<void> fetchNewUsageData() async {
    // 마지막으로 가져온 시점을 시작 시간으로 설정
    final startTime = DateTime.fromMillisecondsSinceEpoch(
      await _getLastFetchTimestamp(),
    );
    final endTime = DateTime.now();

    // 시작 시간과 종료 시간이 같거나 더 빠르면 실행할 필요 없음
    if (!endTime.isAfter(startTime)) {
      _status = '새로운 데이터가 없습니다. (최신 상태)';
      notifyListeners();
      return;
    }

    await _fetchAndProcessUsageData(startTime, endTime);
  }

  Future<void> _fetchAndProcessUsageData(
    DateTime startTime,
    DateTime endTime,
  ) async {
    _status = '새로운 데이터를 가져오는 중...';
    notifyListeners();

    try {
      final List<dynamic>? rawData = await _platform
          .invokeMethod<List<dynamic>>('getUsageStats', {
            'startTime': startTime.millisecondsSinceEpoch,
            'endTime': endTime.millisecondsSinceEpoch,
          });

      if (rawData != null && rawData.isNotEmpty) {
        final arguments = {'rawData': rawData, 'sourceInfo': _sourceInfo};
        final processedResult = await compute(
          processDataInBackground,
          arguments,
        );

        final List<Map<String, dynamic>> newJsonList =
            processedResult['jsonList'] ?? [];

        // ✨ 6. 기존 리스트에 새로 가져온 데이터를 추가 (누적)
        _jsonList.addAll(newJsonList);

        // TODO: 총 사용 시간 계산 로직을 누적 방식으로 변경해야 할 수 있음
        // 현재는 새로 가져온 데이터의 사용 시간만 표시
        _totalUsageTime = _formatDuration(
          processedResult['totalDuration'] ?? 0,
        );

        // ✨ 7. 새로 가져온 데이터 중 가장 마지막(최신) 시간을 찾아 저장
        final lastTimestamp = newJsonList
            .map((e) => e['timestamp'] as int)
            .reduce(max);
        await _saveLastFetchTimestamp(lastTimestamp);

        _status = '데이터 동기화 완료: ${DateTime.now().hour}:${DateTime.now().minute}';
      } else {
        _status = '새로운 사용 기록이 없습니다.';
        // ✨ 8. 새로운 데이터가 없더라도, 마지막으로 시도한 시간까지는 저장해서 불필요한 재호출 방지
        await _saveLastFetchTimestamp(endTime.millisecondsSinceEpoch);
      }
    } on PlatformException catch (e) {
      // ... (기존 에러 처리 로직 동일) ...
    }
    notifyListeners();
  }

  Future<void> _initSourceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _sourceInfo =
          '${androidInfo.manufacturer}-${androidInfo.model}-${androidInfo.version.release}';
    } catch (e) {
      _sourceInfo = '정보를 가져올 수 없음';
    }
    notifyListeners(); // 데이터 변경 후 View에 알림
  }

  String _formatDuration(int totalMilliseconds) {
    if (totalMilliseconds < 0) return "계산 오류";
    final duration = Duration(milliseconds: totalMilliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}시간 ${minutes.toString().padLeft(2, '0')}분 ${seconds.toString().padLeft(2, '0')}초';
  }
}
