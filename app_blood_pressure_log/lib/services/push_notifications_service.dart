import 'package:app_blood_pressure_log/app/app.logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stacked/stacked_annotations.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  print("${message.notification?.title}");
  print("${message.notification?.body}");
  print("${message.data}");
}

class PushNotificationsService implements InitializableDependency {
  NotificationSettings? settings;
  var log = getLogger("PushNotificationsService");
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await messaging.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      log.wtf(message.data['type']);
    }
  }

  Future initializePushNotifications() async {
    // You may set the permission requests to "provisional" which allows the user to choose what type
    // of notifications they would like to receive once the user receives a notification.

    settings = await messaging.requestPermission();

    //Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log.wtf('Got a message whilst in the foreground!');
      log.wtf('Message data: ${message.data}');

      if (message.notification != null) {
        log.wtf(
            'Message also contained a notification: ${message.notification}');
      }
    });
    setupInteractedMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String?> fetchFcmToken() async {
    return await messaging.getToken();
  }

  @override
  Future<void> init() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    AndroidBuildVersion version = androidInfo.version;
    int? sdk = version.sdkInt ?? 29;
    if (!(sdk > 29)) {
      await initializePushNotifications();
    }
  }
}
