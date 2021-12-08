import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionService {

  final Map<String, String> _headers = {
    "Content-Type": "application/json"
  };

  Future<List> getTransactions({cryptoId = ''}) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('token');
    final Uri _url;

    if(cryptoId.toString().isEmpty) {
      _url = Uri.parse(dotenv.env['API'].toString() + "/transactions");
    } else {
      _url = Uri.parse(dotenv.env['API'].toString() + "/transactions/" + cryptoId.toString());
    }

    if (token != null) {
      Map<String, String> tempHeader = _headers;
      tempHeader["auth-token"] = token;

      http.Response response = await http.get(_url, headers: tempHeader);


      if(response.statusCode == 200) {
        List transactions = jsonDecode(response.body);
        return transactions;
      }
    }

    return [];
  }
}