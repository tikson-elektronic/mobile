import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'notifications_bloc_event.dart';
part 'notifications_bloc_state.dart';

class NotificationsBloc extends Bloc<NotificationsBlocEvent, NotificationsBlocState> {
  final List<String> notifications = [];
  int notificationsCount = 0;

  NotificationsBloc() : super(NotificationReceivedState("No notifications")) {
    on<NotificationReceivedEvent>((event, emit) {
      notificationsCount++;
      notifications.add(event.notification);
    });
  }
}
