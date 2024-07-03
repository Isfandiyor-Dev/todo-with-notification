import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notifications_lesson/controllers/todo_controller.dart';
import 'package:notifications_lesson/models/motivation.dart';
import 'package:notifications_lesson/services/local_notifications_serives.dart';
import 'package:notifications_lesson/services/motivation_service.dart';
import 'package:notifications_lesson/views/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalNotificationService.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  MotivationService motivationService = MotivationService();

  @override
  void initState() {
    super.initState();
    LocalNotificationService.requestPermissions();
    _motivationNotification();
  }

  void _motivationNotification() {
    Timer.periodic(
      const Duration(seconds: 50),
      (value) async {
        Motivation? motivation = await motivationService.getMotivation();
        if (motivation != null) {
          if (LocalNotificationService.notificationsEnabled) {
            LocalNotificationService.showNotification(
                title: motivation.author, body: motivation.quotes);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoController())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.greenAccent,
          ),
          home: const MainScreen()),
    );
  }
}
