class Bus {
  String _name;
  String _platform;
  String _type;

  Bus(this._name, this._platform, this._type);

  Bus.fromJson(dynamic bus) {
    _name = bus["name"];
    _platform = bus["track"] ?? bus["platform"];
    _type = bus["type"];
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
}
