import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpms/bloc/mqtt_bloc.dart';

class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({Key? key}) : super(key: key);

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  @override
  Widget build(BuildContext context) {
    final mqttBloc = BlocProvider.of<MqttBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Alarms"),
        ),
        body: BlocBuilder<MqttBloc, MqttState>(
          builder: (context, message) => mqttBloc.state is MessageReceivedState
              ? SingleChildScrollView(
                  child: mqttBloc.fpms.pms.alarms.general.isNotEmpty ? Column(
                  children: mqttBloc.fpms.pms.alarms.general.map((alarm) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: alarm["active"] ? Container(
                        height: 50,
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Card(
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${alarm["name"]}"),
                              const Icon(Icons.notifications_active)
                            ],
                          ),
                        ),
                      ) : const SizedBox(),
                    );
                  }).toList(),
                ) : const Text('No alarms'))
              : const Center(
                  child: Text(
                    "You are not connected, go to setup to connect",
                    style: TextStyle(fontSize: 26),
                  ),
                ),
        ));
  }
}
