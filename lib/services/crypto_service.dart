import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class CryptoService {

  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Authorization": dotenv.env['CTOKEN'].toString()
  };

  Future<Map<dynamic, dynamic>> getAssetPrices(id) async{
    final _url = Uri.parse(dotenv.env['CAPIWID'].toString() + "/" + id);
    Map<dynamic, dynamic> jsonData = {};
    http.Response response = await http.get(_url, headers: _headers);
    
    if(response.statusCode == 200) {
      jsonData = (jsonDecode(response.body))["data"];
    }
    return jsonData;
  }

  Future<List> getPrices() async{
    final _url = Uri.parse(dotenv.env['CAPI'].toString());

    http.Response response = await http.get(_url, headers: _headers);
    
    List jsonData = (jsonDecode(response.body))["data"];
    
    if(response.statusCode == 200) {
      return jsonData;
    }

    return [];
  }

  Future<List> getMultiple(ids) async{
    final _url = Uri.parse(dotenv.env['CAPIWID'].toString() + "?ids=" + ids);

    http.Response response = await http.get(_url, headers: _headers);
    
    List jsonData = (jsonDecode(response.body))["data"];
    
    if(response.statusCode == 200) {
      return jsonData;
    }

    return [];
  }
}