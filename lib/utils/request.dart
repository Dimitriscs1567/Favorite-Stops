import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';
import '';

class Request{
  static final year = DateTime.now().year.toString();
  static final month = DateTime.now().month.toString();
  static final day = DateTime.now().day.toString();

  static final String _stopsUrl = 'https://api.vasttrafik.se/bin/rest.exe/v2/location.allstops?format=json';
  static final String _busesUrl = 'https://api.vasttrafik.se/bin/rest.exe/v2/departureBoard?id=_id&date=$year%2F$month%2F$day&time=08%3A00&timeSpan=120&format=json';

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

  static Future<List<dynamic>> getAllBuses(String id) async {
    String token = await Auth.getAccessToken();
    String url = _busesUrl.replaceFirst("_id", id);

    final response = await http.get(url,
      headers: {
        "Authorization": "Bearer " + token
      },
    );

    if(response.statusCode == 200){
      List<Map<String, dynamic>> result = [];

      if(jsonDecode(response.body)["DepartureBoard"]["Departure"] == null){
        return null;
      }

      List<dynamic> all = (jsonDecode(response.body)["DepartureBoard"]["Departure"] is List<dynamic>)
          ? jsonDecode(response.body)["DepartureBoard"]["Departure"]
          : [jsonDecode(response.body)["DepartureBoard"]["Departure"]];

      all.forEach((bus) {
        Map<String, dynamic> busFromResult = result.firstWhere(
          (el) => el["name"] == bus["name"], orElse: ()=>null
        );

        if(busFromResult == null){
          busFromResult = {
            "name": bus["name"],
            "platforms": [bus["track"]],
          };
          result.add(busFromResult);
        }
        else{
          if(!busFromResult["platforms"].contains(bus["track"])){
            busFromResult["platforms"].add(bus["track"]);
          }
        }
      });

      return result;
    }

    return null;
  }
}