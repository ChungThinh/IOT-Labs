import 'package:demoiot/MQTT/mqtt_helper.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton(
      {super.key,
      required this.manager,
      required this.dataStream,
      required this.topic});
  final MQTTManager manager;
  final Stream dataStream;
  final String topic;
  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isSwitched = snapshot.data == 1;
          return ToggleSwitch(
            minWidth: 90.0,
            minHeight: 70.0,
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            icons: const [
              Icons.lightbulb,
              Icons.lightbulb_outline,
            ],
            iconSize: 30.0,
            initialLabelIndex: isSwitched ? 1 : 0,
            activeBgColors: const [
              [Colors.black45, Colors.black26],
              [Colors.yellow, Colors.orange]
            ],
            animate: true,
            curve: Curves.bounceInOut,
            onToggle: (index) {
              final newValue = index == 0 ? '0' : '1';
              widget.manager.publish(widget.topic, newValue);
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void publish(String topic, int value) {
    widget.manager.publish(topic, value.toString());
  }
}
