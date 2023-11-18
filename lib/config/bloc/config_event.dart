part of 'config_bloc.dart';

abstract class ConfigEvent {}


class UpdateConfigurationEvent extends ConfigEvent {
  final Config configuration;

  UpdateConfigurationEvent(this.configuration);
}