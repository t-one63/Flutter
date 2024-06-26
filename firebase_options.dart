// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyC0GyrqhPYjo9N8sEBampOhb7wJ8Dcg9ko',
    appId: '1:721938322296:web:73677f70ae1a2e9b262e8d',
    messagingSenderId: '721938322296',
    projectId: 'flutter-295af',
    authDomain: 'flutter-295af.firebaseapp.com',
    storageBucket: 'flutter-295af.appspot.com',
    measurementId: 'G-Y5L5N1GQNY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjn7-yxn_FEEkTMfxbSYKFmZQU5m96uyg',
    appId: '1:721938322296:android:00488747b92fbe87262e8d',
    messagingSenderId: '721938322296',
    projectId: 'flutter-295af',
    storageBucket: 'flutter-295af.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBaiD3NPnkRvCOr2QCiZ5FNH6TCpM8id9s',
    appId: '1:721938322296:ios:ee6d31d1e814ef8a262e8d',
    messagingSenderId: '721938322296',
    projectId: 'flutter-295af',
    storageBucket: 'flutter-295af.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBaiD3NPnkRvCOr2QCiZ5FNH6TCpM8id9s',
    appId: '1:721938322296:ios:ee6d31d1e814ef8a262e8d',
    messagingSenderId: '721938322296',
    projectId: 'flutter-295af',
    storageBucket: 'flutter-295af.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

}