import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanun_projet_space/components/Loader.dart';
import 'package:tanun_projet_space/pages/AddTask.dart';
import 'package:tanun_projet_space/pages/CareCalendar.dart';
import 'package:tanun_projet_space/pages/TaskDetails.dart';
import 'package:tanun_projet_space/utils/http.dart';
import '../components/Empty.dart';
import '../utils/storage.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var _tasks = [];
  bool _loading = false;

  void _loadTasks() async {
    try {
      setState(() {
        _loading = true;
      });

      dio.options.headers['authorization'] = 'Bearer ${box.read('userToken')}';

      var response = await dio.get('/api/tasks');

      var tasks = [];

      for (var item in response.data!) {
        tasks.add(item);
      }

      setState(() {
        _loading = false;
        _tasks = tasks;
      });

      print('tasks >> $_tasks');
      print('tasks length >> ${_tasks.length}');
    } on DioError catch (e) {
      print("${e.message}");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Loader();
    }
    return Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFFf1f2f3),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  flex: 6,
                  child: Text(
                    'MY TASKS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Get.to(AddTask());
                      },
                    )),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.calendar_month),
                      onPressed: () {

                        Get.to(
                          CareCalendar(tasks: _tasks),
                        );
                      },
                    )),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .6065,
              child: _tasks.length == 0
                  ? Empty()
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        var _from = DateTime.parse(_tasks[index]['from']);
                        var _to = DateTime.parse(_tasks[index]['to']);
                        return Container(
                          child: ListTile(
                            leading: Image.asset('assets/images/leaf.png', height: 25, width: 25,),
                            onTap: () {
                              Get.to(TaskDetails(task: _tasks[index]));
                            },
                            dense: true,
                            isThreeLine: true,
                            title: Text('${_tasks[index]['description']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${_from.year}/${_from.month}/${_from.day} - ${_to.year}/${_to.month}/${_to.day}'),
                                Text('${_tasks[index]['time']}')
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () async {
                                setState(() {
                                  _loading = true;
                                });
                                dio.options.headers['authorization'] =
                                    'Bearer ${box.read('userToken')}';
                                await dio.delete(
                                    '/api/tasks/${_tasks[index]['id']}');
                                setState(() {
                                  _loading = false;

                                  _tasks = _tasks
                                      .where(
                                          (t) => t['id'] != _tasks[index]['id'])
                                      .toList();
                                });
                              },
                            ),
                          ),
                        );
                      },
                      itemCount: _tasks.length,
                    ),
              // child: ListView(
              //   children: const [
              //     ListTile(
              //       title: Text('Task 1'),
              //       subtitle: Text('Subtask'),
              //       tileColor: Colors.white54,
              //     )
              //   ],
              // ),
            )
          ],
        ));
  }
}
