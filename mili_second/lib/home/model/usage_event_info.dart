// 데이터 모델

// lib/models/usage_event_info.dart

import 'package:flutter/foundation.dart';
import 'dart:math';

import 'package:mili_second/model/user_model.dart';

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

// 이벤트 타입 <-> 문자열 매핑 Map
const Map<int, String> _eventTypeMap = {
  1: 'MOVE_TO_FOREGROUND',
  2: 'MOVE_TO_BACKGROUND',
  15: 'SCREEN_INTERACTIVE',
  16: 'SCREEN_NON_INTERACTIVE',
  // 나중에 다른 숫자가 추가되어도 여기에만 추가하면 됨
};

// 'OTHER'에 대한 기본값
const String _defaultEventType = 'OTHER';

// 백그라운드에서 데이터를 처리하는 함수
Map<String, dynamic> processDataInBackground(Map<String, dynamic> arguments) {
  final List<dynamic> rawData = arguments['rawData'];
  final String sourceInfo = arguments['sourceInfo'];
  final String? userId = arguments['userId'] as String?; // provider 구독 불가능
  final String subjectId = userId ?? "unknown"; // userId가 null이면 "unknown"을 사용

  List<UsageEventInfo> events = rawData
      .map((item) => UsageEventInfo.fromMap(item as Map<dynamic, dynamic>))
      .toList();
  events.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

  // 필터링 전 원본데이터 기준으로 last timestamp 저장
  final int lastTimestamp = events.isNotEmpty
      ? events.map((e) => e.timeStamp).reduce(max)
      : 0;

  int totalDurationMs = 0;
  int unlockCount = 0;
  Map<String, UsageEventInfo> lastResumeEvent = {};

  for (var event in events) {
    // _eventTypeMap에 event.eventType 키가 있으면 해당 값을,
    // 없으면(null이면) _defaultEventType('OTHER')을 사용합니다.
    event.eventTypeName = _eventTypeMap[event.eventType] ?? _defaultEventType;
    if (event.eventType == 15) {
      unlockCount++;
    }
    if (event.eventType == 1) {
      // MOVE_TO_FOREGROUND
      lastResumeEvent[event.packageName] = event;
    }
    if (event.eventType == 2) {
      // MOVE_TO_BACKGROUND
      if (lastResumeEvent.containsKey(event.packageName)) {
        UsageEventInfo resumeEvent = lastResumeEvent[event.packageName]!;
        int duration = event.timeStamp - resumeEvent.timeStamp;
        if (duration > 0) totalDurationMs += duration;
        lastResumeEvent.remove(event.packageName);
      }
    }
  }

  List<Map<String, dynamic>> jsonList = events
      .where((event) => event.eventTypeName != _defaultEventType) // 'other' 필터링
      .map((event) {
        return {
          //"subject_id": subjectId,
          "subject_id": "550e8400-e29b-41d4-a716-446655440000", // 테스트용 임시사용
          "timestamp": event.timeStamp,
          "utcoffset": 9,
          "source_type": "ANDROID",
          "source_info": sourceInfo,
          "package_name": event.packageName,
          "name": event.name,
          "is_system_app": event.isSystemApp ? 1 : 0,
          "is_updated_system_app": event.isUpdatedSystemApp ? 1 : 0,
          "type": event.eventTypeName,
        };
      })
      .toList();

  return {
    'jsonList': jsonList,
    'totalDuration': totalDurationMs,
    'lastTimestamp': lastTimestamp,
    'unlockCount': unlockCount,
  };
}
