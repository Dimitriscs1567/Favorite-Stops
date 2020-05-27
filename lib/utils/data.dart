import 'package:shared_preferences/shared_preferences.dart';

class Data{

  static Future saveStop(String id, List<String> busNames) async{
    SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setStringList(id, busNames);
  }

  static Future<Map<String, List<String>>> getStops(String id, List<String> busNames) async{
    SharedPreferences sp = await SharedPreferences.getInstance();

    Map<String, List<String>> result;
    sp.getKeys().forEach((key) {
      result.addAll({key: sp.getStringList(key)});
    });

    return result;
  }

}