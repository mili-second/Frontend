// lib/viewmodels/usage_data_viewmodel.dart

import 'dart:convert';
import 'dart:math'; // ✨ max 함수 사용을 위해 import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:milli_second/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✨ 1. 패키지 import
import '../model/usage_event_info.dart';
import 'package:http/http.dart' as http;

class UsageDataViewModel extends ChangeNotifier {
  // ✨ 1. UserModel을 저장할 변수
  UserModel _userModel;

  // ✨ 2. 생성자에서 UserModel을 받도록 수정
  UsageDataViewModel(this._userModel) {
    if (!kIsWeb) {
      _platform = const MethodChannel('com.example.milli_second/usagestats');
    }
    // ViewModel이 생성될 때 데이터 로딩 시작
    initializeAndFetchData();
  }

  // ✨ 3. UserModel이 변경될 때(로그인/로그아웃) main.dart에서 호출할 함수
  void updateUserModel(UserModel newUserModel) {
    _userModel = newUserModel;

    // (중요!) 유저가 바뀌었으니(로그아웃 등) 기존 데이터를 초기화합니다.
    _jsonList.clear();
    _totalDurationMs = 0;
    _totalUnlockCountValue = 0;

    // 만약 새 유저로 로그인 시 바로 데이터를 불러와야 한다면,
    // 여기서 fetchNewUsageData(); 같은 함수를 호출할 수 있습니다.

    notifyListeners(); // ViewModel 상태 변경 알림
  }

  //static const _platform = MethodChannel('com.example.milli_second/usagestats');
  late final MethodChannel _platform;
  final _encoder = const JsonEncoder.withIndent('  ');

  // final _serverUrl = Uri.parse(
  //   'https://webhook.site/9f4be958-c34a-4743-ae47-90d2a3922ef0',
  // );

  final _serverUrl = Uri.parse(
    'https://api.yolang.shop/usage/raw-data/test-account',
  );

  String _status = '앱 사용 기록을 불러오는 중...';
  final List<Map<String, dynamic>> _jsonList = [];
  String _totalUsageTime = '계산 중...';
  String _sourceInfo = '기기 정보 로딩 중...';
  String _totalUnlockCount = '계산 중...';

  String get status => _status;

  List<Map<String, dynamic>> get jsonList => _jsonList;
  String get totalUsageTime => _totalUsageTime;
  String get totalUnlockCount => _totalUnlockCount;
  JsonEncoder get encoder => _encoder;

  int _totalDurationMs = 0;
  int _totalUnlockCountValue = 0;

  // ✨ 2. SharedPreferences 인스턴스를 저장할 변수
  late SharedPreferences _prefs;

  Future<void> _sendDataToServer(List<Map<String, dynamic>> newData) async {
    final currentUserId = _userModel.userId;

    if (currentUserId == null) {
      print('로그인되지 않아 서버 전송을 스킵합니다.');
      return;
    }

    // 보낼 데이터가 없으면 함수 종료
    if (newData.isEmpty) {
      print('서버로 보낼 새로운 데이터가 없습니다.');
      return;
    }

    // final body = json.encode({
    //   'user_id': currentUserId,
    //   'source_info': _sourceInfo, // 기기 정보
    //   'timestamp': DateTime.now().toIso8601String(), // 전송 시간
    //   'event_count': newData.length, // 이벤트 개수
    //   'events': newData, // 실제 이벤트 데이터 목록
    // });

    final body = json.encode(newData);

    try {
      print('${newData.length}개의 새로운 데이터를 서버로 전송합니다...');
      final response = await http.post(
        _serverUrl,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200) {
        print('✅ 서버 전송 성공!');
      } else {
        print('❌ 서버 전송 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('🔥 서버 전송 중 오류 발생: $e');
    }
  }

  // ✨ 3. SharedPreferences 초기화 및 데이터 로딩을 함께 처리하는 함수
  Future<void> initializeAndFetchData() async {
    _prefs = await SharedPreferences.getInstance(); // SharedPreferences 인스턴스화

    // 오늘 날짜를 'YYYY-MM-DD' 형식의 문자열로 만듭니다.
    final today = DateTime.now();
    final todayDateString = "${today.year}-${today.month}-${today.day}";

    // 저장된 날짜와 누적 시간을 불러옵니다.
    final lastDateString = _prefs.getString('last_duration_date');
    final savedDuration = _prefs.getInt('total_duration_ms') ?? 0;

    if (lastDateString == todayDateString) {
      // 저장된 날짜가 오늘이면, 저장된 시간을 그대로 사용
      _totalDurationMs = savedDuration;
      _totalUnlockCountValue = _prefs.getInt('total_unlock_count') ?? 0;
    } else {
      // 저장된 날짜가 어제거나 그 이전이면, 누적 시간 초기화
      _totalDurationMs = 0;
      _totalUnlockCountValue = 0;
      // 오늘 날짜로 새로 저장 (시간은 0으로)
      await _prefs.setString('last_duration_date', todayDateString);
      await _prefs.setInt('total_duration_ms', 0);
      await _prefs.setInt('total_unlock_count', 0);
    }

    // UI에 표시될 포맷된 시간 업데이트
    _totalUsageTime = _formatDuration(_totalDurationMs);
    _totalUnlockCount = "$_totalUnlockCountValue회";

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
    return lastTimestamp + 1;
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

    if (kIsWeb) {
      _status = '';
      _totalUsageTime = 'N/A (웹)';
      _totalUnlockCount = 'N/A (웹)';
      notifyListeners();
      return; // 웹에서는 여기서 함수 종료
    }

    try {
      final List<dynamic>? rawData = await _platform
          .invokeMethod<List<dynamic>>('getUsageStats', {
            'startTime': startTime.millisecondsSinceEpoch,
            'endTime': endTime.millisecondsSinceEpoch,
          });

      final String? currentUserId = _userModel.userId;

      if (rawData != null && rawData.isNotEmpty) {
        final arguments = {
          'rawData': rawData,
          'sourceInfo': _sourceInfo,
          'userId': currentUserId,
        };
        final processedResult = await compute(
          processDataInBackground,
          arguments,
        );

        final List<Map<String, dynamic>> newJsonList =
            processedResult['jsonList'] ?? [];

        // 새로 가져온 데이터의 사용 시간
        final newDurationMs =
            (processedResult['totalDuration'] as num?)?.toInt() ?? 0;
        final lastTimestamp =
            (processedResult['lastTimestamp'] as num?)?.toInt() ?? 0;

        final newUnlockCount =
            (processedResult['unlockCount'] as num?)?.toInt() ?? 0;
        // ✨ 3. 누적 시간 계산 로직
        final today = DateTime.now();
        final todayDateString = "${today.year}-${today.month}-${today.day}";
        final lastDateString = _prefs.getString('last_duration_date');

        if (lastDateString == todayDateString) {
          // 마지막으로 계산한 날짜가 오늘이면, 기존 시간에 새로운 시간 "누적"
          _totalDurationMs += newDurationMs;
          _totalUnlockCountValue += newUnlockCount;
        } else {
          // 날짜가 바뀌었으면 (자정 지남), 새로 가져온 시간으로 "초기화"
          _totalDurationMs = newDurationMs;
          _totalUnlockCountValue = newUnlockCount;
        }

        // ✨ 4. 계산된 누적 시간과 오늘 날짜를 기기에 저장
        await _prefs.setString('last_duration_date', todayDateString);
        await _prefs.setInt('total_duration_ms', _totalDurationMs);
        await _prefs.setInt('total_unlock_count', _totalUnlockCountValue);
        // ✨ 5. UI에 표시될 문자열 업데이트
        _totalUsageTime = _formatDuration(_totalDurationMs);
        _totalUnlockCount = "$_totalUnlockCountValue회";

        await _sendDataToServer(newJsonList);

        // ✨ 6. 기존 리스트에 새로 가져온 데이터를 추가 (누적)
        _jsonList.addAll(newJsonList);

        // ✨ 7. 새로 가져온 데이터 중 가장 마지막(최신) 시간을 찾아 저장
        // final lastTimestamp = newJsonList
        //     .map((e) => e['timestamp'] as int)
        //     .reduce(max);

        // await _saveLastFetchTimestamp(lastTimestamp);
        if (lastTimestamp > 0) {
          await _saveLastFetchTimestamp(lastTimestamp);
        } else {
          await _saveLastFetchTimestamp(endTime.millisecondsSinceEpoch);
        }

        _status = '데이터 동기화 완료: ${DateTime.now().hour}:${DateTime.now().minute}';
      } else {
        _status = '새로운 사용 기록이 없습니다.';
        // ✨ 8. 새로운 데이터가 없더라도, 마지막으로 시도한 시간까지는 저장해서 불필요한 재호출 방지
        await _saveLastFetchTimestamp(endTime.millisecondsSinceEpoch);
      }
    } on PlatformException catch (e) {
      _status = '오류: ${e.message}';
    }
    notifyListeners();
  }

  Future<void> _initSourceInfo() async {
    if (kIsWeb) {
      // device_info_plus는 웹도 지원합니다! WebBrowserInfo를 가져올 수 있습니다.
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      try {
        WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
        _sourceInfo = webInfo.userAgent ?? 'Web Browser'; // 예시: 브라우저 UserAgent
      } catch (e) {
        _sourceInfo = 'Web Browser (정보 없음)';
      }
    } else {
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
