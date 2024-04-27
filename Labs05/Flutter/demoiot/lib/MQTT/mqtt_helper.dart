// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:demoiot/main.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager {
  // Private instance of client
  MqttServerClient? _client;
  late String _humidityTopic;
  late String _temperatureTopic;
  late String _lightTopic;
  late String _lampTopic;
  String get lampTopic => _lampTopic;
  //Read file private.json
  Future<Map> _getBrokerAndKey() async {
    String connect = await rootBundle.loadString('assets/config/private.json');
    return (json.decode(connect));
  }

  Future<void> initializeMQTTClient() async {
    Map connectJson = await _getBrokerAndKey();
    _client = MqttServerClient(connectJson['broker'], connectJson['key']);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    /// Add the successful connection callback
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .authenticateAs(connectJson['username'], connectJson['key'])
        .withClientIdentifier("Flutter_Android")
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Adafruit client connecting....');
    _client!.connectionMessage = connMess;

    _humidityTopic = connectJson['topics']['humidity'];
    _temperatureTopic = connectJson['topics']['temperature'];
    _lightTopic = connectJson['topics']['light'];
    _lampTopic = connectJson['topics']['lamp'];
  }

  // Connect to the host
  // ignore: avoid_void_async
  void connect() async {
    try {
      print('EXAMPLE::Adafruit start client connecting....');
      await _client!.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('EXAMPLE::Disconnected');
    _client!.disconnect();
  }

  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
  }

  /// The successful connect callback
  void onConnected() {
    _client!.subscribe(_humidityTopic, MqttQos.atLeastOnce);
    _client!.subscribe(_temperatureTopic, MqttQos.atLeastOnce);
    _client!.subscribe(_lightTopic, MqttQos.atLeastOnce);
    _client!.subscribe(_lampTopic, MqttQos.atLeastOnce);

    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;

      final String value =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      if (topic == _humidityTopic) {
        mystream.addHumidity(value);
      } else if (topic == _temperatureTopic) {
        mystream.addTemperature(value);
      } else if (topic == _lightTopic) {
        mystream.addLight(value);
      } else if (topic == _lampTopic) {
        mystream.addLamp(int.parse(value));
      }
      print('EXAMPLE::$topic::$value');
    });
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }
}
