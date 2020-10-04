import 'package:busstop/models/stop.dart';
import 'package:get_storage/get_storage.dart';

class Storage {
  static Future saveStop(Stop stop) async {
    await GetStorage("stops").write(stop.id, stop.toJson());
  }

  static List<dynamic> getStops() {
    return GetStorage("stops").getKeys().toList().isNotEmpty
        ? GetStorage("stops")
            .getValues()
            .map((value) => Stop.fromJson(value))
            .toList()
        : [];
  }
}
