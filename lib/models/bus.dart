class Bus {
  String _name;
  String _platform;
  String _type;
  List<DateTime> _timetable;

  Bus(this._name, this._platform, this._type) {
    _timetable = List<DateTime>();
  }

  Bus.fromJson(dynamic bus) {
    _name = bus["name"];
    _platform = bus["track"] ?? bus["platform"];
    _type = bus["type"];
    _timetable = List<DateTime>();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = Map<String, dynamic>();

    result.addAll({
      "name": _name,
      "platform": _platform,
      "type": _type,
    });

    return result;
  }

  String get name => this._name;

  String get platform => this._platform;

  String get type => this._type;

  List<DateTime> get timetable => this._timetable;

  set timetable(List<DateTime> timetable) => this._timetable = timetable;
}
