import 'package:busstop/pages/add_stop.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
}
