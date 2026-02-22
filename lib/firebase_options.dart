// Fichier généré à partir de GoogleService-Info.plist et google-services.json.
// Pour régénérer : flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
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
    apiKey: 'AIzaSyBPeL_R2WFbljJFNiq4sEjTCPfyKOmcUyw',
    appId: '1:368898169734:android:de3725d5d4265b4db26a07',
    messagingSenderId: '368898169734',
    projectId: 'dokal-prod',
    storageBucket: 'dokal-prod.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBx815IBxaHlh8ayFhftu6kweYQ07EuPog',
    appId: '1:368898169734:ios:9df7d629cacfc65cb26a07',
    messagingSenderId: '368898169734',
    projectId: 'dokal-prod',
    storageBucket: 'dokal-prod.firebasestorage.app',
    iosBundleId: 'com.yapio.dokal',
  );
}
