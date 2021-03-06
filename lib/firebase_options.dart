// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBBDYlX1DpZkf833G83is3GGyyJgVwbGX4',
    appId: '1:12656423910:web:a646e70b5b0d9915f45c27',
    messagingSenderId: '12656423910',
    projectId: 'itravel-ecbed',
    authDomain: 'itravel-ecbed.firebaseapp.com',
    databaseURL: 'https://itravel-ecbed-default-rtdb.firebaseio.com',
    storageBucket: 'itravel-ecbed.appspot.com',
    measurementId: 'G-BWR23HQ8Q1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxbfpRGmq3Wjex1SfTXwySuxQaCiQZxUM',
    appId: '1:12656423910:android:d3d7497c33f57693f45c27',
    messagingSenderId: '12656423910',
    projectId: 'itravel-ecbed',
    databaseURL: 'https://itravel-ecbed-default-rtdb.firebaseio.com',
    storageBucket: 'itravel-ecbed.appspot.com',
  );
}
