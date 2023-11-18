import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpms/notifications/bloc/notifications_bloc_bloc.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    final notificationsBloc = BlocProvider.of<NotificationsBloc>(context);

    return BlocBuilder<NotificationsBloc, NotificationsBlocState>(
        builder: (context, message) =>
        notificationsBloc.state is NotificationReceivedState
            ? SingleChildScrollView(
          child: Column(children: [
            Card(
              child: Container(decoration: BoxDecoration(color: Colors.red),),)
          ]),
        )
            : Text("no notifications"));
  }
}
