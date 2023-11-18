part of 'notifications_bloc_bloc.dart';

abstract class NotificationsBlocState {}

class NotificationReceivedState extends NotificationsBlocState {
  final String notification;

  NotificationReceivedState(this.notification);
}