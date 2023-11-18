part of 'mqtt_bloc.dart';

// Define events
abstract class MqttEvent {}

class UpdateTokenEvent extends MqttEvent {
  final String token;

  UpdateTokenEvent(this.token);
}

class UpdateCredentialsEvent extends MqttEvent {
  final String username;
  final String password;

  UpdateCredentialsEvent(this.username, this.password);
}

class DisconnectedEvent extends MqttEvent {}

class DisconnectEvent extends MqttEvent {}

class ConnectEvent extends MqttEvent {}

class ConnectingEvent extends MqttEvent {}

class ConnectedEvent extends MqttEvent {}

class MessageReceivedEvent extends MqttEvent {
  final String message;

  MessageReceivedEvent(this.message);
}

class SubscribeEvent extends MqttEvent {
  final String topic;

  SubscribeEvent(this.topic);
}

class SendMessageEvent extends MqttEvent {
  final String topic;
  final String message;

  SendMessageEvent(this.topic, this.message);
}

class UpdateServerEvent extends MqttEvent {
  final String serverUri;

  UpdateServerEvent(this.serverUri);
}

class UpdatePortEvent extends MqttEvent {
  final int port;

  UpdatePortEvent(this.port);
}

class UpdateTopicEvent extends MqttEvent {
  final String topic;

  UpdateTopicEvent(this.topic);
}

class AddTopicEvent extends MqttEvent {
  final String newTopic;

  AddTopicEvent(this.newTopic);
}