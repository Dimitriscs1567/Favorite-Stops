import 'package:busstop/models/stop.dart';
import 'package:busstop/widgets/BusWidget.dart';
import 'package:flutter/material.dart';

class StopWidget extends StatelessWidget {
  final Stop stop;

  StopWidget({@required this.stop});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(
            stop.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          Padding(padding: const EdgeInsets.all(20.0)),
          Expanded(
            child: ListView.builder(
              itemCount: stop.busses.length,
              itemBuilder: (context, index) {
                return BusWidget(
                  bus: stop.busses[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
