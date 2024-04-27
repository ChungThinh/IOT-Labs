import 'dart:async';

class AdafruitFeed {
  final _humidityController = StreamController<String>();
  final _temperatureController = StreamController<String>();
  final _lightController = StreamController<String>();
  final _lampController = StreamController<int>();

  Stream<String> get humidityStream => _humidityController.stream;
  Stream<String> get temperatureStream => _temperatureController.stream;
  Stream<String> get lightStream => _lightController.stream;
  Stream<int> get lampStream => _lampController.stream;

  AdafruitFeed(
      {String? initialHumidity,
      String? initialTemperature,
      String? initialLight,
      int? initialLamp}) {
    if (initialHumidity != null) {
      _humidityController.sink.add(initialHumidity);
    }
    if (initialTemperature != null) {
      _temperatureController.sink.add(initialTemperature);
    }
    if (initialLight != null) {
      _lightController.sink.add(initialLight);
    }
    if (initialLamp != null) {
      _lampController.sink.add(initialLamp);
    }
  }

  void addHumidity(String value) {
    _humidityController.sink.add(value);
  }

  void addTemperature(String value) {
    _temperatureController.sink.add(value);
  }

  void addLight(String value) {
    _lightController.sink.add(value);
  }

  void addLamp(int value) {
    _lampController.sink.add(value);
  }

  void dispose() {
    _humidityController.close();
    _temperatureController.close();
    _lightController.close();
    _lampController.close();
  }
}
