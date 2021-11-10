import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService{

  final _headers = {
    "Content-Type": "application/json"
  };
  
  void _createToken(token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', token);
  }

  void logout({callback}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove('token');
    callback();
  }

  Future login({required String email, required String password}) async {
    
    final _url = Uri.parse(dotenv.env['API'].toString() + "/user/login");

    http.Response response = await http.post(_url,
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password
      }),
    );

    if(response.statusCode == 200) _createToken(response.body);

    return response;
  }

  Future register ({
    required String name,
    required String email,
    required String password
  }) async {
    
    final _url = Uri.parse(dotenv.env['API'].toString() + "/user/register");
    
    http.Response response = await http.post(_url,
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name
      }),
    );

    if(response.statusCode == 200) await login(email: email, password: password);

    return response;
  }
}