// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBRMh3Bxb5_qAczlQpP7e6dOK6oqxdHO2E',
    appId: '1:292449823269:android:2fd83eef68adb1165bedcc',
    messagingSenderId: '292449823269',
    projectId: 'jp-phitnest',
    storageBucket: 'jp-phitnest.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4DlLkn2PQEcK9cnSRMwylWltQ08DRM_w',
    appId: '1:292449823269:ios:9c5fce5e91be69c15bedcc',
    messagingSenderId: '292449823269',
    projectId: 'jp-phitnest',
    storageBucket: 'jp-phitnest.appspot.com',
    iosClientId:
        '292449823269-jrj8dqi364tffnks7k6df59q3ru8hs9f.apps.googleusercontent.com',
    iosBundleId: 'com.phitnest.app.ios',
  );
}