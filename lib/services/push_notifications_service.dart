// SHA1 F7:3C:E0:33:29:16:51:5F:B4:A2:26:09:14:1D:22:90:EC:18:06:F5

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService{

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream = new StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    // print('On Background Handler ${message.messageId}');
    print(message.data);
    _messageStream.add( message.data['product'].notification?.body ?? 'No data' );
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print('On Message Handler ${message.messageId}');
    print(message.data);
    _messageStream.add( message.data['product'].notification?.body ?? 'No data' );
  }

  static Future _onMesageOpenedApp(RemoteMessage message) async {
    // print('background Handler ${message.messageId}');
    print(message.data);
    _messageStream.add( message.data['product'].notification?.body ?? 'No data' );
  }

  static Future initializeApp() async {

    //Push notification
    //estos datos aparecen en el archivo google-services.json que se encuentra en android/app/ con esto ya me pudo generar el token del dispositivo ojo que esto solo para android
    
    Platform.isAndroid
    ? await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyC5p0a253Q9Indz9KU6WvgtPZk3s8u5FPs",//current_key
          appId: "1:491130468886:android:c8efe25188020812add337",//mobilesdk_app_id
          messagingSenderId: "491130468886",//project_number
          projectId: "flutter-notificaciones-5792c",//project_id
        ),
      )
    : await Firebase.initializeApp();

    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');
    //dLP6gxDdTMGNJyihFQIqGn:APA91bEfE-Rw9uKfNkLj8S_bUyfGu5lHj5RLrFQ8_Bd-vY2CL6wVz8PxWGQiLuiukbcRd5MkMXqxN3QsrFg1wL6Hj_HqqGs7ZEwm7glM2eicArpBEWJXg676xCRuYXfdmPuoEjL9XNFC

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMesageOpenedApp);
    //Local Notification
  }

  static closeStreams(){
    _messageStream.close();
  }

}