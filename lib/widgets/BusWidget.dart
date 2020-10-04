import 'package:busstop/models/bus.dart';
import 'package:flutter/material.dart';

class BusWidget extends StatelessWidget {
  final Bus bus;

  BusWidget({@required this.bus});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              bus.name + ' (Pl.${bus.platform})' + ':',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.end,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
          ),
          Expanded(
            child: bus.timetable.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: bus.timetable.map((arrival) {
                      Duration diff = arrival.difference(DateTime.now());
                      if (diff.isNegative) {
                        return Container();
                      } else {
                        String text;
                        if (diff.inMinutes == 0) {
                          text = 'now';
                        } else if (diff.inMinutes == 1) {
                          text = 'in 1 minute';
                        } else {
                          text = 'in ${diff.inMinutes} minutes';
                        }
                        return Container(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            text,
                            style: TextStyle(fontSize: 20.0),
                          ),
                        );
                      }
                    }).toList(),
                  )
                : Text(
                    "No arrivals in the next hour",
                    style: TextStyle(fontSize: 22.0),
                  ),
          ),
        ],
      ),
    );
  }
}
