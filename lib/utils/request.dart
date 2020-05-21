import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';
import '';

class Request{
  static final String _stopsUrl = 'https://api.vasttrafik.se/bin/rest.exe/v2/location.allstops?format=json';

  static Future<List<dynamic>> getAllStops() async {
    String token = await Auth.getAccessToken();
    final response = await http.get(_stopsUrl,
      headers: {
        "Authorization": "Bearer " + token
      },
    );

    if(response.statusCode == 200){
      List<dynamic> result = jsonDecode(response.body)["LocationList"]["StopLocation"];
      result.retainWhere(
        (element) => element["track"] == null
      );
      return result;
    }

    return null;
  }
}