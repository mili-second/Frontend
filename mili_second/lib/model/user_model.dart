// lib/models/user_model.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  String? _userId; // user id == inputId
  String? _userJob;
  bool _isLoading = false; // ✨ "자동 로그인 확인 중" 상태 추가
  String? _error;
  String? _userProfileImage;
  String? _userGender;

  String? get userId => _userId;
  String? get userJob => _userJob;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _userId != null;
  String? get userProfileImage => _userProfileImage;
  String? get userGender => _userGender;

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
      _userGender = '여성';
    }

    _isLoading = false;
    notifyListeners(); // "로딩 끝" 알림 (로그인 됐든 안 됐든)
  }

  // ✨ 2. "로그인" 기능 (기존 로직 + 토큰 저장)
  Future<void> login(String inputId, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // ... (서버 통신 로직) ...
      await Future.delayed(const Duration(seconds: 1)); // (시뮬레이션)

      _userId = inputId;
      _userJob = "Developer (from server)";

      // ✨ 로그인 성공 시 토큰(userId) 저장
      await _saveToken(_userId!);
    } catch (e) {
      _error = e.toString();
    } finally {
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
  Future<void> signUp(String userId, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // "회원가입 중..." 로딩

    try {
      // (가상) 서버에 회원가입 요청
      await Future.delayed(const Duration(seconds: 1));

      // ... 서버가 성공 응답을 보냈다고 가정 ...

      // 회원가입 성공 시, 바로 로그인 처리
      _userId = userId;
      _userJob = "New User"; // (예시)

      // ✨ 토큰(userId) 저장
      await _saveToken(_userId!);
    } catch (e) {
      _error = "회원가입에 실패했습니다: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
