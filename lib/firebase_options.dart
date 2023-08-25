
// ignore_for_file: depend_on_referenced_packages

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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCuz60NomszowBIOp5s5tmGHK5unJ67ngI',
    appId: '1:1014761899239:android:7dfd4f2ad9b2c2dcb5ce42',
    messagingSenderId: '1014761899239',
    projectId: 'chatai-e581f',
    storageBucket: 'chatai-e581f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzrQXdZJlQskH-jDkqTngRnOdEwOvc3-8',
    appId: '1:1014761899239:ios:5132bbf98ccc68dcb5ce42',
    messagingSenderId: '1014761899239',
    projectId: 'chatai-e581f',
    storageBucket: 'chatai-e581f.appspot.com',
    androidClientId: '1014761899239-0rtho0nu0f4tvtd8q7mc1140heq8p1s1.apps.googleusercontent.com',
    iosClientId: '1014761899239-317gii6opb3ku0tgbp7qi8vp5orir0ta.apps.googleusercontent.com',
    iosBundleId: 'app.mortarltd.chatai',
  );
}
