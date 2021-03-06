import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {

  String _token = '';

  String get getToken => _token;
  bool get isLogged => _token.isNotEmpty;

  AuthProvider() {
    checkToken();
  }

  void checkToken() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    String temp = '';
    if(_sharedPreferences.getString('token') != null) {
      temp = _sharedPreferences.getString('token')!;
    }
    _token = temp;
    notifyListeners();
  }
}