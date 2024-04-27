import 'package:demoiot/MQTT/adafruit_stream.dart';
import 'package:demoiot/modules/mqtt_ui_page.dart';
import 'package:flutter/material.dart';
// import 'package:toggle_switch/toggle_switch.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

AdafruitFeed mystream = AdafruitFeed(
    initialTemperature: "30",
    initialHumidity: "50",
    initialLight: "100",
    initialLamp: 0);

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MqttPage(title: 'Labbs05: 2012103'),
    );
  }
}
