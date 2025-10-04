// 데이터 모델

// lib/models/usage_event_info.dart

import 'package:flutter/foundation.dart';

class UsageEventInfo {
  // ... 기존 UsageEventInfo 클래스 코드 ...
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

// 백그라운드에서 데이터를 처리하는 함수
Map<String, dynamic> processDataInBackground(Map<String, dynamic> arguments) {
  // ... 기존 _processDataInBackground 함수 코드 ...
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
      "source_info": sourceInfo,
      "package_name": event.packageName,
      "name": event.name,
      "is_system_app": event.isSystemApp ? 1 : 0,
      "is_updated_system_app": event.isUpdatedSystemApp ? 1 : 0,
      "type": event.eventTypeName,
    };
  }).toList();

  return {'jsonList': jsonList, 'totalDuration': totalDurationMs};
}
