import 'package:cloud_tasks/service/notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<String?> initializeFCM(BuildContext context) async {
    await NotificationService.initialize();

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      print('Updated FCM Token: $newToken');
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message: ${message.notification?.title}');
      NotificationService.showNotification(message);
    });

    // Background message (optional)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    return token;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.showNotification(message);
}
