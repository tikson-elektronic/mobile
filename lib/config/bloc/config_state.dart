part of 'config_bloc.dart';

@immutable
abstract class ConfigState {}

class ConfigInitial extends ConfigState {}

class UpdateConfigurationState extends ConfigState {
  final Config configuration;

  UpdateConfigurationState(this.configuration);
}
