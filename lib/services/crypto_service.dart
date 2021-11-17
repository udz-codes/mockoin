import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class CryptoService {
  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Authorization": dotenv.env['CTOKEN'].toString()
  };

  Future<Map<dynamic, dynamic>> getPrices() async{
    final _url = Uri.parse(dotenv.env['CAPI'].toString());

    http.Response response = await http.get(_url, headers: _headers);

    if(response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return {};
  }
}