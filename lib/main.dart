import 'package:flutter/material.dart';
import 'package:notificaciones/screens/home_screen.dart';
import 'package:notificaciones/screens/message_screen.dart';
import 'package:notificaciones/services/push_notifications_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();//sirve para cuando nos sale el error de cuando tratamos de inicializar antes de que el binding lo haga
  
  await PushNotificationService.initializeApp();

  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Context!
    PushNotificationService.messagesStream.listen((message) { 
      print('MyApp: $message');

      //para navegar al recibir la notificacion
      navigatorKey.currentState?.pushNamed('message', arguments: message);

      //por alguna razon no me esta mostrando el snackbar en android pero no esta tirando error solo no sale al momento de estar con la app abierta
      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      navigatorKey: navigatorKey,//Navegar
      scaffoldMessengerKey: messengerKey,//Snacks
      routes: {
        'home':( _ ) => const HomeScreen(),
        'message':( _ ) => const MessageScreen(),
      },
    );
  }
}