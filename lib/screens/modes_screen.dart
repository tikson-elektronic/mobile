import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpms/bloc/mqtt_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../mqtt/mqtt_handler.dart';

class ModesScreen extends StatefulWidget {
  const ModesScreen({Key? key}) : super(key: key);

  @override
  State<ModesScreen> createState() => _ModesScreenState();
}

class _ModesScreenState extends State<ModesScreen> {
  bool checkBit(int value, int bit) => (value & (1 << bit)) != 0;

  @override
  Widget build(BuildContext context) {
    final mqttBloc = BlocProvider.of<MqttBloc>(context);

    return BlocBuilder<MqttBloc, MqttState>(
        builder: (context, message) => Scaffold(
              appBar: AppBar(
                title: Text("modes"),
              ),
              body: mqttBloc.state is MessageReceivedState
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc
                                          .fpms.pms.settings.modes.manualAuto
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Auto: ${mqttBloc.fpms.pms.settings.modes.manualAuto ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc.fpms.pms.settings.modes.ovr
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'OVR mode: ${mqttBloc.fpms.pms.settings.modes.ovr ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc.fpms.pms.settings.modes
                                          .oneTimeTransfer
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'One Time Transfer mode: ${mqttBloc.fpms.pms.settings.modes.oneTimeTransfer ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc
                                          .fpms.pms.settings.modes.protection
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Split bus: ${mqttBloc.fpms.pms.settings.modes.splitBus ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc
                                          .fpms.pms.settings.modes.protection
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Dual gen: ${mqttBloc.fpms.pms.settings.modes.dualGen ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc
                                          .fpms.pms.settings.modes.protection
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Prefered gen: ${mqttBloc.fpms.pms.settings.modes.preferedGen ? 'PORT' : 'STBD'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc.fpms.pms.settings.modes
                                          .seamlessTransfer
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Seamless Transfer: ${mqttBloc.fpms.pms.settings.modes.seamlessTransfer ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc
                                          .fpms.pms.settings.modes.nbootsShoreA
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'NBoots Shore A: ${mqttBloc.fpms.pms.settings.modes.nbootsShoreA ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc
                                          .fpms.pms.settings.modes.nbootsShoreB
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'NBoots Shore B: ${mqttBloc.fpms.pms.settings.modes.nbootsShoreB ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc.fpms.pms.settings.modes.series
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Series: ${mqttBloc.fpms.pms.settings.modes.series ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc.fpms.pms.settings.modes
                                          .preferedSwgear
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Prefered Swgear: ${mqttBloc.fpms.pms.settings.modes.preferedSwgear ? 'PARALLEL' : 'SERIES'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc.fpms.pms.settings.modes
                                          .singleShoreCombine
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Single shore combine: ${mqttBloc.fpms.pms.settings.modes.singleShoreCombine ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: mqttBloc.fpms.pms.settings.modes
                                          .splitBusAutoOff
                                      ? Colors.green
                                      : Colors.grey),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Split bus auto off: ${mqttBloc.fpms.pms.settings.modes.splitBusAutoOff ? 'ON' : 'OFF'}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                        ],
                      ),
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
