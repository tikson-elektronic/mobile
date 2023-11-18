// To parse this JSON data, do
//
//     final config = configFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Config {
  bool initialConfig;
  String username;
  String email;
  String password;
  bool demo;
  String mqttServerUri;
  int mqttServerPort;
  String mqttUsername;
  String mqttPassword;
  String mqttTopic;
  int profile;

  Config({
    required this.initialConfig,
    required this.username,
    required this.email,
    required this.password,
    required this.demo,
    required this.mqttServerUri,
    required this.mqttServerPort,
    required this.mqttUsername,
    required this.mqttPassword,
    required this.mqttTopic,
    required this.profile,
  });

  Config copyWith({
    bool? initialConfig,
    String? username,
    String? email,
    String? password,
    bool? demo,
    String? mqttServerUri,
    int? mqttServerPort,
    String? mqttUsername,
    String? mqttPassword,
    String? mqttTopic,
    int? profile,
  }) =>
      Config(
        initialConfig: initialConfig ?? this.initialConfig,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        demo: demo ?? this.demo,
        mqttServerUri: mqttServerUri ?? this.mqttServerUri,
        mqttServerPort: mqttServerPort ?? this.mqttServerPort,
        mqttUsername: mqttUsername ?? this.mqttUsername,
        mqttPassword: mqttPassword ?? this.mqttPassword,
        mqttTopic: mqttTopic ?? this.mqttTopic,
        profile: profile ?? this.profile,
      );

  factory Config.fromRawJson(String str) => Config.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    initialConfig: json["initial_config"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    demo: json["demo"],
    mqttServerUri: json["mqtt_server_uri"],
    mqttServerPort: json["mqtt_server_port"],
    mqttUsername: json["mqtt_username"],
    mqttPassword: json["mqtt_password"],
    mqttTopic: json["mqtt_topic"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "initial_config": initialConfig,
    "username": username,
    "email": email,
    "password": password,
    "demo": demo,
    "mqtt_server_uri": mqttServerUri,
    "mqtt_server_port": mqttServerPort,
    "mqtt_username": mqttUsername,
    "mqtt_password": mqttPassword,
    "mqtt_topic": mqttTopic,
    "profile": profile,
  };
}
