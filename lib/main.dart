import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tanun_projet_space/pages/Home.dart';
import 'package:tanun_projet_space/pages/Login.dart';
import 'package:tanun_projet_space/services/NotificationService.dart';
import 'package:tanun_projet_space/utils/storage.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: $task");
    if (task == 'task-check') {
      await NotificationService.loadSchedules();
    }
    return Future.value(true);
  });
}

void main() async {
  await GetStorage.init();
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      // isInDebugMode:
      //     true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerPeriodicTask(
    "tanum-worker",
    "task-check",
  );
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.green,
        ledColor: Colors.white,
        playSound: true,
        importance: NotificationImportance.Max,
      ),
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tanum',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:
          box.read('isLogin') != null && box.read('isLogin') ? Home() : Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
