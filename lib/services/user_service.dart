import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class UserService{

  final _headers = {
    "Content-Type": "application/json"
  };

  Future login({required String email, required String password}) async {
    
    final _url = Uri.parse(dotenv.env['API'].toString() + "/user/login");
    
    http.Response response = await http.post(_url,
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password
      }),
    );

    return response;
  }
}