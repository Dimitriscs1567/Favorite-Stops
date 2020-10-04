import 'package:busstop/controllers/new_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddStop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    alignment: Alignment.center,
                    child: Text(
                      "New Favorite Stop",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GetX<NewDataController>(
                    builder: (controller) {
                      if (controller.allStops.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: [
                          Text(
                            "Choose station:",
                            style: TextStyle(fontSize: 22.0),
                          ),
                          _getStopsAsWidget(),
                          Padding(padding: const EdgeInsets.all(20.0)),
                        ],
                      );
                    },
                  ),
                  GetX<NewDataController>(
                    builder: (controller) {
                      if (controller.allStops.isEmpty) {
                        return Container();
                      } else if (controller.selectedStop.value.isEmpty) {
                        return Center(
                          child: Text(
                            "Please select a bus stop first!",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        );
                      } else if (controller.loadingBusses.value) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (controller.allBusses.isEmpty) {
                        return Container(
                          child: Text(
                            "There are no available busses from this stop!",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Text(
                            "Choose Busses:",
                            style: TextStyle(fontSize: 22.0),
                          ),
                          _getBussesAsWidget(),
                        ],
                      );
                    },
                  ),
                  GetX<NewDataController>(
                    builder: (controller) {
                      if (controller.allStops.isEmpty) return Container();
                      return _saveButton();
                    },
                  ),
                ],
              ),
              _backButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getStopsAsWidget() {
    final controller = Get.find<NewDataController>();

    return SearchableDropdown.single(
      value: controller.selectedStop.value,
      items: controller.allStops
          .map((stop) => DropdownMenuItem<String>(
                value: stop.id,
                child: Text(
                  stop.name,
                  style: TextStyle(color: Colors.black),
                ),
              ))
          .toList(),
      style: TextStyle(fontSize: 18.0),
      displayClearIcon: false,
      onChanged: (value) {
        controller.selectedStop.value = value;
      },
      searchFn: (keyword, items) {
        List<int> result = [];
        for (int i = 0; i < items.length; i++) {
          if (items[i]
              .child
              .data
              .toLowerCase()
              .contains(keyword.toLowerCase())) {
            result.add(i);
          }
        }
        return result;
      },
    );
  }

  Widget _getBussesAsWidget() {
    final controller = Get.find<NewDataController>();

    return SearchableDropdown.multiple(
      selectedItems: controller.selectedBusses,
      items: controller.allBusses.map((bus) {
        return DropdownMenuItem<String>(
          value: bus.name + '/' + bus.platform,
          child: Text(
            bus.name + ' ' + '(Pl. ${bus.platform})',
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      style: TextStyle(fontSize: 18.0),
      selectedValueWidgetFn: (item) {
        return Container(
          width: Get.width / 1.5,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(bottom: 8.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            item.split('/')[0] + ' (Pl. ' + item.split('/')[1] + ')',
            style: TextStyle(color: Colors.black),
          ),
        );
      },
      validator: (selectedItems) {
        if (selectedItems.isEmpty) {
          return "Please select at least one bus";
        }

        return null;
      },
      doneButton: (selectedItems, context) {
        return Container();
      },
      closeButton: (selectedItems) {
        return selectedItems.isNotEmpty ? 'Done' : Container();
      },
      onChanged: (values) {
        controller.selectedBusses.clear();
        controller.selectedBusses.addAll(values);
      },
    );
  }

  Widget _saveButton() {
    final controller = Get.find<NewDataController>();

    return Container(
      padding: const EdgeInsets.only(top: 40.0),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green[700]),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          ),
        ),
        child: !controller.saving.value
            ? Text(
                "Save",
                style: TextStyle(fontSize: 25.0),
              )
            : CircularProgressIndicator(),
        onPressed: controller.saving.value || controller.selectedBusses.isEmpty
            ? null
            : () {
                if (!controller.saving.value) {
                  controller.savePreference().whenComplete(() => Get.back());
                }
              },
      ),
    );
  }

  Widget _backButton() {
    return Positioned(
      top: -8.0,
      left: -8.0,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        icon: Icon(Icons.arrow_back),
        iconSize: 30.0,
        color: Colors.black,
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}
