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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAVLn0iw0M9FH1Qf2xk72YOJRbSF1I4-Fk',
    appId: '1:39910508437:web:94232c5d9608f46ba0589c',
    messagingSenderId: '39910508437',
    projectId: 'reliefmate',
    authDomain: 'reliefmate.firebaseapp.com',
    storageBucket: 'reliefmate.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQBcT7c7bUJepE7Lc2wJvalQDrgf1xY3Q',
    appId: '1:39910508437:android:4a89aa9e70fc4857a0589c',
    messagingSenderId: '39910508437',
    projectId: 'reliefmate',
    storageBucket: 'reliefmate.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXclYrNTkTRKMY8v0Dmh70_wqeVoeVZ9k',
    appId: '1:39910508437:ios:6f3d009633322fb0a0589c',
    messagingSenderId: '39910508437',
    projectId: 'reliefmate',
    storageBucket: 'reliefmate.appspot.com',
    iosClientId: '39910508437-uviaiq46rif08vp6o9f9v1b66qbg4nhl.apps.googleusercontent.com',
    iosBundleId: 'com.example.reliefmate',
  );
}
