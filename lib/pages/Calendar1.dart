import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tanun_projet_space/pages/NewTask.dart';
import '../utils/storage.dart';
import 'package:get/get.dart';

class CalendarPage1 extends StatefulWidget {
  const CalendarPage1({Key? key}) : super(key: key);

  @override
  State<CalendarPage1> createState() => _CalendarPageState1();
}

class _CalendarPageState1 extends State<CalendarPage1> {
  late DeviceCalendarPlugin _deviceCalendar;
  late var _careCalendar;
  var _events = [];

  var _calendarFormat = CalendarFormat.month;
  var _focusDay = DateTime.now();

  List<dynamic> _calendars = [];

  _CalendarPageState() {
    _deviceCalendar = DeviceCalendarPlugin();
  }

  @override
  void initState() {
    super.initState();
    _retrieveCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Care Calendar",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.to(NewTask(
                          calendarId: _careCalendar.id,
                          deviceCalendar: _deviceCalendar));
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            child: TableCalendar(
              calendarStyle: CalendarStyle(
                todayTextStyle: const TextStyle(
                    fontWeight: FontWeight.w900, color: Colors.white),
                todayDecoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
              ),
              focusedDay: _focusDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              onDaySelected: (selectedDay, focusDay) {
                print("selectedDay >> $selectedDay");
                setState(() {
                  _focusDay = selectedDay;
                });
              },
              headerVisible: true,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              eventLoader: (day) {
                return [];
              },
              calendarBuilders:
                  CalendarBuilders(defaultBuilder: (context, date, events) {
                return Center(
                  child: Text("${date.day}"),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _createNewCalendar() async {
    final newC = Calendar(name: "tanum_calendar", isReadOnly: false);
    print('createD!');
    _careCalendar = await _deviceCalendar.createCalendar("tanum_calendar",
        localAccountName: box.read('userName'));
  }

  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendar.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null ||
              permissionsGranted.data == false)) {
        permissionsGranted = await _deviceCalendar.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            permissionsGranted.data == false) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendar.retrieveCalendars();

      setState(() {
        _calendars = calendarsResult.data as List<dynamic>;
      });

      var cc = _calendars.where((c) => c.name == 'tanum_calendar').toList();
      if (cc.isEmpty) {
        _createNewCalendar();
      } else {
        print('existing');
        _careCalendar = cc[0];
      }

      // fetch all events
      final result = await _deviceCalendar.retrieveEvents(
          _careCalendar.id,
          RetrieveEventsParams(
            startDate: DateTime(DateTime.now().year, DateTime.january),
            endDate: DateTime(DateTime.now().year, DateTime.december),
          ));

      if (result.isSuccess) {
        _events = result.data!;
      } else {
        print("error ${result.errors.first.errorMessage}");
      }
    } on PlatformException catch (e) {
      print("error >> $e");
    }
  }
}
