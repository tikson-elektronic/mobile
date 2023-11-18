import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpms/bloc/mqtt_bloc.dart';

import '../models/settings_categories.dart';
import '../utils/utils.dart';

class ShoreAScreen extends StatefulWidget {
  const ShoreAScreen({Key? key}) : super(key: key);

  @override
  State<ShoreAScreen> createState() => _ShoreAScreenState();
}

class _ShoreAScreenState extends State<ShoreAScreen> {
  final List<SettingCategory> _categories = const [
    SettingCategory(1, "400 V", "#A9CCE3"),
    SettingCategory(2, "400 V", "#C5F0B3"),
    SettingCategory(3, "400 V", "#A9CCE3"),
    SettingCategory(4, "30 A", "#C5F0B3"),
    SettingCategory(5, "32 A", "#A9CCE3"),
    SettingCategory(6, "29 A", "#C5F0B3")
  ];

  @override
  Widget build(BuildContext context) {
    final mqttBloc = BlocProvider.of<MqttBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Shore A'),
        ),
        body: BlocBuilder<MqttBloc, MqttState>(
          builder: (context, message) => mqttBloc.state is MessageReceivedState
              ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(8),
                      height: 200,
                      child: Card(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    "Meters",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    "${mqttBloc.fpms.shoreA.meters[0]}V",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    "${mqttBloc.fpms.shoreA.meters[1]}A",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    "${mqttBloc.fpms.shoreA.meters[2]}Hz",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: ElevatedButton(
                                  onLongPress: () {},
                                  onPressed: () {},
                                  child: Text("START"),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: ElevatedButton(
                                  onLongPress: () {},
                                  onPressed: () {},
                                  child: Text("CLOSE"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    height: 300,
                    child: Card(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  "Alarms",
                                  style: TextStyle(fontSize: 30),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ))
              : Center(
            child: Column(
              children: const [
                CircularProgressIndicator(color: Colors.orange),
                Text(
                    "Please check to setup if loading takes more than 3 seconds")
              ],
            ),
          ),
        ));
  }
}

class TileCategory extends StatelessWidget {
  final SettingCategory _category;

  const TileCategory(this._category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            _navigateToBooksWithCategory(context, _category);
          },
          child: Container(
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: hexToColor(_category.colorBg)),
              child: Text(
                _category.name,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              )),
        ));
  }

  void _navigateToBooksWithCategory(
      BuildContext context, SettingCategory category) {}
}
