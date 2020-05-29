import 'package:busstop/widgets/BusWidget.dart';
import 'package:flutter/material.dart';

class StopWidget extends StatelessWidget {
  final Map<String, List<DateTime>> stop;
  final String stopName;

  StopWidget({@required this.stop, @required this.stopName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Text(stopName,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          Padding(padding: const EdgeInsets.all(30.0)),
          stop!=null ? Expanded(
            child: ListView.builder(
              itemCount: stop.keys.length,
              itemBuilder: (context, index){
                String busName = stop.keys.toList()[index];
                return BusWidget(
                  busName: busName,
                  arrivals: stop[busName],
                );
              },
            ),
          ) : Center(
            child: Text('No buses selected for this stop.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.0),
            ),
          ),
        ],
      ),
    );
  }
}
