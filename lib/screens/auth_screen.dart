import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpms/bloc/mqtt_bloc.dart';
import 'package:fpms/config/bloc/config_bloc.dart';
import 'package:fpms/notifications/bloc/notifications_bloc_bloc.dart';
import '../main.dart';
import 'login_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if(snapshot.hasData) {
            return MultiBlocProvider(providers: [
                BlocProvider(
                create: (context) => MqttBloc(),
                ),
                BlocProvider(
                create: (context) => NotificationsBloc(),
                ),
                BlocProvider(
                create: (contex) => ConfigBloc(),
              )
            ], child: FastPMSApp());
          } else {
            return LoginPage();
          }
        }),
      ),
    );
  }
}