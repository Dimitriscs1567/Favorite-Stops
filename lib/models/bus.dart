class Bus {
  String _name;
  String _platform;
  String _type;

  Bus(this._name, this._platform, this._type);

  Bus.fromJson(dynamic bus) {
    _name = bus["name"];
    _platform = bus["track"];
    _type = bus["type"];
  }

  String get name => this._name;

  String get platform => this._platform;

  String get type => this._type;
}
