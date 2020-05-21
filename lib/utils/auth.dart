import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busstop/env.dart';

class Auth{
  static final String _url = 'https://api.vasttrafik.se/token';
  static String _accessToken = '';

  static Future<String> getAccessToken() async {
    if(_accessToken.isNotEmpty){
      return Future(() => _accessToken);
    }

    final response = await http.post(_url,
        headers: {
          "Content-Type" : "application/x-www-form-urlencoded",
          "Authorization": "Basic " + apiKey
        },
        body: {
          "grant_type": "client_credentials"
        }
    );

    if(response.statusCode == 200){
      _accessToken = jsonDecode(response.body)['access_token'];

      return _accessToken;
    }

    return null;
  }
}