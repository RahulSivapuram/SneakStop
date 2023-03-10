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
    apiKey: 'AIzaSyBx5wjsY1T3vBIV8-WJjuYhcEsV29e9aOk',
    appId: '1:765682391133:web:4cf400b5092171c61495b4',
    messagingSenderId: '765682391133',
    projectId: 'appecom-e670e',
    authDomain: 'appecom-e670e.firebaseapp.com',
    storageBucket: 'appecom-e670e.appspot.com',
    measurementId: 'G-JD7Y8MRGE9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCj_Q-n-IgAHS6RfM_DS2EgbBL71oVMTho',
    appId: '1:765682391133:android:d9a38051426d406d1495b4',
    messagingSenderId: '765682391133',
    projectId: 'appecom-e670e',
    storageBucket: 'appecom-e670e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqyCFBA1mdasiewpZJC_e9bJY9TXQB2QA',
    appId: '1:765682391133:ios:f096d1883b6c70e21495b4',
    messagingSenderId: '765682391133',
    projectId: 'appecom-e670e',
    storageBucket: 'appecom-e670e.appspot.com',
    iosClientId: '765682391133-djg0v7fg39qvvue8h7vuepjj7fe9jtpq.apps.googleusercontent.com',
    iosBundleId: 'com.example.ecomapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCqyCFBA1mdasiewpZJC_e9bJY9TXQB2QA',
    appId: '1:765682391133:ios:f096d1883b6c70e21495b4',
    messagingSenderId: '765682391133',
    projectId: 'appecom-e670e',
    storageBucket: 'appecom-e670e.appspot.com',
    iosClientId: '765682391133-djg0v7fg39qvvue8h7vuepjj7fe9jtpq.apps.googleusercontent.com',
    iosBundleId: 'com.example.ecomapp',
  );
}
