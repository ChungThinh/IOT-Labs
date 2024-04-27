import 'package:demoiot/main.dart';
import 'package:demoiot/modules/mqtt_button.dart';
import 'package:demoiot/modules/mqtt_data_display.dart';
import 'package:flutter/material.dart';
import '../MQTT/mqtt_helper.dart';

class MqttPage extends StatefulWidget {
  const MqttPage({super.key, required this.title});
  final String title;

  @override
  MqttPageState createState() => MqttPageState();
}

class MqttPageState extends State<MqttPage> {
  late MQTTManager manager;

  final myValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    manager = MQTTManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<void>(
        future: initMQTT(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _body();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> initMQTT() async {
    await manager.initializeMQTTClient();
    manager.connect();
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        // _showData(),
        _button(),
      ],
    );
  }

  Widget _showData() {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: DataWidget(
              dataName: "Temperature",
              dataStream: mystream.temperatureStream,
              dataUnit: "℃",
              dataColor: Colors.red.shade400,
            )),
        Expanded(
            flex: 3,
            child: DataWidget(
              dataName: "Humidity",
              dataStream: mystream.humidityStream,
              dataUnit: "%",
              dataColor: Colors.lightBlue.shade300,
            )),
        Expanded(
            flex: 3,
            child: DataWidget(
              dataName: "Light",
              dataStream: mystream.lightStream,
              dataUnit: "lux",
              dataColor: Colors.yellow,
            )),
      ],
    );
  }

  Widget _button() {
    return Column(
      children: [
        ToggleButton(
            manager: manager,
            dataStream: mystream.lampStream,
            topic: manager.lampTopic),
        ToggleButton(
            manager: manager,
            dataStream: mystream.lampStream,
            topic: manager.lampTopic)
      ],
    );
  }

  void publish(String topic, String value) {
    manager.publish(topic, value);
  }
}
