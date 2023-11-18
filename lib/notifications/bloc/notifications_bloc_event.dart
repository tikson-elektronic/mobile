part of 'notifications_bloc_bloc.dart';

abstract class NotificationsBlocEvent {}

class NotificationReceivedEvent extends NotificationsBlocEvent {
  final String notification;

  NotificationReceivedEvent(this.notification);
}
