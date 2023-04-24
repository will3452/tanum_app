import 'package:device_calendar/device_calendar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tanun_projet_space/components/Loader.dart';
import 'package:tanun_projet_space/pages/Home.dart';
import '../utils/http.dart';
import 'package:timezone/timezone.dart' as tz;
import '../utils/storage.dart';
import 'Calendar.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  String? _description;
  String? _from;
  String? _to;
  String? _time;
  bool _loading = false;

  TextEditingController _dateFromController = TextEditingController(text: '');
  TextEditingController _dateToController = TextEditingController(text: '');
  TextEditingController _timeController = TextEditingController(text: '');

  void _submitTask() async {
    try {
      setState(() {
        _loading = true;
      });

      var token = box.read('userToken');

      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      // submit task

      var response = await dio.post('/api/tasks', data: {
        "from": _from,
        "to": _to,
        "time": _time,
        "description": _description
      });

      Get.defaultDialog(title: "Success", content: Text("Task has been added to your calendar."));
      setState(() {
        _loading = false;
      });


      _formKey.currentState?.reset();
      _dateToController.text = '';
      _dateFromController.text = '';
      _timeController.text = '';
    } on DioError catch (e) {

      Get.defaultDialog(
        title: "Error",
        content: Text(
          "${e.message}"
        )
      );
    }
  }

  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
      backgroundColor: Color(0xFFf1f2f3),
      body: Center(
        child: Loader(),
      ),
    );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(Home(currentMenu: 0,));
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
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                validator: (value) {
                  if (value == '') {
                    return "this field is required.";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text("Description"),
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
                  var _dt = await showDatePicker(
                      context: context,
                      initialDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      firstDate: DateTime(1999),
                      lastDate: DateTime(DateTime.now().year + 50));
                  setState(() {
                    _from = _dt.toString();
                    _dateFromController.text = DateFormat.yMd().format(_dt!);
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
                  var _dt = await showDatePicker(
                      context: context,
                      initialDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      firstDate: DateTime(1999),
                      lastDate: DateTime(DateTime.now().year + 50));
                  setState(() {
                    _to = _dt.toString();
                    _dateToController.text = DateFormat.yMd().format(_dt!);
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
                  var _dt = await showTimePicker(context: context, initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute));
                  setState(() {
                    _time = "${_dt?.hour}:${_dt?.minute}";
                    _timeController.text = "${_time}";
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
                    child: Text('Submit'),
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
