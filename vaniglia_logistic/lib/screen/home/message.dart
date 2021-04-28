import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  FirebaseMessaging messaging = FirebaseMessaging.instance;


  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {


      // For testing purposes print the Firebase Messaging token
      String token = await messaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}