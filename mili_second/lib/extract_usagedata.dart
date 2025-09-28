import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart'; // ✨ 1. 패키지 import

class ExtractUsageData extends StatefulWidget {
  const ExtractUsageData({Key? key}) : super(key: key);

  @override
  _ExtractUsageDataState createState() => _ExtractUsageDataState();
}

class _ExtractUsageDataState extends State<ExtractUsageData> {
  static const platform = MethodChannel('com.example.mili_second/usagestats');

  String _status = '오늘의 사용 시간을 불러오는 중...';
  List<Map<String, dynamic>> _jsonList = [];
  String _totalUsageTime = '계산 중...';
  final JsonEncoder _encoder = const JsonEncoder.withIndent('  ');

  // ✨ 2. 기기 정보를 저장할 변수 추가
  String _sourceInfo = '기기 정보 로딩 중...';

  @override
  void initState() {
    super.initState();
    // 화면 시작 시 기기 정보와 사용 기록을 모두 가져옴
    _initializeData();
  }

  // ✨ 3. 기기 정보와 사용 기록을 순차적으로 가져오는 함수 추가
  Future<void> _initializeData() async {
    await _initSourceInfo(); // 기기 정보를 먼저 가져오고
    await _getTodaysUsage(); // 그 다음에 사용 기록을 가져옴
  }

  // ✨ 4. 기기 정보를 가져와 _sourceInfo 변수에 저장하는 함수 추가
  Future<void> _initSourceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      // 안드로이드 기기 정보 가져오기
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final info =
          '${androidInfo.manufacturer}-${androidInfo.model}-${androidInfo.version.release}';
      if (mounted) {
        setState(() {
          _sourceInfo = info;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _sourceInfo = '정보를 가져올 수 없음';
        });
      }
    }
  }

  Future<void> _getTodaysUsage() async {
    final now = DateTime.now();
    final startTime = DateTime(now.year, now.month, now.day);
    final endTime = now;
    await _fetchAndProcessUsageData(startTime, endTime);
  }

  Future<void> _fetchAndProcessUsageData(
    DateTime startTime,
    DateTime endTime,
  ) async {
    if (mounted) {
      setState(() {
        _status = '데이터를 새로고침하는 중...';
        _totalUsageTime = '계산 중...';
        _jsonList = [];
      });
    }

    try {
      final List<dynamic>? rawData = await platform
          .invokeMethod<List<dynamic>>('getUsageStats', {
            'startTime': startTime.millisecondsSinceEpoch,
            'endTime': endTime.millisecondsSinceEpoch,
          });

      if (rawData != null && mounted) {
        // ✨ 5. Isolate 함수에 기기 정보를 인자로 넘겨주기
        final arguments = {'rawData': rawData, 'sourceInfo': _sourceInfo};
        final processedResult = await compute(
          _processDataInBackground,
          arguments,
        );

        setState(() {
          _status =
              '최근 새로고침: ${TimeOfDay.fromDateTime(DateTime.now()).format(context)}';
          _jsonList = processedResult['jsonList'] ?? [];
          _totalUsageTime = _formatDuration(
            processedResult['totalDuration'] ?? 0,
          );
        });
      } else if (mounted) {
        setState(() {
          _status = '데이터를 가져오지 못했습니다.';
        });
      }
    } on PlatformException catch (e) {
      if (!mounted) return;
      if (e.code == "PERMISSION_DENIED") {
        setState(() {
          _status = '권한이 필요합니다. 설정 화면에서 권한을 허용해주세요.';
        });
      } else {
        setState(() {
          _status = '네이티브 코드 호출 실패: ${e.message}';
        });
      }
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

  @override
  Widget build(BuildContext context) {
    // ... UI 코드는 이전과 동일하므로 생략 ...
    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 휴대폰 사용 시간')),
      body: RefreshIndicator(
        onRefresh: _getTodaysUsage,
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
                    _totalUsageTime,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _status,
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
                  itemCount: _jsonList.length,
                  itemBuilder: (context, index) {
                    final item = _jsonList[index];
                    final itemJsonString = _encoder.convert(item);
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

// ✨ 6. Isolate 함수가 Map 형태의 인자를 받도록 수정
Map<String, dynamic> _processDataInBackground(Map<String, dynamic> arguments) {
  // 인자에서 데이터 분리
  final List<dynamic> rawData = arguments['rawData'];
  final String sourceInfo = arguments['sourceInfo'];

  List<UsageEventInfo> events = rawData
      .map((item) => UsageEventInfo.fromMap(item as Map<dynamic, dynamic>))
      .toList();
  events.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

  int totalDurationMs = 0;
  Map<String, UsageEventInfo> lastResumeEvent = {};

  for (var event in events) {
    switch (event.eventType) {
      case 1:
        event.eventTypeName = 'MOVE_TO_FOREGROUND';
        break;
      case 2:
        event.eventTypeName = 'MOVE_TO_BACKGROUND';
        break;
      default:
        event.eventTypeName = 'OTHER';
        break;
    }

    if (event.eventType == 1) {
      lastResumeEvent[event.packageName] = event;
    }
    if (event.eventType == 2) {
      if (lastResumeEvent.containsKey(event.packageName)) {
        UsageEventInfo resumeEvent = lastResumeEvent[event.packageName]!;
        int duration = event.timeStamp - resumeEvent.timeStamp;
        if (duration > 0) totalDurationMs += duration;
        lastResumeEvent.remove(event.packageName);
      }
    }
  }

  List<Map<String, dynamic>> jsonList = events.map((event) {
    return {
      "subject_id": 1,
      "timestamp": event.timeStamp,
      "source_type": "PHONE",
      "source_info": sourceInfo, // ✨ 7. 고정값 대신 변수 사용
      "package_name": event.packageName,
      "name": event.name,
      "is_system_app": event.isSystemApp,
      "is_updated_system_app": event.isUpdatedSystemApp,
      "type": event.eventTypeName,
    };
  }).toList();

  return {'jsonList': jsonList, 'totalDuration': totalDurationMs};
}

class UsageEventInfo {
  final String packageName;
  final int eventType;
  final int timeStamp;
  String eventTypeName = 'OTHER';

  final String name;
  final bool isSystemApp;
  final bool isUpdatedSystemApp;

  UsageEventInfo({
    required this.packageName,
    required this.eventType,
    required this.timeStamp,
    this.name = '',
    this.isSystemApp = false,
    this.isUpdatedSystemApp = false,
  });

  factory UsageEventInfo.fromMap(Map<dynamic, dynamic> map) {
    return UsageEventInfo(
      packageName: map['packageName'] ?? '',
      eventType: map['eventType'] ?? -1,
      timeStamp: map['timeStamp'] ?? 0,
      name: map['name'] ?? map['packageName'] ?? '',
      isSystemApp: map['isSystemApp'] ?? false,
      isUpdatedSystemApp: map['isUpdatedSystemApp'] ?? false,
    );
  }
}
