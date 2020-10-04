import 'package:busstop/controllers/app_data_controller.dart';
import 'package:busstop/controllers/new_data_controller.dart';
import 'package:busstop/pages/add_stop.dart';
import 'package:busstop/widgets/StopWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final newController =
      Get.put<NewDataController>(NewDataController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<AppDataController>(
          init: AppDataController(),
          builder: (controller) {
            return SafeArea(
              child: controller.loading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : (controller.stops.isNotEmpty
                      ? PageView(
                          children: controller.stops
                              .map((stop) => StopWidget(
                                    stop: stop,
                                  ))
                              .toList(),
                        )
                      : Center(
                          child: Text(
                            'You do not have any favorite stops!',
                            style: TextStyle(fontSize: 25.0),
                            textAlign: TextAlign.center,
                          ),
                        )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 50.0,
          color: Colors.white,
        ),
        elevation: 10.0,
        onPressed: () {
          final controller = Get.find<AppDataController>();
          controller.cancel();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStop()),
          ).whenComplete(() => controller.start());
        },
      ),
    );
  }
}
