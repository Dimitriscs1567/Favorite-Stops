import 'package:busstop/models/bus.dart';
import 'package:busstop/models/stop.dart';
import 'package:busstop/utils/request.dart';
import 'package:busstop/utils/storage.dart';
import 'package:get/get.dart';

class NewDataController extends GetxController {
  RxList<Stop> allStops = List<Stop>().obs;
  RxList<Bus> allBusses = List<Bus>().obs;
  RxString selectedStop = "".obs;
  RxList<int> selectedBusses = List<int>().obs;
  RxBool loadingBusses = false.obs;
  RxBool saving = false.obs;

  @override
  onInit() {
    getStops();
    ever(selectedStop, (_) {
      if (selectedStop.value.isNotEmpty) {
        loadingBusses.value = true;
        getBusses().then((_) => loadingBusses.value = false);
      }
    });
  }

  Future getStops() async {
    allStops.addAll(await Request.getAllStops());
  }

  Future getBusses() async {
    allBusses.clear();
    selectedBusses.clear();
    final busses = await Request.getAllBusses(selectedStop.value);
    if (busses != null) {
      allBusses.addAll(busses);
    }
  }

  Future savePreference() async {
    saving.value = true;

    List<Bus> bussesToSave = selectedBusses.map((busIndex) {
      return allBusses[busIndex];
    }).toList();

    Stop stopToSave = allStops
        .firstWhere((stop) => stop.id.compareTo(selectedStop.value) == 0);

    bussesToSave.forEach((bus) => stopToSave.addBus(bus));

    await Storage.saveStop(stopToSave);
    saving.value = false;
  }
}
