import 'package:firebase_messaging/firebase_messaging.dart';
import '../notifications/local_notifications.dart';
import '../repository/estado/estado_repository.dart';

class FirebaseMessagingService {
  static Future<void> backgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }

  static Future<void> initializeFirebaseMessaging() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Permiso concedido.');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('ℹ️ Permiso provisional otorgado.');
      } else {
        print('❌ Permiso denegado.');
        // Aquí puedes mostrar un mensaje al usuario si quieres
      }
    } catch (e) {
      print('⚠️ Error al solicitar permisos de notificación: $e');
      // Aquí puedes manejar el error como desees, por ejemplo mostrando un diálogo
    }
    String? token = await messaging.getToken();
    print("Device FCM Token: $token");
    if (token != null) {
      try {
        final estadoRepo = EstadoRepository();
        final respuesta = await estadoRepo.enviarTokenApi(token);
        if (respuesta.status == "success") {
          print('Token enviado exitosamente.');
        } else {
          print('Respuesta inesperada: ${respuesta.status}');
        }
      } catch (e) {
        print('Error al enviar el token al backend: $e');
      }
    }

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
