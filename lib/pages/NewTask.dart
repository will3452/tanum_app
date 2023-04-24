import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class NewTask extends StatefulWidget {
  final String calendarId;
  final DeviceCalendarPlugin deviceCalendar;
  const NewTask(
      {Key? key, required this.calendarId, required this.deviceCalendar})
      : super(key: key);

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  late String _description;
  late DateTimeRange _dateTimeRange;
  TextEditingController _dateController = TextEditingController(text: "");

  void _createEvent() async {
    var event = Event(
      widget.calendarId,
      start: tz.TZDateTime.from(_dateTimeRange.start, tz.local),
      end: tz.TZDateTime.from(_dateTimeRange.end, tz.local),
      title: _description,
      description: _description,
      availability: Availability.Free,
      reminders: [
        Reminder(minutes: 5),
      ],
      allDay: true,
    );

    var result = await widget.deviceCalendar.createOrUpdateEvent(event);

    if(! result!.isSuccess) {
      Get.defaultDialog(title: "Error", content: Text('Failed to create task, please check the permission.'));
    } else {
      Get.defaultDialog(title: "Success", content: Text('task has been added.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("calendar_id >> ${widget.calendarId}");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Add Task'),
      ),
      body: SafeArea(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              child: ListView(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Description"),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _description = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _dateController,
                    onTap: () async {
                      var result = await showDateRangePicker(
                        context: context,
                        firstDate:
                            DateTime(DateTime.now().year, DateTime.now().month),
                        lastDate:
                            DateTime(DateTime.now().year, DateTime.december),
                      );

                      setState(() {
                        _dateTimeRange = result!;
                        String text =
                            "${DateFormat.yMd().format(_dateTimeRange.start)} - ${DateFormat.yMd().format(_dateTimeRange.end)}";
                        _dateController = TextEditingController(text: text);
                      });
                    },
                    decoration: const InputDecoration(
                      label: Text("Date (From - To)"),
                      contentPadding: EdgeInsets.all(10),
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
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        child: const Text('Submit'),
                        onPressed: () {
                          _createEvent();
                          // Get.defaultDialog(
                          //   title: "Success",
                          //   content: Text("Task has been added")
                          // );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
