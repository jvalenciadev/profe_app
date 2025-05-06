import 'package:firebase_messaging/firebase_messaging.dart';
import '../notifications/local_notifications.dart';

class FirebaseMessagingService {
  static Future<void> backgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }

  static Future<void> initializeFirebaseMessaging() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // ✅ Solicitar permisos (Android 13+)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('Permiso de notificaciones no concedido');
      return;
    }

    String? token = await messaging.getToken();
    print("Device FCM Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.notification?.title}');

      if (message.notification != null) {
        LocalNotifications.showNotification(
          0,
          message.notification!.title ?? 'Sin título',
          message.notification!.body ?? 'Sin cuerpo',
        );
      }
    });
  }
}
