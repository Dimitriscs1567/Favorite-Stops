import 'bus.dart';

class Stop {
  String _id;
  String _name;
  List<Bus> _buses;

  Stop(this._id, this._name, this._buses);

  Stop.fromJson(dynamic stop) {
    _id = stop["id"];
    _name = stop["name"];
  }

  String get id => this._id;

  String get name => this._name;

  void addBus(Bus bus) {
    this._buses.add(bus);
  }
}
