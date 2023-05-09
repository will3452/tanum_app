import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:tanun_projet_space/utils/http.dart';

import '../utils/storage.dart';

class NotificationService {
  static Future<void> loadTasks() async {
    dio.options.headers['Authorization'] = 'Bearer ${box.read('userToken')}';
    var response = await dio.get('/api/tasks');
    if (response.statusCode == 200) {
      var tasks = response!.data;

      await box.write("tasks", tasks);
      print("task has been load");
    }
  }

  static List<dynamic> taskToday() {
    var todayTask = [];

    var tasks = box.read("tasks");

    if (tasks is! List) {
      tasks = jsonDecode(tasks);
    }

    for (var task in tasks) {
      DateTime from = DateTime.parse(task['from']);
      DateTime to = DateTime.parse(task['to']);
      DateTime today = DateTime.now();
      bool fromCon = today.isAtSameMomentAs(from) || today.isAfter(from);
      bool toCon = today.isAtSameMomentAs(to) || today.isAfter(to);
      if (fromCon && toCon) {
        todayTask.add(task);
      }
    }

    return todayTask;
  }

  static Future<void> loadSchedules() async {
    await NotificationService.loadTasks();
    List<dynamic> taskToday = NotificationService.taskToday();

    List<NotificationModel> sn =
        await AwesomeNotifications().listScheduledNotifications();

    for (var task in taskToday) {
      bool notThere = true;
      for (NotificationModel s in sn) {
        if (s.content!.id == task['id']) {
          notThere = false;
        }
      }

      if (notThere) {

        var today = DateTime.now();
        var time = task['time'].split(':');

        AwesomeNotifications().createNotification(content: NotificationContent(
          id: task['id'],
          channelKey: 'basic_channel',
          body: task['description'],
          title: 'Task reminder',
          wakeUpScreen: true,
          displayOnBackground: true,
          displayOnForeground: true,
        ),
          schedule: NotificationCalendar(day: today.day, hour: time[0], minute: time[0]),
        );
      }
    }
  }
}
