import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    // Initialize the local notifications plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          // Handle notification when the app is opened by clicking the notification
          print('Notification payload: ${response.payload}');
          // Navigate to a specific page or handle the payload as needed
        }
      },
    );

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions (for iOS)
    messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print(notification!.body);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id', // Customize this ID as needed
              'mba_notification',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/launcher_icon',
              playSound: true,
              sound: RawResourceAndroidNotificationSound('mbanotifsound'), // Custom sound
            ),
          ),
          payload: message.data['payload'], // Add custom data as needed
        );
      }
    });

    // Handle background notifications when the app is opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened app from background');
      print(message.data);
      if (message.data['payload'] != null) {
        // Navigate to a specific page or handle the payload as needed
      }
    });

    // Handle when the app is opened from a terminated state by clicking a notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('Notification opened app from terminated state');
        if (message.data['payload'] != null) {
          // Navigate to a specific page or handle the payload as needed
        }
      }
    });
  }
}
