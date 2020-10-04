import 'dart:async';

import 'package:busstop/models/stop.dart';
import 'package:busstop/utils/request.dart';
import 'package:busstop/utils/storage.dart';
import 'package:get/get.dart';

class AppDataController extends GetxController {
  RxBool loading = true.obs;
  RxList<Stop> stops = List<Stop>().obs;
  Timer timer;

  @override
  onInit() {
    final dStops = Storage.getStops();
    dStops.forEach((dStop) => stops.add(dStop));
    fillTimetables();

    timer = Timer.periodic(Duration(seconds: 60), (_) {
      fillTimetables();
    });
  }

  Future<void> fillTimetables() async {
    print("filling...");

    for (Stop stop in stops) {
      await Request.getNextBusses(stop);
    }

    loading.value = false;
  }

  void cancel() {}

  void start() {}
}
