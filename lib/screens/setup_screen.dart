import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpms/config/bloc/config_bloc.dart';
import 'package:fpms/models/config_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scan/scan.dart';

import '../bloc/mqtt_bloc.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  TextEditingController serverUriController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController topicController = TextEditingController();

  String qrcode = '';
  ImagePicker picker = ImagePicker();
  bool config_ready = false;
  String jsonData = "";

  late Config config;
  bool configReady = false;

  late File jsonFile;
  late Directory dir;
  String fileName = "config.json";
  bool fileExists = false;
  late Map<String, dynamic> fileContent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if(fileExists) {
        setState(() {
          fileContent = json.decode(jsonFile.readAsStringSync());
          config = Config.fromRawJson(jsonFile.readAsStringSync());
        });
      }
    });
  }

  void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }
  void writeToFile(String key, String value) {
    Map<String, String> content = {key: value};
    if (fileExists) {
      Map<String, String> jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/assets/test.json');
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/config.json');
    final data = await json.decode(response);
    setState(() {
      config = Config.fromJson(data);
    });
    jsonData = config.initialConfig.toString();
    configReady = true;
  }

  Future<void> writeToJson(Map<String, dynamic> data) async {

  }

  @override
  Widget build(BuildContext context) {
    final mqttBloc = BlocProvider.of<MqttBloc>(context);
    final configBloc = BlocProvider.of<ConfigBloc>(context);

    setState(() {
      readJson();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Setup"),
      ),
      body: BlocBuilder<MqttBloc, MqttState>(
          builder: (context, message) => SingleChildScrollView(
                child: BlocBuilder<ConfigBloc, ConfigState>(
                    builder: (context, message) => SingleChildScrollView(
                            child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 350,
                                height: 300,
                                padding: EdgeInsets.all(0),
                                child: Card(
                                  elevation: 16,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Server",
                                            style: TextStyle(fontSize: 26),
                                          ),
                                          Icon(Icons.monitor_heart_rounded, size: 60, color: mqttBloc.state is MessageReceivedState ? mqttBloc.fpms.pmsServer.heartbeat ? Colors.green : Colors.red : Colors.grey,)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      ElevatedButton(
                                        child: const Text("Select config QR"),
                                        onPressed: () async {
                                          XFile? res = await picker.pickImage(
                                              source: ImageSource.gallery);
                                          if (res != null) {
                                            String? str =
                                                await Scan.parse(res.path);
                                            if (str != null) {
                                              setState(() async {
                                                const asciiDecoder =
                                                    AsciiDecoder();
                                                qrcode = asciiDecoder
                                                    .convert(str
                                                        .split(' ')
                                                        .reversed
                                                        .map((item) =>
                                                            int.parse(item,
                                                                radix: 16))
                                                        .toList())
                                                    .toString();
                                                if (qrcode.split('#').length >
                                                    4) {
                                                  mqttBloc.add(
                                                      UpdateServerEvent(qrcode
                                                          .split('#')[0]));
                                                  mqttBloc.add(UpdatePortEvent(
                                                      int.parse(qrcode
                                                          .split('#')[1])));
                                                  mqttBloc.add(UpdateTopicEvent(
                                                      qrcode.split('#')[2]));
                                                  mqttBloc.add(
                                                      UpdateCredentialsEvent(
                                                          qrcode.split('#')[3],
                                                          qrcode
                                                              .split('#')[4]));

                                                  Map<String, dynamic> content = {
                                                      "initial_config": true,
                                                      "username": qrcode.split('#')[3],
                                                      "email": "",
                                                      "password": "",
                                                      "demo": false,
                                                      "mqtt_server_uri": qrcode.split('#')[0],
                                                      "mqtt_server_port": int.parse(qrcode.split('#')[1]),
                                                      "mqtt_username": qrcode.split('#')[3],
                                                      "mqtt_password": qrcode.split('#')[4],
                                                      "mqtt_topic": qrcode.split('#')[2],
                                                      "profile": 0,
                                                  };
                                                  createFile(content, dir, fileName);

                                                  await Future.delayed(
                                                      Duration(seconds: 1));
                                                  mqttBloc.add(ConnectEvent());
                                                  config_ready = true;
                                                } else {
                                                  config_ready = false;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        "The configuration QR is wrong"),
                                                    duration: Duration(
                                                        milliseconds: 3000),
                                                  ));
                                                }
                                              });
                                            }
                                          }
                                        },
                                      ),
                                      mqttBloc.state is MessageReceivedState
                                          ? Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(16),
                                                  child: Text(
                                                    "Packages: ${mqttBloc.packages_received}",
                                                    style:
                                                        TextStyle(fontSize: 26),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Text(
                                              "Disconnected",
                                              style: TextStyle(fontSize: 26),
                                            ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              mqttBloc.state is MessageReceivedState ? Container(
                                width: 350,
                                height: 300,
                                padding: EdgeInsets.all(0),
                                child: Card(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "FPMS",
                                            style: TextStyle(fontSize: 26),
                                          ),
                                          Icon(Icons.monitor_heart_rounded, size: 60, color: mqttBloc.state is MessageReceivedState ? mqttBloc.fpms.serial.heartbeat ? Colors.green : Colors.red : Colors.grey,)
                                        ],
                                      ),
                                      Text(
                                        "${((DateTime.now().millisecondsSinceEpoch - mqttBloc.fpms.pmsServer.lastUpdate) / 1000) > 5 ? "OFFLINE" : "ONLINE"}",
                                        style:
                                        TextStyle(fontSize: 22),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Packages: ${mqttBloc.fpms.serial.packagesReceived}", style: TextStyle(fontSize: 22),)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ) : Container(),
                            ],
                          ),
                        ))),
              )),
    );
  }
  @override
  void dispose() {
    serverUriController.dispose();
    portController.dispose();
    topicController.dispose();
    super.dispose();
  }

}

// Column(
// children: [
// Text("${qrcode.split('#').length >= 4 ? "Data valid" : "Wrong qr"}"),
// qrcode.split('#').length > 4 ? Column(
// children: [
// Text("Server uri: ${qrcode.split('#')[0]}"),
// Text("Server port: ${qrcode.split('#')[1]}"),
// Text("Topic: ${qrcode.split('#')[2]}"),
// Text("User: ${qrcode.split('#')[3]}"),
// Text("Password: ${qrcode.split('#')[4]}"),
// ],
// ) : Text("wrong data"),

// Text("${mqttBloc.serverUri}"),
// Text("${mqttBloc.port}"),
// Text("${mqttBloc.topics}"),
// TextField(
// controller: serverUriController,
// ),
// TextButton(onPressed: () {
// mqttBloc.add(UpdateServerEvent(serverUriController.text));
// }, child: Text("update")),
// TextButton(onPressed: () {
// mqttBloc.add(ConnectEvent());
// }, child: Text("connect")),
// TextButton(onPressed: () {
// mqttBloc.add(DisconnectEvent());
// }, child: Text("disconnect")),
// TextButton(onPressed: () {
// mqttBloc.add(SendMessageEvent("elmio", jsonEncode('[{"amp": {"chnnel1": 30}}]')));
// }, child: Text("publish")),
// mqttBloc.state is MessageReceivedState ? Text("${mqttBloc.fpms.shoreA.meters[0]}") : Text("diconnected")
// ],
// ),
