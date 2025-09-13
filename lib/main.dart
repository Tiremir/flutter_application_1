import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  double turns = 0;

  void initNotifications() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Пользователь разрешил показ уведомлений');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('Пользователь запретил отображение уведомлений');
    }

    // Получаем токен устройства
    String? token = await _messaging.getToken();
    print("Device Token: $token");

    // Обработчик сообщений, полученных на фоне или вне активности
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Получено сообщение в фоновом режиме: ${message.notification?.title}/${message.notification?.body}');
    });

    // Обработчик сообщений, полученных при активном приложении
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Обработка фона: ${message.notification?.title}/${message.notification?.body}');
  }

  void changeRotation(double step) {
    setState(() => turns += step);
  }

  @override
  void initState() {
    super.initState();
    initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8.0,
            children: [
              IconButton(
                onPressed: () => changeRotation(-0.25),
                icon: Icon(Icons.arrow_back)
              ),
              Container(
                alignment: Alignment.center,
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: AnimatedRotation(
                  turns: turns,
                  duration: Duration(milliseconds: 250),
                  child: Text('Hello World!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),)
                ),
              ),
              IconButton(
                onPressed: () => changeRotation(0.25),
                icon: Icon(Icons.arrow_forward)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
