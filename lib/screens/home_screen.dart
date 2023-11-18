import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpms/bloc/mqtt_bloc.dart';
import 'package:fpms/screens/port_gen_screen.dart';
import 'package:fpms/screens/shore_a_screen.dart';
import 'package:fpms/screens/shore_b_screen.dart';
import 'package:fpms/screens/stbd_gen_screen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController animationController;

  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? PortraitHomeScreen()
        : LandscapeHomeScreen();
  }
}

class LandscapeHomeScreen extends StatefulWidget {
  const LandscapeHomeScreen({Key? key}) : super(key: key);

  @override
  State<LandscapeHomeScreen> createState() => _LandscapeHomeScreenState();
}

class _LandscapeHomeScreenState extends State<LandscapeHomeScreen> {
  @override
  Widget build(BuildContext context) {
    var availableHeight = MediaQuery.of(context).size.height;
    var availableWidth = MediaQuery.of(context).size.width;

    final mqttBloc = BlocProvider.of<MqttBloc>(context);

    return BlocBuilder<MqttBloc, MqttState>(
      builder: (context, message) => mqttBloc.state is ConnectingState ? Center(child: Text("Connecting..."),) : mqttBloc.state is MessageReceivedState
          ? SingleChildScrollView(
              child: Column(
                children: [
                  // Header buttons
                  Padding(padding: const EdgeInsets.only(top: 5), child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: 80,
                            height: 60,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/Logo.png"),
                                )),
                          ),
                          Container(
                            width: 60,
                            height: 30,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/alert.png"),
                                )),
                          )
                        ],
                      ),
                      Text(
                        mqttBloc.fpms.pms.settings.modes.manualAuto ? "AUTO" : "MANUAL",
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 60,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/reset.png"),
                                )),
                          ),
                          Container(
                            width: 80,
                            height: 60,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/Logo.png"),
                                )),
                          )
                        ],
                      )
                    ],
                  ),),
                  // Pms layout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          mqttBloc.fpms.port.status.precense ? Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 0, top: 15),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: mqttBloc.fpms.port.meters[0] > 50
                                          ? Colors.green
                                          : Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: availableWidth / 5,
                                height: availableHeight / 4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Image.asset(
                                          'assets/images/generator.png'),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${mqttBloc.fpms.port.meters[0]} V',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.port.meters[1]} A',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.port.meters[1]} Hz',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 3),
                                color: mqttBloc.fpms.port.status.online
                                    ? Colors.green
                                    : Colors.grey,
                                height: 20,
                                width: 30,
                              ),
                              Transform.rotate(
                                angle:
                                    mqttBloc.fpms.port.status.online ? 0 : 45,
                                child: Container(
                                  color: mqttBloc.fpms.port.status.online && mqttBloc.fpms.port.meters[0] > 50
                                      ? Colors.green
                                      : Colors.grey,
                                  width: 40,
                                  height: 20,
                                ),
                              ),
                              Container( // port gen drop
                                color: mqttBloc.fpms.pms.feedback.busALive
                                    ? Colors.green
                                    : Colors.grey,
                                height: 20,
                                width: 30,
                              )
                            ],
                          ) : SizedBox(width: availableWidth / 5,height: availableHeight / 4,),
                          mqttBloc.fpms.stbd.status.precense ? Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 0, top: 15),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: mqttBloc.fpms.shoreA.meters[0] > 50
                                          ? Colors.green
                                          : Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: availableWidth / 5,
                                height: availableHeight / 4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 50,
                                      child: Image.asset(
                                          'assets/images/shore_plug.png'),
                                    ),
                                    const SizedBox(width: 10,),
                                    Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${mqttBloc.fpms.shoreA.meters[0]} V',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.shoreA.meters[1]} A',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.shoreA.meters[2]} Hz',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 3),
                                color: mqttBloc.fpms.shoreA.meters[0] > 50
                                    ? Colors.green
                                    : Colors.grey,
                                height: 20,
                                width: 30,
                              ),
                              Transform.rotate(
                                angle:
                                    mqttBloc.fpms.shoreA.status.online ? 0 : 45,
                                child: Container(
                                  color: mqttBloc.fpms.shoreA.status.online && mqttBloc.fpms.shoreA.meters[0] > 50
                                      ? Colors.green
                                      : Colors.grey,
                                  width: 40,
                                  height: 20,
                                ),
                              ),
                              Container(
                                color: mqttBloc.fpms.pms.feedback.busALive
                                    ? Colors.green
                                    : Colors.grey,
                                height: 20,
                                width: 30,
                              )
                            ],
                          ) : SizedBox(width: availableWidth / 5,height: availableHeight / 4,),
                        ],
                      ),
                      //Main bus A
                      SizedBox(
                        width: 20,
                        height: 200,
                        child: Container(
                          color: mqttBloc.fpms.pms.feedback.busALive
                              ? Colors.green
                              : Colors.grey,
                          height: double.infinity,
                          width: 20,
                        ),
                      ),
                      //Tie breaker row
                      Container(
                        margin: const EdgeInsets.only(top: 180),
                        child: Row(
                          children: [
                            Container(
                              color: Colors.white60,
                              width: 20,
                              height: 20,
                              child: Container(
                                color: mqttBloc.fpms.pms.feedback.busALive
                                    ? Colors.green
                                    : Colors.grey,
                                height: double.infinity,
                                width: 20,
                              ),
                            ),
                            Transform.rotate(
                              angle:
                                  mqttBloc.fpms.pms.feedback.tieBreakerClosed ? 0 : 45,
                              child: Container(
                                color: mqttBloc.fpms.shoreA.status.online
                                    ? Colors.green
                                    : Colors.grey,
                                width: 50,
                                height: 20,
                              ),
                            ),
                            Container(
                              color: Colors.white60,
                              width: 20,
                              height: 20,
                              child: Container(
                                color: mqttBloc.fpms.pms.feedback.busBLive
                                    ? Colors.green
                                    : Colors.grey,
                                height: double.infinity,
                                width: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Main bus bar B
                      Container(
                        margin: EdgeInsets.only(left: 0),
                        color: Colors.white60,
                        width: 20,
                        height: 200,
                        child: Container(
                          color: mqttBloc.fpms.pms.feedback.busBLive
                              ? Colors.green
                              : Colors.grey,
                          height: double.infinity,
                          width: 20,
                        ),
                      ),
                      Column(
                        children: [
                          mqttBloc.fpms.stbd.status.precense ? Row(
                            children: [
                              Container(
                                color: mqttBloc.fpms.pms.feedback.busBLive
                                    ? Colors.green
                                    : Colors.grey,
                                height: 20,
                                width: 30,
                              ),
                              Transform.rotate(
                                angle:
                                    mqttBloc.fpms.stbd.status.online ? 0 : 45,
                                child: Container(
                                  color: mqttBloc.fpms.stbd.status.online && mqttBloc.fpms.stbd.meters[0] > 50
                                      ? Colors.green : Colors.grey,
                                  width: 40,
                                  height: 20,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 3),
                                color: mqttBloc.fpms.stbd.meters[0] > 50
                                    ? Colors.green
                                    : Colors.grey,
                                height: 20,
                                width: 30,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 0, top: 15),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: mqttBloc.fpms.stbd.meters[0] > 50
                                          ? Colors.green
                                          : Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: availableWidth / 4.8,
                                height: availableHeight / 4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(6),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${mqttBloc.fpms.stbd.meters[0]} V',
                                              style: TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.stbd.meters[1]} A',
                                              style: TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.stbd.meters[2]} Hz',
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 50,
                                      child: Image.asset(
                                          'assets/images/generator.png'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ): SizedBox(width: availableWidth / 5,height: availableHeight / 4,),
                          mqttBloc.fpms.shoreB.status.precense ? Row(
                            children: [
                              Container(
                                color: mqttBloc.fpms.pms.feedback.busBLive
                                    ? Colors.green
                                    : Colors.grey,
                                height: 20,
                                width: 30,
                              ),
                              Transform.rotate(
                                angle:
                                    mqttBloc.fpms.shoreB.status.online ? 0 : 45,
                                child: Container(
                                  color: mqttBloc.fpms.shoreB.status.online && mqttBloc.fpms.shoreB.meters[0] > 50
                                      ? Colors.green
                                      : Colors.grey,
                                  width: 40,
                                  height: 20,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 3),
                                color: mqttBloc.fpms.shoreA.meters[0] > 50
                                    ? Colors.green
                                    : Colors.grey,
                                height: 20,
                                width: 30,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 0, top: 10),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: mqttBloc.fpms.shoreB.meters[0] > 50
                                          ? Colors.green
                                          : Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: availableWidth / 4.8,
                                height: availableHeight / 4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(6),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${mqttBloc.fpms.shoreB.meters[0]} V',
                                              style: TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.shoreB.meters[1]} A',
                                              style: TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.shoreB.meters[2]} Hz',
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 50,
                                      child: Image.asset(
                                          'assets/images/shore_plug.png'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ) : SizedBox(width: availableWidth / 5,height: availableHeight / 4,),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          : Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(color: Colors.orange),
                  Text(
                      "Please check to setup if loading takes more than 3 seconds")
                ],
              ),
            ),
    );
  }
}

class PortraitHomeScreen extends StatefulWidget {
  const PortraitHomeScreen({Key? key}) : super(key: key);

  @override
  State<PortraitHomeScreen> createState() => _PortraitHomeScreenState();
}

class _PortraitHomeScreenState extends State<PortraitHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mqttBloc = BlocProvider.of<MqttBloc>(context);

    var availableHeight = MediaQuery.of(context).size.height;
    var availableWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<MqttBloc, MqttState>(
      builder: (contenxt, message) => mqttBloc.state is MessageReceivedState
          ? Row(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      mqttBloc.fpms.port.status.precense ? Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => PortGenScreen()));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 15, right: 3, top: 15),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: mqttBloc.fpms.port.meters[0] > 50
                                          ? Colors.green
                                          : Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: availableWidth / 2.2,
                                height: availableHeight / 7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      child: Card(
                                        color: Colors.transparent,
                                        elevation: 8,
                                        child: Image.asset(
                                            'assets/images/${mqttBloc.fpms.port.imageUri}'),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${mqttBloc.fpms.port.meters[0].toString() ?? '0'} V',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.port.meters[1].toString() ?? '0'} A',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.port.meters[2].toString() ?? '0'} Hz',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // Feeder
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color: mqttBloc.fpms.port.meters[0] > 50 ? Colors.green : Colors.grey,
                              ),
                            ),
                            Transform.rotate(
                              // Breaker
                              angle: mqttBloc.fpms.port.status.online ? 0 : 45,
                              child: Container(
                                color: (mqttBloc.fpms.port.status.online && mqttBloc.fpms.port.meters[0] > 50) ? Colors.green : Colors.grey,
                                width: availableWidth / 8,
                                height: 20,
                              ),
                            ),
                            Container(
                              // Main bus drop
                              color:
                              mqttBloc.fpms.pms.feedback.busALive ? Colors.green : Colors.grey,
                              width: availableWidth / 8,
                              height: 20,
                            )
                          ],
                        ),
                      ): SizedBox(height: 130, width: 300,),
                      mqttBloc.fpms.shoreA.status.precense ? Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShoreAScreen()));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15, right: 3, top: 15),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: mqttBloc.fpms.shoreA.meters[0] > 100
                                          ? Colors.green
                                          : Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: availableWidth / 2.2,
                                height: availableHeight / 7,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      child: Card(
                                        color: Colors.transparent,
                                        elevation: 8,
                                        child: Image.asset(
                                            'assets/images/${mqttBloc.fpms.shoreA.imageUri}'),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${mqttBloc.fpms.shoreA.meters[0].toString() ?? '0'} V',
                                              style:
                                              const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.shoreA.meters[1].toString() ?? '0'} A',
                                              style:
                                              const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.shoreA.meters[2].toString() ?? '0'} Hz',
                                              style:
                                              const TextStyle(fontSize: 22),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // Feeder
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color: mqttBloc.fpms.shoreA.meters[0] > 50
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            Transform.rotate(
                              // Breaker
                              angle: mqttBloc.fpms.shoreA.status.online ? 0 : 45,
                              child: Container(
                                color: mqttBloc.fpms.shoreA.status.online
                                    ? Colors.green
                                    : Colors.grey,
                                width: availableWidth / 8,
                                height: 20,
                              ),
                            ),
                            Container(
                              // Main bus drop
                              color: mqttBloc.fpms.pms.feedback.busALive
                                  ? Colors.green
                                  : Colors.grey,
                              width: availableWidth / 8,
                              height: 20,
                            )
                          ],
                        ),
                      ): SizedBox(height: 130, width: 300,),
                      mqttBloc.fpms.stbd.status.precense ? Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => StbdGenScreen()));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 15, right: 3, top: 15),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: mqttBloc.fpms.stbd.meters[0] > 50
                                          ? Colors.green
                                          : Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: availableWidth / 2.2,
                                height: availableHeight / 7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      child: Card(
                                        color: Colors.transparent,
                                        elevation: 8,
                                        child: Image.asset(
                                            'assets/images/${mqttBloc.fpms.stbd.imageUri}'),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${mqttBloc.fpms.stbd.meters[0].toString() ?? '0'} V',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.stbd.meters[1].toString() ?? '0'} A',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.stbd.meters[2].toString() ?? '0'} Hz',
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // Feeder
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color: mqttBloc.fpms.stbd.meters[0] > 50 ? Colors.green : Colors.grey,
                              ),
                            ),
                            Transform.rotate(
                              // Breaker
                              angle: mqttBloc.fpms.stbd.status.online ? 0 : 45,
                              child: Container(
                                color: (mqttBloc.fpms.stbd.status.online && mqttBloc.fpms.stbd.meters[0] > 50) ? Colors.green : Colors.grey,
                                width: availableWidth / 8,
                                height: 20,
                              ),
                            ),
                            Container(
                              // Main bus drop
                              color:
                              mqttBloc.fpms.pms.feedback.busBLive ? Colors.green : Colors.grey,
                              width: availableWidth / 8,
                              height: 20,
                            )
                          ],
                        ),
                      ): SizedBox(height: 130, width: 300,),
                      mqttBloc.fpms.shoreB.status.precense ? Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShoreBScreen()));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15, right: 3, top: 15),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: mqttBloc.fpms.shoreB.meters[0] > 100
                                          ? Colors.green
                                          : Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: availableWidth / 2.2,
                                height: availableHeight / 7,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      child: Card(
                                        color: Colors.transparent,
                                        elevation: 8,
                                        child: Image.asset(
                                            'assets/images/${mqttBloc.fpms.shoreB.imageUri}'),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${mqttBloc.fpms.shoreB.meters[0].toString() ?? '0'} V',
                                              style:
                                                  const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.shoreB.meters[1].toString() ?? '0'} A',
                                              style:
                                                  const TextStyle(fontSize: 22),
                                            ),
                                            Text(
                                              '${mqttBloc.fpms.shoreB.meters[2].toString() ?? '0'} Hz',
                                              style:
                                                  const TextStyle(fontSize: 22),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // Feeder
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color: mqttBloc.fpms.shoreB.meters[0] > 50
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            Transform.rotate(
                              // Breaker
                              angle: mqttBloc.fpms.shoreB.status.online ? 0 : 45,
                              child: Container(
                                color: mqttBloc.fpms.shoreB.status.online
                                    ? Colors.green
                                    : Colors.grey,
                                width: availableWidth / 8,
                                height: 20,
                              ),
                            ),
                            Container(
                              // Main bus drop
                              color: mqttBloc.fpms.pms.feedback.busBLive
                                  ? Colors.green
                                  : Colors.grey,
                              width: availableWidth / 8,
                              height: 20,
                            )
                          ],
                        ),
                      ): SizedBox(height: 130, width: 300,),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                        child: Container(
                      // Bus bar A
                      width: 20,
                      color: mqttBloc.fpms.pms.feedback.busALive
                          ? Colors.green
                          : Colors.grey,
                    )),
                    Transform.rotate(
                      // Tie breaker
                      angle:
                          mqttBloc.fpms.pms.feedback.tieBreakerClosed ? 0 : 45,
                      child: Container(
                        color: (mqttBloc.fpms.pms.feedback.busALive ||
                                    mqttBloc.fpms.pms.feedback.busBLive) &&
                                mqttBloc.fpms.pms.feedback.tieBreakerClosed
                            ? Colors.green
                            : Colors.grey,
                        width: 20,
                        height: availableHeight / 14,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      // Bus bar B
                      width: 20,
                      color: mqttBloc.fpms.pms.feedback.busBLive
                          ? Colors.green
                          : Colors.grey,
                    ))
                  ],
                )
              ],
            )
          : Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Your aren't  connected, please go to setup and load the configuration", style: TextStyle(fontSize: 24)),
                ),
              )
            ),
    );
  }
}
