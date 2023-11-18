import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class MQTTClientManager {
  late MqttServerClient client;
  String respose = "";

  Future<int> connect(MqttServerClient client, username, password) async {
    this.client = client;
    var uuid = const Uuid();

    client.autoReconnect = true;
    client.logging(on: true);
    client.setProtocolV311();
    client.keepAlivePeriod = 100;
    client.connectTimeoutPeriod = 100;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(uuid.v4())
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean()
        .authenticateAs(username, password)// Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    //print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
      respose = "connected";
    } on NoConnectionException catch (e) {
      respose = e as String;
      print('MQTTClient::Client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      respose = e as String;      
      print('MQTTClient::Socket exception - $e');
      client.disconnect();
    }
    return 0;
  }

  void disconnect(){
    client.disconnect();
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void onConnected() {
    //print('MQTTClient::Connected');
  }

  void onDisconnected() {
    //print('MQTTClient::Disconnected');
  }

  void onSubscribed(String topic) {
    //print('MQTTClient::Subscribed to topic: $topic');
  }

  void pong() {
    //print('MQTTClient::Ping response received');
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return client.updates;
  }
}