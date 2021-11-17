import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockoin/providers/authentication_provider.dart';

class UserService{
  AuthProvider authProvider = AuthProvider();
  
  final Map<String, String> _headers = {
    "Content-Type": "application/json"
  };
  
  void _createToken(token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', token);
    return;
  }

  Future logout({required BuildContext context}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove('token').then(
      (value) {
        Provider.of<AuthProvider>(context, listen: false).checkToken();
      }
    );
  }

  Future fetchUser() async {
    final _url = Uri.parse(dotenv.env['API'].toString() + "/user");
    
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('token');

    if (token != null) {
      Map<String, String> tempHeader = _headers;
      tempHeader["auth-token"] = token;

      http.Response response = await http.get(_url, headers: tempHeader);

      if(response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    }

    return {};
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

    if(response.statusCode == 200){
      _createToken(response.body);
    }

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

    // if(response.statusCode == 200) await login(email: email, password: password);

    return response;
  }
}