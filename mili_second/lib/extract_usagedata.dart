import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert'; // jsonEncode 사용을 위해 추가

class ExtractUsageData extends StatefulWidget {
  const ExtractUsageData({Key? key}) : super(key: key);

  @override
  _ExtractUsageDataState createState() => _ExtractUsageDataState();
}

class _ExtractUsageDataState extends State<ExtractUsageData> {
  static const platform = MethodChannel('com.example.mili_second/usagestats');

  String _status = '버튼을 눌러 시작하세요';
  String _jsonOutput = '여기에 JSON이 표시됩니다.'; // JSON 출력을 위한 변수 추가
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _endDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  Future<void> _extractUsageData() async {
    try {
      setState(() {
        _status = '데이터 수집 중...';
      });

      // 선택된 날짜와 시간을 조합하여 시작/종료 DateTime 객체 생성
      final DateTime startDateTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      final DateTime endDateTime = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      final List<dynamic>? rawData = await platform
          .invokeMethod<List<dynamic>>('getUsageStats', {
            'startTime': startDateTime.millisecondsSinceEpoch,
            'endTime': endDateTime.millisecondsSinceEpoch,
          });

      if (rawData != null) {
        setState(() {
          _status = '데이터 가공 중...';
        });

        List<UsageEventInfo> processedData = _processUsageData(rawData);
        // 엑셀 생성 대신 JSON 변환 함수 호출
        String jsonString = _convertDataToJson(processedData);

        setState(() {
          _status = 'JSON 데이터가 생성되었습니다.';
          _jsonOutput = jsonString; // 가공된 JSON 데이터를 변수에 저장
        });

        print('JSON 데이터 생성 성공: $jsonString');
      } else {
        setState(() {
          _status = '데이터를 가져오지 못했습니다.';
        });
      }
    } on PlatformException catch (e) {
      // 네이티브에서 result.error()를 호출하면 PlatformException이 발생합니다.
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

  List<UsageEventInfo> _processUsageData(List<dynamic> rawData) {
    // 1. Map을 UsageEventInfo 객체 리스트로 변환
    List<UsageEventInfo> events = rawData
        .map((item) => UsageEventInfo.fromMap(item as Map<dynamic, dynamic>))
        .toList();

    // 2. 시간 순으로 정렬
    events.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

    // 3. 각 이벤트의 상세 정보 계산
    for (var event in events) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(event.timeStamp);
      event.date =
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      event.time =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
      event.hourOfDay = dateTime.hour;

      // 요일 계산 (1:월요일, 7:일요일)
      const List<String> days = ['월', '화', '수', '목', '금', '토', '일'];
      event.dayOfWeek = days[dateTime.weekday - 1];

      // 이벤트 타입 이름 변환
      switch (event.eventType) {
        case 1: // ACTIVITY_RESUMED
          event.eventTypeName = '시작';
          break;
        case 2: // ACTIVITY_PAUSED
          event.eventTypeName = '종료';
          break;
        // 필요한 경우 다른 이벤트 타입 추가 (예: 7: USER_INTERACTION, 11: STANDBY_BUCKET_CHANGED)
        default:
          event.eventTypeName = '기타';
          break;
      }
    }

    // 4. (심화) 사용 시간(duration) 계산
    Map<String, UsageEventInfo> lastResumeEvent = {};

    for (var event in events) {
      if (event.eventType == 1) {
        // ACTIVITY_RESUMED
        lastResumeEvent[event.packageName] = event;
      }

      if (event.eventType == 2) {
        // ACTIVITY_PAUSED
        if (lastResumeEvent.containsKey(event.packageName)) {
          UsageEventInfo resumeEvent = lastResumeEvent[event.packageName]!;
          event.durationMs = event.timeStamp - resumeEvent.timeStamp;
          event.durationMinutes = event.durationMs / (1000 * 60);

          // 계산 후에는 맵에서 제거하여 중복 계산 방지
          lastResumeEvent.remove(event.packageName);
        }
      }
    }

    return events;
  }

  // 엑셀 생성 함수 대신 JSON 변환 함수를 추가
  String _convertDataToJson(List<UsageEventInfo> data) {
    List<Map<String, dynamic>> jsonList = data.map((event) {
      return {
        "subject_id": 1,
        "timestamp": event.timeStamp,
        "source_type": "PHONE",
        "source_info": "samsung-SM-N960N-8.1.0",
        "package_name": event.packageName,
        "name": event.packageName,
        "is_system_app": false,
        "is_updated_system_app": false,
        "type": event.eventTypeName == '시작'
            ? 'MOVE_TO_FOREGROUND'
            : 'MOVE_TO_BACKGROUND',
      };
    }).toList();

    // JsonEncoder를 사용하여 들여쓰기된 JSON 문자열 생성
    // ' ' * 2 는 공백 2칸을 들여쓰기 간격으로 사용하겠다는 의미입니다.
    // 원하는 만큼 공백이나 탭('\t')으로 변경할 수 있습니다.
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(jsonList);
  }

  // 날짜 선택기 함수
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // 시간 선택기 함수
  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // 날짜 포맷팅 함수
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // 시간 포맷팅 함수
  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사용자 활동 내역 분석')),
      body: SingleChildScrollView(
        // 스크롤 가능하도록 SingleChildScrollView 추가
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 시작 날짜 선택 버튼
              ElevatedButton(
                onPressed: () => _selectDate(context, true),
                child: Text('시작 날짜: ${_formatDate(_startDate)}'),
              ),
              // 시작 시간 선택 버튼
              ElevatedButton(
                onPressed: () => _selectTime(context, true),
                child: Text('시작 시간: ${_formatTime(_startTime)}'),
              ),
              const SizedBox(height: 20),
              // 종료 날짜 선택 버튼
              ElevatedButton(
                onPressed: () => _selectDate(context, false),
                child: Text('종료 날짜: ${_formatDate(_endDate)}'),
              ),
              // 종료 시간 선택 버튼
              ElevatedButton(
                onPressed: () => _selectTime(context, false),
                child: Text('종료 시간: ${_formatTime(_endTime)}'),
              ),
              Text(
                _status, // 상태 메시지를 화면에 표시
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _extractUsageData,
                child: const Text('데이터 가져와서 JSON 만들기'),
              ),
              const SizedBox(height: 20),
              const Text(
                '생성된 JSON 데이터:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // JSON 데이터를 화면에 출력
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _jsonOutput,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UsageEventInfo {
  final String packageName;
  final int eventType;
  final int timeStamp;

  // 가공해서 추가할 필드들
  String date = '';
  String time = '';
  String eventTypeName = '';
  String dayOfWeek = '';
  int hourOfDay = 0;
  int durationMs = 0;
  double durationMinutes = 0.0;

  UsageEventInfo({
    required this.packageName,
    required this.eventType,
    required this.timeStamp,
  });

  // 네이티브에서 받은 Map을 UsageEventInfo 객체로 변환하는 factory 생성자
  factory UsageEventInfo.fromMap(Map<dynamic, dynamic> map) {
    return UsageEventInfo(
      packageName: map['packageName'] ?? '',
      eventType: map['eventType'] ?? -1,
      timeStamp: map['timeStamp'] ?? 0,
    );
  }
}
