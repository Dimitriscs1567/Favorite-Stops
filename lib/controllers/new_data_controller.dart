import 'package:busstop/models/bus.dart';
import 'package:busstop/models/stop.dart';
import 'package:busstop/utils/request.dart';
import 'package:get/get.dart';

class NewDataController extends GetxController {
  RxList<Stop> allStops = List<Stop>().obs;
  RxList<Bus> allBuses = List<Bus>().obs;
  RxString selectedStop = "".obs;
  RxList<int> selectedBuses = List<int>().obs;
  RxBool loadingBuses = false.obs;

  @override
  onInit() {
    getStops();
    ever(selectedStop, (_) {
      if (selectedStop.value.isNotEmpty) {
        loadingBuses.value = true;
        getBuses().then((_) => loadingBuses.value = false);
      }
    });
  }

  Future getStops() async {
    allStops.addAll(await Request.getAllStops());
  }

  Future getBuses() async {
    allBuses.clear();
    selectedBuses.clear();
    final buses = await Request.getAllBuses(selectedStop.value);
    if (buses != null) {
      allBuses.addAll(buses);
    }
  }
}
