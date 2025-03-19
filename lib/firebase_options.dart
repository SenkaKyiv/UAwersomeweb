// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDU3HzHmv2CDmPBF2mTtrOLEEBPGsV5BBk",
    appId: "1:812336610072:web:424b617e7f3189c0027c6d",
    messagingSenderId: "812336610072",
    projectId: "uawersome-73eca",
    authDomain: "uawersome-73eca.firebaseapp.com",
    storageBucket: "uawersome-73eca.firebasestorage.app",
    measurementId: "G-K7J4BBJM0X",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyA8o3V_Ws6RwiT28oBC1bFANMY3CFiM",
    appId: "1:812336610072:android:8e3183b58d50efe1027c6d",
    messagingSenderId: "812336610072",
    projectId: "uawersome-73eca",
    storageBucket: "uawersome-73eca.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyCnfYzeFwBI2xlCpeG_Hj9b4Bm_dMRLm00",
    appId: "1:812336610072:ios:c8b40556dfe2a7d8027c6d",
    messagingSenderId: "812336610072",
    projectId: "uawersome-73eca",
    storageBucket: "uawersome-73eca.firebasestorage.app",
    iosClientId: "812336610072-huproitufledfu2ikj8spe1r35st934p.apps.googleusercontent.com",
    iosBundleId: "com.example.coachnewtool",
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    // TODO: Check defaultTargetPlatform for android/ios
    return android; // Simplified
  }


}

