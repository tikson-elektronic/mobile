import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fpms/screens/setup_screen.dart';
import 'package:fpms/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import '../providers/light_dark_provider.dart';
import 'home_screen.dart';


class FastPMSApp extends StatefulWidget {
  const FastPMSApp({Key? key}) : super(key: key);

  @override
  State<FastPMSApp> createState() => _FastPMSAppState();
}

class _FastPMSAppState extends State<FastPMSApp> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
        child: MainApp()
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
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        print("Token is $token");
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("pms").add({"token": token});
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
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<LightDarkProvider>(context);
    return MaterialApp(
      theme: themeProvider.getTheme(),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   /* dark theme settings */
      // ),
      // themeMode: ThemeMode.dark,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('FAST PMS'),
          ),
          bottomNavigationBar: const BottomNavigationWidget(),
        ),
      ),
    );
  }
}


class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  static List<Widget> _selections = [
    HomeScreen(),
    SetupScreen(),
    SettingScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<LightDarkProvider>(context);
    return Scaffold(
        appBar: MediaQuery.of(context).orientation == Orientation.portrait ? AppBar(title: Text('PMS'),
          actions: [
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
            BottomNavigationBarItem(icon: Icon(Icons.install_mobile), label: "Installer"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setup")
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ) : null,
        body: _selections[_selectedIndex]
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}

