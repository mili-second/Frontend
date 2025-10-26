import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  int _selectedProfileIndex = 0;
  bool _isLoaded = false;

  int get selectedProfileIndex => _selectedProfileIndex;
  bool get isLoaded => _isLoaded;

  void setProfileIndex(int index) {
    _selectedProfileIndex = index;
    notifyListeners();
  }

  Future<void> loadFromPrefs() async {
    if (_isLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    _selectedProfileIndex = prefs.getInt('selectedProfileIndex') ?? 0;
    notifyListeners();
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedProfileIndex', _selectedProfileIndex);
  }
}
