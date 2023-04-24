import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tanun_projet_space/components/Empty.dart';

class CareCalendar extends StatefulWidget {
  final dynamic tasks;

  const CareCalendar({Key? key, required this.tasks}) : super(key: key);

  @override
  State<CareCalendar> createState() => _CareCalendarState();
}

class _CareCalendarState extends State<CareCalendar> {
  var _calendarFormat = CalendarFormat.month;

  List<dynamic> getEvents(dt) {
    List<dynamic> events = [];
    for (var task in widget.tasks) {
      if ((dt.isAfter(DateTime.parse(task['from'])) ||
              dt.isAtSameMomentAs(DateTime.parse(task['from']))) &&
          (dt.isBefore(DateTime.parse(task['to'])) ||
              dt.isAtSameMomentAs(DateTime.parse(task['to'])))) {
        events.add(task);
      }
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Care Calendar"),
      ),
      body: Center(
          child: TableCalendar(
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
        calendarBuilders:
            CalendarBuilders(markerBuilder: (context, day, events) {
          // return Image.asset('assets/images/plant.png', width: 7, height: 7,);
          List<Widget> images = [];
          for (var i in events) {
            images.add(Image.asset(
              'assets/images/leaf.png',
              height: 7,
              width: 7,
            ));
          }

          return Row(
              mainAxisAlignment: MainAxisAlignment.center, children: images);
        }),
        onDaySelected: (d1, d2) {
          showModalBottomSheet(
              context: context,
              builder: (context) {

                var selectedEvents = getEvents(d1);
                return SizedBox(
                  height: MediaQuery.of(context).size.height * .6,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Text(
                          "Events",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Expanded(
                          child: selectedEvents.isEmpty ? const Empty() :ListView.builder(itemCount: selectedEvents.length,itemBuilder: (context, index){
                            return ListTile(
                              dense: true,
                              title: Text(selectedEvents[index]['description']),
                              subtitle: Text(selectedEvents[index]['time']),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        weekNumbersVisible: false,
        calendarStyle: const CalendarStyle(
            todayTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.transparent,
            )),
        lastDay: DateTime.now().add(Duration(days: 365 * 50)),
        firstDay: DateTime.now().subtract(Duration(days: 365)),
        focusedDay: DateTime.now(),
        eventLoader: (dt) {
          var events = [];
          for (var task in widget.tasks) {
            if ((dt.isAfter(DateTime.parse(task['from'])) ||
                    dt.isAtSameMomentAs(DateTime.parse(task['from']))) &&
                (dt.isBefore(DateTime.parse(task['to'])) ||
                    dt.isAtSameMomentAs(DateTime.parse(task['to'])))) {
              events.add(task['description']);
            }
          }
          return events;
        },
      )),
    );
  }
}
