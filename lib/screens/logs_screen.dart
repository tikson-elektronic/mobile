import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpms/bloc/mqtt_bloc.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    final mqttBloc = BlocProvider.of<MqttBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Logs"),
        ),
        body: BlocBuilder<MqttBloc, MqttState>(
          builder: (context, message) => mqttBloc.state is MessageReceivedState
              ? ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: mqttBloc.fpms.pms.logs.general.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 130,
                        child: Card(
                          elevation: 16,
                          color: Colors.amber,
                          child: Center(
                              child: Text(
                            '${mqttBloc.fpms.pms.logs.general[index]}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          )),
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                )
              : Center(
                  child: Text(
                    "You are not connected, go to setup to connect",
                    style: TextStyle(fontSize: 26),
                  ),
                ),
        ));
  }
}
