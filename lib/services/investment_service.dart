import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class InvestmentService {
  final Map<String, String> _headers = {
    "Content-Type": "application/json",
  };

  Future<List> getInvestments() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('token');

    final _url = Uri.parse(dotenv.env['API'].toString() + '/investments');

    if (token != null) {
      Map<String, String> tempHeader = _headers;
      tempHeader["auth-token"] = token;

      http.Response response = await http.get(_url, headers: tempHeader);

      if(response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    }

    return [];
  }

  Future<Map> getSingleInvestment({required String id}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('token');

    final _url = Uri.parse(dotenv.env['API'].toString() + '/investments/' + id);

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

  Future<bool> purchase({
    required String crypto,
    required String inr,
    required String quantity
  }) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('token');

    final _url = Uri.parse(dotenv.env['API'].toString() + '/investments/buy');
    
    if (token != null) {
      Map<String, String> tempHeader = _headers;
      tempHeader["auth-token"] = token;

      http.Response response = await http.post(
        _url,
        headers: tempHeader,
        body: jsonEncode({
          'crypto_id': crypto,
          'quantity': quantity,
          'inr': inr
        })
      );

      if(response.statusCode == 200) {
        return true;
      }
    }

    return false;
  }
}