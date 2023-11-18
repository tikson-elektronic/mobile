import 'package:bloc/bloc.dart';
import 'package:fpms/models/config_file.dart';
import 'package:meta/meta.dart';

part 'config_event.dart';
part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  late Config configuration;
  bool configurationReady = false;

  ConfigBloc() : super(ConfigInitial()) {
    on<UpdateConfigurationEvent>((event, emit) {
      // TODO: implement event handler
      configuration = event.configuration;
      emit(UpdateConfigurationState(configuration));
    });
  }
}
