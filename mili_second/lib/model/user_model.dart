// lib/models/user_model.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  final String _baseUrl = "https://api.yolang.shop";
  String? _userId; // user id == inputId
  String? _userToken;
  String? _userJob;
  bool _isLoading = false; // ✨ "자동 로그인 확인 중" 상태 추가
  String? _error;
  String? _userProfileImage = 'assets/icons/profile_default.png';
  String? _userGender;
  String? _userType = 'default';

  String? get userId => _userId;
  String get baseUrl => _baseUrl;
  String? get userToken => _userToken;
  String? get userJob => _userJob;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _userId != null;
  String? get userProfileImage => _userProfileImage;
  String? get userGender => _userGender;
  String? get userType => _userType;

  // --- 내부 저장소 로직 ---

  /// JWT의 Payload(두 번째 부분)를 디코딩하여 Map으로 반환합니다.
  /// (보안 검증(Signature)은 수행하지 않음!)
  Map<String, dynamic> _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid token format');
      }

      String payloadBase64Url = parts[1];

      // Base64Url 형식을 일반 Base64 형식으로 변환 (padding 추가)
      String normalizedPayload = base64Url.normalize(payloadBase64Url);

      // Base64 디코딩
      String payloadJson = utf8.decode(base64.decode(normalizedPayload));

      // JSON 파싱
      return json.decode(payloadJson) as Map<String, dynamic>;
    } catch (e) {
      print("JWT 페이로드 디코딩 실패: $e");
      // 실패 시 빈 Map 반환
      return {};
    }
  }

  // ✨ 토큰(userId) 저장
  Future<void> _saveToken(String usertoken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', usertoken);
  }

  // ✨ 토큰 읽기
  Future<String?> _readToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ✨ 토큰 삭제
  Future<void> _deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // --- Public 함수 ---

  Future<void> checkAutoLogin() async {
    _isLoading = true;
    notifyListeners(); // "로딩 시작" 알림

    final savedToken = await _readToken(); // 저장된 "JWT 토큰" 읽기

    if (savedToken != null && savedToken.isNotEmpty) {
      try {
        // 1. (수정) 저장된 토큰의 페이로드를 직접 디코딩
        final Map<String, dynamic> payload = _decodeJwtPayload(savedToken);

        if (payload.isNotEmpty) {
          // 2. (수정) 페이로드에서 만료 시간(exp)과 ID(sub) 추출
          final int exp = payload['exp'] ?? 0; // 만료 시간 (Unix timestamp)
          final String userId = payload['sub'] ?? ''; // 사용자 ID

          // 3. (수정) 현재 시간과 만료 시간 비교
          final int nowInSeconds =
              DateTime.now().millisecondsSinceEpoch ~/ 1000;

          if (userId.isNotEmpty && exp > nowInSeconds) {
            // --- 토큰 유효 (만료 안 됨) ---
            print("자동 로그인 성공 (ID: $userId)");

            // 4. (수정) 토큰에서 읽은 ID로 상태 업데이트
            _userId = userId; // 👈 토큰에서 꺼낸 ID
            _userToken = savedToken; // 👈 저장되어 있던 토큰

            // (나머지 정보는 임시로 세팅)
            _userJob = "Developer (Auto-login)";
            _userProfileImage = 'assets/icons/profile_default.png';
            _userGender = '여성';
          } else {
            // --- 토큰 만료 또는 ID 없음 ---
            print("토큰이 만료되었거나 유효하지 않습니다.");
            await _deleteToken(); // 만료된 토큰 삭제
          }
        }
      } catch (e) {
        print("자동 로그인 중 토큰 처리 오류: $e");
        await _deleteToken(); // 파싱 실패 시 토큰 삭제
      }
    }

    _isLoading = false;
    notifyListeners(); // "로딩 끝" 알림 (로그인 됐든 안 됐든)
  }

  // ✨ 2. "로그인" 기능 (API 연동)
  Future<void> login(String inputId, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (inputId == "test_front") {
      // front tets용 계정
      _userId = inputId;
      _userJob = "Developer (front_test)"; // (예시)

      _isLoading = false;
      notifyListeners();

      return;
    }

    // 1. 서버 URL
    final url = Uri.parse('$_baseUrl/users/login');
    // final url = Uri.parse(
    //   'https://webhook.site/dd07b461-0805-4e32-a81c-0dfa06336f9f',
    // ); // test

    // 2. 서버에 보낼 데이터
    final body = json.encode({
      'nickname': inputId, // 👈 'nickname' 키로 'inputId' 전송
      'password': password,
    });

    http.Response? response;
    
    try {
      // 3. http.post 요청
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print("로그인 응답: ${response.body}");

      // 4. 응답 처리 (200 = 성공)
      if (response.statusCode == 200) {
        // --- 로그인 성공 ---
        // (❗️ 중요 - 나중에 토큰 받을 때)
        // 말씀하신 대로 나중에 서버가 "토큰"을 반환하면
        // 여기에서 response.body를 파싱해서 저장해야 합니다.
        //
        // --- (예시: 서버가 JSON으로 토큰과 유저 정보를 줄 때) ---
        //
        final responseData = json.decode(response.body);
        final serverToken = responseData['accessToken']; // (예시)
        // final userJob = responseData['user']['job']; // (예시)
        // final userGender = responseData['user']['gender']; // (예시)
        //
        // // 1. 서버가 준 "실제 토큰"을 저장
        await _saveToken(serverToken);
        //
        // // 2. 상태 업데이트
        _userId = inputId; // (또는 responseData['user']['nickname'])
        _userToken = serverToken;
        // _userJob = userJob;
        // _userGender = userGender;
        // ---

        // (임시) 지금은 200 OK만 확인하고,
        // 기존 코드처럼 입력한 ID를 "토큰"처럼 저장합니다.
        // (checkAutoLogin 로직과 호환을 위해)
        // _userId = inputId;
        _userJob = "Developer (from server)"; // (예시)
        print("로그인성공 ");
      } else {
        // 4-1. 서버가 에러 응답을 준 경우 (200이 아닌 경우)
        // (서버가 {"message": "..."} 같은 에러 응답을 줄 수도 있습니다)
        // final errorData = json.decode(response.body);
        // throw Exception(errorData['message'] ?? '아이디나 비밀번호가 틀립니다.');
        print("로그인오류 ${response.statusCode}");
        String serverErrorMessage = '로그인 실패 (Status: ${response.statusCode})'; // 기본 에러 메시지
        try {
          // ✨ 서버 응답 본문을 JSON으로 파싱 시도
          final errorData = json.decode(response.body);
          // ✨ 'error' 키가 있으면 그 값을 사용, 없으면 기본 메시지 사용
          if (errorData is Map && errorData.containsKey('error')) {
            serverErrorMessage = errorData['error'];
          }
        } catch (e) {
          // JSON 파싱 실패 시 응답 본문 텍스트를 그대로 사용 (선택 사항)
          serverErrorMessage = response.body.isNotEmpty ? response.body : serverErrorMessage;
          print("서버 에러 메시지 파싱 실패: $e");
        }
        _error = serverErrorMessage;
      }
    } catch (e) {
      // 4-2. http 요청 자체에서 에러가 난 경우 (네트워크 오류 등)
      _error = "로그인 중 오류 발생: ${e.toString()}";
      if (response != null) {
         _error = _error! + " (Status: ${response.statusCode})";
      }
    } finally {
      // 5. 로딩 종료
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    // _userToken 변수에 토큰이 저장되어 있다고 가정
    if (_userToken == null) {
      print('이미 로그아웃된 상태이거나 토큰이 없습니다.');
      // 토큰이 없어도 로컬 데이터는 확실히 정리
      await _clearLocalData();
      return;
    }

    final url = Uri.parse('$_baseUrl/users/logout');
    final headers = {
      'Authorization': 'Bearer $_userToken',
      'accept': '*/*', // Swagger에서 제공된 헤더
    };

    try {
      // 1. 서버에 로그아웃 요청 (POST)
      final response = await http.post(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('서버 로그아웃 성공');
      } else {
        // 401 (토큰 만료/무효) 등
        print('서버 로그아웃 실패: ${response.statusCode} ${response.body}');
        // 📌 참고: 서버에서 실패 응답이 와도 (예: 이미 만료된 토큰)
        // 로컬 로그아웃은 진행해야 합니다.
      }
    } catch (e) {
      // 네트워크 오류 등 예외 발생
      print('로그아웃 API 호출 중 오류 발생: $e');
      // 📌 참고: 네트워크 오류가 발생해도 로컬 로그아웃은 진행해야 합니다.
    } finally {
      // 2. API 호출 성공/실패 여부와 관계없이 로컬 데이터 정리
      await _clearLocalData();
    }
  }

  // ✨ 로컬 데이터 정리 로직을 별도 함수로 분리 (권장)
  Future<void> _clearLocalData() async {
    await _deleteToken(); // ✨ 스토리지의 토큰 삭제
    _userToken = null; // ✨ 메모리의 토큰 변수 초기화 (중요!)
    _userId = null;
    _userJob = null;
    _error = null;
    notifyListeners();
    print('로컬 데이터 및 토큰이 모두 삭제되었습니다.');
  }

  // 아이디 중복 확인 함수
  //    (리턴 타입: bool (true: 사용 가능, false: 중복됨))
  Future<bool> checkIdDuplication(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // "중복 확인 중..." 로딩 스피너를 위해

    try {
      // (가상) 서버 통신
      await Future.delayed(const Duration(milliseconds: 500));
      if (userId == "test") {
        throw Exception("이미 사용중인 아이디입니다."); // 👈 중복 에러 발생
      }
      // 성공 (중복 아님)
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 회원가입 함수
  Future<void> signUp(
    String userId,
    String password,
    int profileImageNumber,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // "회원가입 중..." 로딩

    // 1. 서버 URL
    final url = Uri.parse('$_baseUrl/users/signup');

    // 2. 서버에 보낼 데이터 (JSON 형식으로 변환)
    final body = json.encode({
      'nickname': userId,
      'profileImageNumber': profileImageNumber,
      'password': password,
    });

    try {
      // 3. http.post 요청
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // 4. 응답 처리
      if (response.statusCode == 200) {
        // --- 회원가입 성공 ---
        print("회원가입 성공. 즉시 로그인을 시도합니다.");

        // ✨✨✨ 여기가 핵심 ✨✨✨
        // 회원가입에 사용한 ID와 PW로 방금 만든 login 함수를 호출합니다.
        // login 함수가 알아서 토큰 저장, 상태 업데이트, notifyListeners()까지
        // 전부 처리해 줍니다.
        await login(userId, password);

        // (기존의 임시 로그인 코드는 이제 필요 없음)
        // _userId = userId;
        // _userJob = "New User";
        // await _saveToken(_userId!);
        // print("회원가입 성공"); // login 함수가 로그를 찍어줌
      } else {
        // 4-1. 서버가 에러 응답을 준 경우
        print("회원가입 실패 ${response.statusCode}");
        throw Exception('회원가입 실패 (Status: ${response.statusCode})');
      }
    } catch (e) {
      // 4-2. http 요청 자체에서 에러가 난 경우 (네트워크 오류 등)
      _error = "회원가입 중 오류 발생: ${e.toString()}";
      // ✨ 에러가 발생했으므로 로딩을 멈추고 리스너에게 알려야 함
      _isLoading = false;
      notifyListeners();
    }
    // ❗️ `finally` 블록을 제거합니다.
    // 이유:
    // 1. 성공 시: login() 함수가 자신의 finally에서 _isLoading=false, notify()를 호출함.
    // 2. 실패 시: catch {} 블록에서 _isLoading=false, notify()를 호출함.
    //
    // ❌ (기존 코드)
    // finally {
    //   _isLoading = false;
    //   notifyListeners();
    // }
  }

  // usermodel.dart

  Future<void> get_phonebti() async {
    if (_userType != 'default') {
      print('이미 핸bti를 로드했거나 로드에 실패했습니다: $_userType');
      return;
    }
    if (_userId == "test_front") {
      // front tets용 계정
      print("front_test 계정");
      _userJob = "Developer (front_test)"; // (예시)
      _userType = "balanced"; // 임시 타입

      _isLoading = false;
      notifyListeners();

      return;
    }

    // 0. (추가) 토큰이 null이면 아예 API를 호출하지 않고 강제 로그아웃
    if (_userToken == null) {
      print('핸bti 실패: _userToken이 null입니다. 로그아웃을 시도합니다.');
      await _clearLocalData(); // 로그아웃 처리
      return; // 함수 종료
    }

    final url = Uri.parse('${_baseUrl}/insights/content-preferences');
    final headers = {
      'Authorization': 'Bearer ${_userToken}',
      'accept': '*/*', // Swagger에서 제공된 헤더
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('핸비티아이 가져오기 성공');

        // --- (기존 파싱 로직 ... ) ---
        final dataList = jsonDecode(utf8.decode(response.bodyBytes));
        if (dataList is List && dataList.isNotEmpty) {
          final firstItem = dataList[0];
          _userType = firstItem['contentPreference'];
          print('핸비티아이 파싱 성공: $_userType');
        } else {
          print('핸bti실패: 응답이 왔으나 데이터 리스트가 비어있습니다.');
          _userType = 'balanced'; // 실패 시 임시값
        }
        // ---

        // ✨ 성공했을 때만 notify
        notifyListeners();
      } else {
        // --- ⬇️ 여기가 핵심 수정 부분 ⬇️ ---
        print('핸bti실패: ${response.statusCode} ${response.body}');

        // 🚨 401 에러(Unauthorized) 처리
        if (response.statusCode == 401) {
          print('토큰이 유효하지 않습니다. 강제 로그아웃합니다.');
          // 401 에러 시, _clearLocalData()를 호출해 로그아웃
          // _clearLocalData가 내부적으로 notifyListeners()를 호출함
          await _clearLocalData();
          // 🚨 'finally'의 notifyListeners()와 중복 호출을 막기 위해
          //    여기서 함수를 바로 종료합니다.
          return;
        } else {
          // 401이 아닌 다른 에러 (e.g., 500)
          _userType = 'balanced';
          notifyListeners(); // ✨ 실패 시(401 제외)에도 notify
        }
        // --- ⬆️ 여기까지 수정 ⬆️ ---
      }
    } catch (e) {
      // 네트워크 오류 등 예외 발생
      print('핸bti API 호출 중 오류 발생: $e');
      _userType = 'balanced';
      notifyListeners(); // ✨ 예외 발생 시에도 notify
    }
    // ❌ 'finally'에서 notifyListeners()를 제거!
    // 각 분기(success, fail, catch)에서 개별적으로 처리하도록 변경
  }
}
