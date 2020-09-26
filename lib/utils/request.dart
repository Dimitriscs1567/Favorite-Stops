import 'dart:convert';
import 'package:busstop/models/bus.dart';
import 'package:busstop/models/stop.dart';
import 'package:http/http.dart' as http;
import 'auth.dart';

class Request {
  static final year = DateTime.now().year.toString();
  static final month = DateTime.now().month.toString();
  static final day = DateTime.now().day.toString();
  static final hour = DateTime.now().hour.toString();
  static final minutes = DateTime.now().minute.toString();

  static final String _stopsUrl =
      'https://api.vasttrafik.se/bin/rest.exe/v2/location.allstops?format=json';
  static final String _busesUrl =
      'https://api.vasttrafik.se/bin/rest.exe/v2/departureBoard?id=_id&date=$year%2F$month%2F$day&time=08%3A00&timeSpan=180&format=json';
  static final String _nextBusesUrl =
      'https://api.vasttrafik.se/bin/rest.exe/v2/departureBoard?id=_id&date=$year%2F$month%2F$day&time=$hour%3A$minutes&timeSpan=65&format=json';

  static Future<List<Stop>> getAllStops() async {
    String token = await Auth.getAccessToken();

    final response = await http.get(
      _stopsUrl,
      headers: {"Authorization": "Bearer " + token},
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      List<dynamic> result =
          jsonDecode(response.body)["LocationList"]["StopLocation"];
      result.retainWhere((element) => element["track"] == null);
      return result.map((element) => Stop.fromJson(element)).toList();
    }

    return null;
  }

  static Future<List<Bus>> getAllBuses(String id) async {
    String token = await Auth.getAccessToken();
    String url = _busesUrl.replaceFirst("_id", id);

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer " + token},
    );

    if (response.statusCode == 200) {
      List<Bus> result = [];

      if (jsonDecode(response.body)["DepartureBoard"]["Departure"] == null) {
        return null;
      }

      List<dynamic> all = (jsonDecode(response.body)["DepartureBoard"]
              ["Departure"] is List<dynamic>)
          ? jsonDecode(response.body)["DepartureBoard"]["Departure"]
          : [jsonDecode(response.body)["DepartureBoard"]["Departure"]];

      all.forEach((bus) {
        Bus busFromResult = result.firstWhere(
          (el) => el.name == bus["name"] && el.platform == bus["track"],
          orElse: () => null,
        );

        if (busFromResult == null) {
          result.add(Bus.fromJson(bus));
        }
      });

      return result;
    }

    return null;
  }

  static Future<Map<String, List<DateTime>>> getNextBuses(
      String id, List<String> buses) async {
    String token = await Auth.getAccessToken();
    String url = _nextBusesUrl.replaceFirst("_id", id);
    buses = buses.sublist(0, buses.length - 1);

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer " + token},
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["DepartureBoard"]["Departure"] == null) {
        return null;
      }

      Map<String, List<DateTime>> result = {};
      List<dynamic> all = (jsonDecode(response.body)["DepartureBoard"]
              ["Departure"] is List<dynamic>)
          ? jsonDecode(response.body)["DepartureBoard"]["Departure"]
          : [jsonDecode(response.body)["DepartureBoard"]["Departure"]];

      buses.forEach((bus) {
        result.addAll({
          bus.split('/')[0] + '/' + bus.split('/')[1]: [],
        });
      });

      all.forEach((bus) {
        if (_goodBus(bus, buses)) {
          result[bus['name'] + '/' + bus['track']]
              .add(DateTime.parse(bus['date'] + ' ' + bus['time'] + ':00'));
        }
      });

      return result;
    } else {
      return null;
    }
  }

  static bool _goodBus(Map<String, dynamic> bus, List<String> goodBuses) {
    bool result = false;

    goodBuses.forEach((goodBus) {
      String goodName = goodBus.split('/')[0];
      String goodPlatform = goodBus.split('/')[1];

      if (bus['name'].toString().compareTo(goodName) == 0 &&
          bus['track'].toString().compareTo(goodPlatform) == 0) {
        result = true;
      }
    });

    return result;
  }
}
