import 'package:flutter/material.dart';

class TaskDetails extends StatelessWidget {
  final Map task;
  const TaskDetails({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var from = DateTime.parse(task['from']);
    var to = DateTime.parse(task["to"]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Description'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Description"),
            subtitle: Text(task['description']),
          ),
          ListTile(
            title: const Text("From - To"),
            subtitle: Text("${from.year}/${from.month}/${from.day} - ${to.year}/${to.month}/${to.day}"),
          ),
          ListTile(
            title: const Text("Time"),
            subtitle: Text(task['time']),
          ),
        ],
      ),
    );
  }
}
