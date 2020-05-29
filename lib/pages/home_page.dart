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
  bool gettingData = true;
  Timer timer;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading && !gettingData){
      getData();
    }

    if(!isLoading && (timer == null || !timer.isActive)){
      timer = Timer.periodic(Duration(seconds: 50), (_){
        getData();
      });
    }

    return Scaffold(
      body: SafeArea(
        child: isLoading ? Center(
          child: CircularProgressIndicator(),
        ):
        (formattedData.keys.isNotEmpty ? PageView(
          children: formattedData.keys.map(
              (stop) => StopWidget(stop: formattedData[stop], stopName: stop,)
          ).toList(),
        ) : Center(
          child: Text('You do not have any favorite stops!',
            style: TextStyle(fontSize: 25.0),
            textAlign: TextAlign.center,
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,
          size: 50.0,
          color: Colors.white,
        ),
        elevation: 10.0,
        onPressed: (){
          setState(() {
            timer.cancel();
            isLoading = true;
          });
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddStop()
          ));
        },
      ),
    );
  }

  void getData(){
    gettingData = true;
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
        gettingData = false;
      });
    });
  }
}
