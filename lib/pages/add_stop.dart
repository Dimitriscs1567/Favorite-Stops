import 'package:busstop/utils/data.dart';
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
  bool _noBuses = false;
  bool _saveLoading = false;
  String _selectedStop = "";
  String _selectedStopName = "";
  List<int> _selectedBuses = [];
  List<DropdownMenuItem> _busesItems;

  @override
  void initState() {
    Request.getAllStops().then((value){
      setState(() {
        _stops = value;
        _selectedStop = _stops[0]["id"].toString();
        _selectedStopName = _stops[0]["name"].toString();
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
          child: !_loading ? Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    alignment: Alignment.center,
                    child: Text("New Favorite Stop",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text("Choose station:",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  _getStopsAsWidget(),
                  Padding(padding: const EdgeInsets.all(20.0),),
                  Text("Choose Buses:",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  _getBusesAsWidget(),
                  Container(
                    padding: const EdgeInsets.only(top: 40.0),
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.green[700],
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      child: !_saveLoading ? Text("Save",
                        style: TextStyle(fontSize: 25.0),
                      ) : CircularProgressIndicator(),
                      onPressed: (){
                        if(!_saveLoading){
                          setState(() {
                            _saveLoading = true;
                          });

                          List<String> toSave = _selectedBuses.map((busIndex) {
                                return _busesItems[busIndex].value.toString();
                          }).toList();
                          toSave.add(_selectedStopName);

                          Data.saveStop(_selectedStop, toSave).whenComplete(
                                () => Navigator.pop(context)
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -8.0,
                left: -8.0,
                child: IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(Icons.arrow_back),
                  iconSize: 30.0,
                  color: Colors.black,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
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
        if(_selectedStop.compareTo(value) != 0){
          setState(() {
            _selectedStop = value;
            _selectedStopName = _stops.firstWhere(
                  (stop) => stop['id'].toString().compareTo(value) == 0)['name'];
            _getBuses(_selectedStop);
          });
        }
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
    if(!_loadingBuses){
      if(_noBuses){
        return Container(
          child: Text("There are no available buses from this stop!",
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }
      else{
        return SearchableDropdown.multiple(
          selectedItems: _selectedBuses,
          items: _busesItems,
          style: TextStyle(fontSize: 18.0),
          selectedValueWidgetFn: (item){
            return Container(
              width: 150,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(item.split('/')[0] + ' (Pl. ' + item.split('/')[1] + ')',
                style: TextStyle(color: Colors.black),
              ),
            );
          },
          validator: (selectedItems){
            if(selectedItems.isEmpty){
              return "Please select at least one bus";
            }

            return null;
          },
          doneButton: (selectedItems, context){
            return Container();
          },
          closeButton: (selectedItems){
            return selectedItems.isNotEmpty ? 'Done' : Container();
          },
          onChanged: (values){
            setState(() {
              _selectedBuses = values;
            });
          },
        );
      }
    }
    else{
      return Center(child: CircularProgressIndicator());
    }
  }

  void _getBuses(String id){
    setState(() {
      _loadingBuses = true;
      Request.getAllBuses(id).then((value){
        if(value != null){
          setState(() {
            _noBuses = false;
            _buses = value;
            _fillBusesItems();
            _selectedBuses = [0];
            _loadingBuses = false;
          });
        }
        else{
          setState(() {
            _loadingBuses = false;
            _noBuses = true;
          });
        }
      });
    });
  }

  void _fillBusesItems(){
    _busesItems = [];

    _buses.forEach((bus) {
      bus['platforms'].forEach((platform){
        _busesItems.add(DropdownMenuItem<String>(
          value: bus["name"] + '/' + '$platform',
          child: Text(bus["name"] + ' ' + '(Pl. $platform)',
            style: TextStyle(color: Colors.black),
          ),
        ));
      });
    });
  }
}
