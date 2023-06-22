import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tanun_projet_space/components/Loader.dart';
import 'package:tanun_projet_space/pages/Home.dart';
import '../utils/http.dart';
import '../utils/storage.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  String? _description;
  String? _remarks;
  String? _from;
  String? _to;
  String? _time;
  bool _loading = false;

  final TextEditingController _dateFromController =
      TextEditingController(text: '');
  final TextEditingController _dateToController =
      TextEditingController(text: '');
  final TextEditingController _timeController = TextEditingController(text: '');

  List<DateTime> getDatesBetween(DateTime startDate, DateTime endDate) {
    final List<DateTime> dates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return dates;
  }

  void _submitTask() async {
    try {
      setState(() {
        _loading = true;
      });

      var token = box.read('userToken');

      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      // submit task

      await dio.post('/api/tasks', data: {
        "from": _from,
        "to": _to,
        "time": _time,
        "description": _description,
        "remarks": _remarks,
      });

      final time = _time?.split(':');

      //create schedule notifications
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      final DateTime startDate = dateFormat.parse(_from!);
      final DateTime endDate = dateFormat.parse(_to!);
      final List<DateTime> dateRange = getDatesBetween(startDate, endDate);

      for (final date in dateRange) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: date.day,
            channelKey: 'basic_channel',
            body: _description,
            title: 'Task reminder',
            wakeUpScreen: true,
            displayOnBackground: true,
            displayOnForeground: true,
          ),
          schedule: NotificationCalendar(
              day: date.day,
              hour: int.parse(time![0]),
              minute: int.parse(time[1])),
        );
      }

      Get.defaultDialog(
          title: "Success",
          content: const Text("Task has been added to your calendar."));
      setState(() {
        _loading = false;
      });

      _formKey.currentState?.reset();
      _dateToController.text = '';
      _dateFromController.text = '';
      _timeController.text = '';
    } on DioError catch (e) {
      Get.defaultDialog(title: "Error", content: Text("${e.message}"));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFf1f2f3),
        body: Center(
          child: Loader(),
        ),
      );
    }

    List<String> _descriptionsOpt = [
      'Seeding',
      'Weeding',
      'Watering',
      'Composting',
      'Pruning',
      'Fertilizing',
      'Transplanting',
      'Mowing',
      'Others'
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(const Home(
              currentMenu: 0,
            ));
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButton(
                    items: const [
                      DropdownMenuItem(
                        value: 'Seeding',
                        child: Text('Seeding'),
                      ),
                      DropdownMenuItem(
                        value: 'Weeding',
                        child: Text('Weeding'),
                      ),
                      DropdownMenuItem(
                        value: 'Watering',
                        child: Text('Watering'),
                      ),
                      DropdownMenuItem(
                        value: 'Composting',
                        child: Text('Composting'),
                      ),
                      DropdownMenuItem(
                        value: 'Pruning',
                        child: Text('Pruning'),
                      ),
                      DropdownMenuItem(
                        value: 'Fertilizing',
                        child: Text('Fertilizing'),
                      ),
                      DropdownMenuItem(
                        value: 'Transplanting',
                        child: Text('Transplanting'),
                      ),
                      DropdownMenuItem(
                        value: 'Mowing',
                        child: Text('Mowing'),
                      ),
                      DropdownMenuItem(
                        value: 'Others',
                        child: Text('Others'),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() {
                        _description = v;
                      });
                    },
                    isExpanded: true,
                    value: _description,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _remarks = value;
                      });
                    },
                    validator: (value) {
                      if (value == '') {
                        return "this field is required.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("Please Specify"),
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _dateFromController,
                    readOnly: true,
                    onTap: () async {
                      var dt = await showDatePicker(
                          context: context,
                          initialDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 50));
                      setState(() {
                        _from = dt.toString();
                        _dateFromController.text = DateFormat.yMd().format(dt!);
                      });
                    },
                    validator: (value) {
                      if (value == '') {
                        return "this field is required.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("From"),
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _dateToController,
                    readOnly: true,
                    onTap: () async {
                      var dt0 = await showDatePicker(
                          context: context,
                          initialDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 50));
                      setState(() {
                        _to = dt0.toString();
                        _dateToController.text = DateFormat.yMd().format(dt0!);
                      });
                    },
                    validator: (value) {
                      if (value == '') {
                        return "this field is required.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("To"),
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _timeController,
                    readOnly: true,
                    validator: (value) {
                      if (value == '') {
                        return "this field is required.";
                      }
                      return null;
                    },
                    onTap: () async {
                      var dt1 = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: TimeOfDay.now().hour,
                              minute: TimeOfDay.now().minute));
                      setState(() {
                        _time = "${dt1?.hour}:${dt1?.minute}";
                        _timeController.text = "$_time";
                      });
                    },
                    decoration: const InputDecoration(
                      label: Text("Time"),
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(Icons.timer),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submitTask();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
