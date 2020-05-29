import 'dart:async';

import 'package:busstop/pages/add_stop.dart';
import 'package:busstop/utils/data.dart';
import 'package:busstop/utils/request.dart';
import 'package:busstop/widgets/StopWidget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String, Map<String, List<DateTime>>> formattedData = {};
  bool isLoading = true;
  Timer timer;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!isLoading && timer == null){
      timer = Timer.periodic(Duration(seconds: 50), (_){
        getData();
      });
    }

    return Scaffold(
      body: SafeArea(
        child: isLoading ? Center(
          child: CircularProgressIndicator(),
        ):
        PageView(
          children: formattedData.keys.map(
              (stop) => StopWidget(stop: formattedData[stop], stopName: stop,)
          ).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,
          size: 50.0,
          color: Colors.white,
        ),
        elevation: 10.0,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddStop()
          ));
        },
      ),
    );
  }

  void getData(){
    Data.getStops().then((allStops) async{
      Map<String, Map<String, List<DateTime>>> tempData = {};

      if(allStops.keys.length > 0){
        for(String stop in allStops.keys){
          tempData.addAll({
            allStops[stop].last: await Request.getNextBuses(stop, allStops[stop]),
          });
        }
      }

      setState(() {
        formattedData = tempData;
        isLoading = false;
      });
    });
  }
}
