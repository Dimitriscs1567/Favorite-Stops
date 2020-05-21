import 'package:busstop/utils/request.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddStop extends StatefulWidget {
  @override
  _AddStopState createState() => _AddStopState();
}

class _AddStopState extends State<AddStop> {
  List<dynamic> _stops;
  List<dynamic> _buses;
  bool _loading = true;
  bool _loadingBuses = false;
  String _selectedStop = "";
  String _selectedBus = "";
  List<DropdownMenuItem> _busesItems = [];

  @override
  void initState() {
    Request.getAllStops().then((value){
      setState(() {
        _stops = value;
        _selectedStop = _stops[0]["id"].toString();
        _loading = false;
        _getBuses(_selectedStop);
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
              _getStopsAsWidget(),
              Padding(padding: const EdgeInsets.all(20.0),),
              Text("Choose Bus:",
                style: TextStyle(fontSize: 22.0),
              ),
              _getBusesAsWidget(),
            ],
          ):
          Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _getStopsAsWidget(){
    return SearchableDropdown.single(
      value: _selectedStop,
      items: _stops.map((stop) => DropdownMenuItem<String>(
        value: stop["id"].toString(),
        child: Text(stop["name"],
          style: TextStyle(color: Colors.black),
        ),
      )).toList(),
      style: TextStyle(fontSize: 18.0),
      displayClearIcon: false,
      onChanged: (value){
        setState(() {
          _selectedStop = value;
          _getBuses(_selectedStop);
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
    );
  }

  Widget _getBusesAsWidget() {
    return !_loadingBuses && _selectedBus.isNotEmpty ? DropdownButton(
      value: _selectedBus,
      items: _buses.map((bus) => DropdownMenuItem<String>(
        value: bus["name"],
        child: Text(bus["name"],
          style: TextStyle(color: Colors.black),
        ),
      )).toList(),
      style: TextStyle(fontSize: 18.0),
      onChanged: (value){
        setState(() {
          _selectedBus = value;
        });
      },
    ): CircularProgressIndicator();
  }

  void _getBuses(String id){
    setState(() {
      _loadingBuses = true;
      Request.getAllBuses(id).then((value){
        if(value != null){
          setState(() {
            _buses = value;
            _selectedBus = _buses[0]["name"];
            _loadingBuses = false;
          });
        }
      });
    });
  }
}
