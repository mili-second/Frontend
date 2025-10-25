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
  String? _userType = 'shoppingAddictType';

  String? get userId => _userId;
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
            _userType = 'shoppingAddictType';
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
        final serverToken = responseData['token']; // (예시)
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
        _userType = 'shoppingAddictType';
        print("로그인성공 ");
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
