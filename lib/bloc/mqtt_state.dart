part of 'mqtt_bloc.dart';

// Define states
class MqttState {}

class UpdateTokenState extends MqttState {
  final String token;

  UpdateTokenState(this.token);
}

class UpdateCredentialsState extends MqttState {
  final String username;
  final String password;

  UpdateCredentialsState(this.username, this.password);
}

class DisconnectedState extends MqttState {}

class ConnectingState extends MqttState {}

class ConnectedState extends MqttState {
  final bool connected;

  ConnectedState(this.connected);
}

class MessageReceivedState extends MqttState {
  final String message;

  MessageReceivedState(this.message);
}

class SendMessageState extends MqttState {
  final String topic;
  final String message;

  SendMessageState(this.topic, this.message);
}

class UpdateServerUriState extends MqttState {
  final String uri;

  UpdateServerUriState(this.uri);
}

class UpdateServerPortState extends MqttState {
  final int port;

  UpdateServerPortState(this.port);
}

class UpdatedServerPortState extends MqttState {
  final String serverUri;
  final int port;

  UpdatedServerPortState(this.serverUri, this.port);
}

class UpdateTopicState extends MqttState {
  final String topic;

  UpdateTopicState(this.topic);
}

class AddTopicState extends MqttState {
  final String newTopic;

  AddTopicState(this.newTopic);
}