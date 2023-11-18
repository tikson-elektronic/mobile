// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAv16gpQwkj_7dZXZYig-OYNCnPALdVgvI',
    appId: '1:37866146748:web:c088f76f3b0b54dfceb9b9',
    messagingSenderId: '37866146748',
    projectId: 'fpms-app',
    authDomain: 'fpms-app.firebaseapp.com',
    storageBucket: 'fpms-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6EjaCuiSX4_cEuxHkEmG1BB_k97C-6Ec',
    appId: '1:37866146748:android:6baa70f4074ab956ceb9b9',
    messagingSenderId: '37866146748',
    projectId: 'fpms-app',
    storageBucket: 'fpms-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBz_4bd8tDDmwp3Ni5gQDyzf4SSPEw2Azo',
    appId: '1:37866146748:ios:8f162e190022fe63ceb9b9',
    messagingSenderId: '37866146748',
    projectId: 'fpms-app',
    storageBucket: 'fpms-app.appspot.com',
    iosBundleId: 'com.system.tech.nauti.fpms',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBz_4bd8tDDmwp3Ni5gQDyzf4SSPEw2Azo',
    appId: '1:37866146748:ios:8f162e190022fe63ceb9b9',
    messagingSenderId: '37866146748',
    projectId: 'fpms-app',
    storageBucket: 'fpms-app.appspot.com',
    iosBundleId: 'com.system.tech.nauti.fpms',
  );
}
