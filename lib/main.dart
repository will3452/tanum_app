
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tanun_projet_space/pages/Home.dart';
import 'package:tanun_projet_space/pages/Login.dart';
import 'package:tanun_projet_space/utils/storage.dart';

void main() async {
  await GetStorage.init();
  // var _n = await AwesomeNotifications().listScheduledNotifications();
  // print('List of schedules >>${_n}', );
  // await AwesomeNotifications().initialize(
  //   null,
  //   [
  //     NotificationChannel(
  //       channelKey: 'basic_channel',
  //       channelName: 'Basic notifications',
  //       channelDescription: 'Notification channel for basic tests',
  //       defaultColor: Colors.green,
  //       ledColor: Colors.white,
  //       playSound: true,
  //       importance: NotificationImportance.Max,
  //     ),
  //   ],
  // );
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
      home: box.read('isLogin') != null && box.read('isLogin') ? Home(): Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
