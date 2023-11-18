import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpms/models/config_file.dart';
import 'package:fpms/screens/notifications_screen.dart';
import 'package:http/http.dart' as http;


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fpms/firebase_options.dart';
import 'package:fpms/providers/light_dark_provider.dart';
import 'package:fpms/screens/auth_screen.dart';
import 'package:fpms/screens/home_screen.dart';
import 'package:fpms/screens/settings_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'bloc/mqtt_bloc.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async   {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(), htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(), htmlFormatContent: true
  );
  AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'dbfood', 'dbfood', importance: Importance.high,
      styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true
  );
  NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body, notificationDetails, payload: message.data['title']);
}

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthPage(),
  ));
}

class FastPMSApp extends StatefulWidget {
  const FastPMSApp({Key? key}) : super(key: key);

  @override
  State<FastPMSApp> createState() => _FastPMSAppState();
}

class _FastPMSAppState extends State<FastPMSApp> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late String token;
  String notification = "";

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => LightDarkProvider())),
        ],
        child: MainApp(token)
    );
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
        sound: true
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      setState(() {

      });
    }
    if(settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
      setState(() {

      });
    }
    else {
      print("User has not accented permission");
      setState(() {

      });
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      setState(() {
        print("Token is $token");
        this.token = token!;
      });
      saveToken(token!);
      await http.post(
        Uri.parse('http://24.199.84.80:1886'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': "${token}",
        }),
      );
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("pms-tokens").add({"token": token});
  }

  void getInfo() async {
    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios =  DarwinInitializationSettings();
    var platform = InitializationSettings(android: android, iOS: ios);

    flutterLocalNotificationsPlugin?.initialize(platform,
        onDidReceiveNotificationResponse: (payload) {
          try {

          } catch(e) {

          }
          return;
        });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      print("-------------on message-------------------");
      print("On message: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(), htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(), htmlFormatContent: true
      );
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
          'dbfood', 'dbfood', importance: Importance.max,
          styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true
      );
      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body, notificationDetails, payload: message.data['title']);
    });
  }
}

class MainApp extends StatelessWidget {
  final String token;

  const MainApp(this.token, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationWidget(token),
      ),
    );
  }
}


class BottomNavigationWidget extends StatefulWidget {
  final String token;

  const BottomNavigationWidget(this.token, {Key? key}) : super(key: key);

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;
  late Config _config;

  static const List<Widget> _selections = [
    HomeScreen(),
    NotificationsScreen(),
    SettingScreen()
  ];
  late Config config;
  late File jsonFile;
  late Directory dir;
  String fileName = "config.json";
  bool fileExists = false;
  late Map<String, dynamic> fileContent;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    final mqttBloc = BlocProvider.of<MqttBloc>(context);
    mqttBloc.add(UpdateTokenEvent(widget.token));

    final themeProvider = Provider.of<LightDarkProvider>(context);

    if(fileExists && mqttBloc.state is DisconnectedState) {
      mqttBloc.add(ConnectingEvent());
      mqttBloc.add(UpdateServerEvent(config.mqttServerUri));
      mqttBloc.add(UpdatePortEvent(config.mqttServerPort));
      mqttBloc.add(UpdateCredentialsEvent(config.mqttUsername, config.mqttPassword));
      mqttBloc.add(UpdateTopicEvent(config.mqttTopic));
      mqttBloc.add(ConnectEvent());
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.getTheme(),
      home: BlocBuilder<MqttBloc, MqttState>(
        builder: (context, message) => Scaffold(
            appBar: MediaQuery.of(context).orientation == Orientation.portrait ? AppBar(title: const Text('PMS'),
              actions: [
                mqttBloc.state is MessageReceivedState ?
                (DateTime.now().millisecondsSinceEpoch - mqttBloc.fpms.pmsServer.lastUpdate < 10000 ? Icon(Icons.link) : Icon(Icons.link_off)) : Icon(Icons.link_off),
                const SizedBox(width: 20,),
                IconButton(onPressed: () {
                  if(themeProvider.darkMode) {
                    themeProvider.setLightMode();
                  } else {
                    themeProvider.setDarkMode();
                  }
                }, icon: themeProvider.darkMode ? Icon(Icons.light_mode) : Icon(Icons.dark_mode)),
              ],) : null,
            bottomNavigationBar: MediaQuery.of(context).orientation == Orientation.portrait ? BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
                BottomNavigationBarItem(icon: Icon(Icons.select_all), label: "Categories")
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ) : null,
            body: _selections[_selectedIndex]
        ),
      )
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
  Future<void> readJson() async {
    final String response =
    await rootBundle.loadString('assets/config.json');
    final data = await json.decode(response);
    _config = Config.fromJson(data);
  }
}



