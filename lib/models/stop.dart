import 'bus.dart';

class Stop {
  String _id;
  String _name;
  List<Bus> _busses;

  Stop(this._id, this._name, this._busses);

  Stop.fromJson(dynamic stop) {
    _id = stop["id"];
    _name = stop["name"];
    if (stop.containsKey("busses")) {
      stop["busses"].forEach((bus) => addBus(Bus.fromJson(bus)));
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = Map<String, dynamic>();

    result.addAll({
      "name": _name,
      "id": _id,
      "busses": _busses.map((bus) => bus.toJson()).toList(),
    });

    return result;
  }

  String get id => this._id;

  String get name => this._name;

  List<Bus> get busses => this._busses;

  void addBus(Bus bus) {
    if (_busses == null) {
      _busses = List<Bus>();
    }
    this._busses.add(bus);
  }
}
