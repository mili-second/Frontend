// lib/models/user_model.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  final String _baseUrl = "https://api.yolang.shop";
  String? _userId; // user id == inputId
  String? _userJob;
  bool _isLoading = false; // ✨ "자동 로그인 확인 중" 상태 추가
  String? _error;
  String? _userProfileImage = 'assets/icons/profile_default.png';
  String? _userGender;
  String? _userType = 'shoppingAddictType';

  String? get userId => _userId;
  String? get userJob => _userJob;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _userId != null;
  String? get userProfileImage => _userProfileImage;
  String? get userGender => _userGender;
  String? get userType => _userType;

  // --- 내부 저장소 로직 ---

  // ✨ 토큰(userId) 저장
  Future<void> _saveToken(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', userId);
  }

  // ✨ 토큰(userId) 읽기
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

  // ✨ 1. "자동 로그인" 기능 (View에서 호출할 함수)
  Future<void> checkAutoLogin() async {
    _isLoading = true;
    notifyListeners(); // "로딩 시작" 알림

    final savedUserId = await _readToken(); // 저장된 ID(토큰) 읽기

    if (savedUserId != null) {
      // (중요!) 실제 앱에서는 이 토큰/ID로 서버에 사용자 정보를 요청해야 합니다.
      // 지금은 저장된 ID가 곧 로그인 성공이라고 가정합니다.
      _userId = savedUserId;
      _userJob = "Developer (Auto-login)"; // (예시) 서버에서 받아온 직업
      _userProfileImage = 'assets/icons/profile_default.png'; // 임시사용
      _userType = 'shoppingAddictType';
      _userGender = '여성';
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
      _userType = "shoppingAddictType"; // 임시 타입

      _isLoading = false;
      notifyListeners();

      return;
    }

    // 1. 서버 URL (❗️ 엔드포인트가 '/users/login'이 맞는지 확인하세요)
    final url = Uri.parse('$_baseUrl/users/login');
    // final url = Uri.parse(
    //   'https://webhook.site/dd07b461-0805-4e32-a81c-0dfa06336f9f',
    // ); // test

    // 2. 서버에 보낼 데이터
    final body = json.encode({
      'nickname': inputId, // 👈 'nickname' 키로 'inputId' 전송
      'password': password,
    });

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
        // final responseData = json.decode(response.body);
        // final serverToken = responseData['token']; // (예시)
        // final userJob = responseData['user']['job']; // (예시)
        // final userGender = responseData['user']['gender']; // (예시)
        //
        // // 1. 서버가 준 "실제 토큰"을 저장
        // await _saveToken(serverToken);
        //
        // // 2. 상태 업데이트
        // _userId = inputId; // (또는 responseData['user']['nickname'])
        // _userJob = userJob;
        // _userGender = userGender;
        // ---

        // (임시) 지금은 200 OK만 확인하고,
        // 기존 코드처럼 입력한 ID를 "토큰"처럼 저장합니다.
        // (checkAutoLogin 로직과 호환을 위해)
        _userId = inputId;
        _userJob = "Developer (from server)"; // (예시)
        _userType = 'shoppingAddictType';
        print("로그인성공 ");
        await _saveToken(_userId!); // 👈 입력한 ID를 토큰으로 저장
      } else {
        // 4-1. 서버가 에러 응답을 준 경우 (200이 아닌 경우)
        // (서버가 {"message": "..."} 같은 에러 응답을 줄 수도 있습니다)
        // final errorData = json.decode(response.body);
        // throw Exception(errorData['message'] ?? '아이디나 비밀번호가 틀립니다.');
        print("로그인오류 ${response.statusCode}");
        throw Exception('로그인 실패 (Status: ${response.statusCode})');
      }
    } catch (e) {
      // 4-2. http 요청 자체에서 에러가 난 경우 (네트워크 오류 등)
      _error = "로그인 중 오류 발생: ${e.toString()}";
    } finally {
      // 5. 로딩 종료
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✨ 3. "로그아웃" 기능 (기존 로직 + 토큰 삭제)
  Future<void> logout() async {
    await _deleteToken(); // ✨ 토큰 삭제
    _userId = null;
    _userJob = null;
    _error = null;
    notifyListeners();
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
  // 회원가입 함수
  // ✨ API 연동을 위해 'profileImageNumber'를 파라미터로 추가했습니다.
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
      'password': password,
      'profileImageNumber': profileImageNumber,
    });

    try {
      // 3. http.post 요청 (POST 메서드로 추정)
      final response = await http.post(
        url,
        headers: {
          // 👈 (중요) 내가 보내는 데이터가 JSON 타입이라고 서버에 알려줍니다.
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // 4. 응답 처리 (상태 코드가 200이면 성공)
      if (response.statusCode == 200) {
        // --- 회원가입 성공 ---

        // (질문❓)
        // 회원가입 성공 시, 서버가 응답(Response)으로 바로 '토큰'이나
        // '사용자 정보(직업, 성별 등)'를 보내주나요?
        //
        // 만약 그렇다면, 여기서 response.body를 파싱해서 저장해야 합니다.
        // 예: final responseData = json.decode(response.body);
        //     final token = responseData['token'];
        //     await _saveToken(token);
        //
        // 일단은 기존 코드처럼, 입력한 ID로 바로 로그인 처리합니다.
        _userId = userId;
        _userJob = "New User"; // (예시)

        print("회원가입 성공");

        // ✨ 토큰(userId) 저장
        await _saveToken(_userId!);
      } else {
        // 4-1. 서버가 에러 응답을 준 경우 (200이 아닌 경우)
        // (만약 서버가 에러 메시지를 JSON으로 보낸다면 파싱해서 보여줄 수 있습니다)
        // final errorData = json.decode(response.body);
        // throw Exception(errorData['message'] ?? '알 수 없는 오류');
        throw Exception('회원가입 실패 (Status: ${response.statusCode})');
      }
    } catch (e) {
      // 4-2. http 요청 자체에서 에러가 난 경우 (네트워크 오류 등)
      _error = "회원가입 중 오류 발생: ${e.toString()}";
    } finally {
      // 5. 로딩 종료
      _isLoading = false;
      notifyListeners();
    }
  }
}
