import 'package:busstop/utils/request.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddStop extends StatefulWidget {
  @override
  _AddStopState createState() => _AddStopState();
}

class _AddStopState extends State<AddStop> {
  List<dynamic> _stops;
  bool _loading = true;
  String _selectedStop = "";
  List<DropdownMenuItem<String>> _items = [];

  @override
  void initState() {
    Request.getAllStops().then((value){
      setState(() {
        _stops = value;
        _selectedStop = _stops[0]["id"].toString();
        _items = _stops.map((stop) => DropdownMenuItem<String>(
            value: stop["id"].toString(),
            child: Text(stop["name"],
              style: TextStyle(color: Colors.black),
            ),
          )
        ).toList();
        _loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: !_loading ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Choose station:",
                style: TextStyle(fontSize: 22.0),
              ),
              SearchableDropdown.single(
                value: _selectedStop,
                items: _items,
                style: TextStyle(fontSize: 18.0),
                displayClearIcon: false,
                onChanged: (value){
                  setState(() {
                    _selectedStop = value;
                  });
                },
                searchFn: (keyword, items){
                  List<int> result = [];
                  for(int i=0; i<items.length; i++){
                    if(items[i].child.data.toLowerCase().contains(keyword.toLowerCase())) {
                      result.add(i);
                    }
                  }
                  return result;
                },
              ),
            ],
          ):
          Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
