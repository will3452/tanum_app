import 'package:cron/cron.dart';
import 'package:intl/intl.dart';

String convertDateRangeToCronExpression(DateTime startDate, DateTime endDate) {
  final DateFormat dayFormat = DateFormat('d');
  final DateFormat monthFormat = DateFormat('M');
  final DateFormat hourFormat = DateFormat('H');
  final DateFormat minuteFormat = DateFormat('m');

  final String startDay = dayFormat.format(startDate);
  final String startMonth = monthFormat.format(startDate);
  final String endDay = dayFormat.format(endDate);
  final String endMonth = monthFormat.format(endDate);
  final String startHour = hourFormat.format(startDate);
  final String startMinute = minuteFormat.format(startDate);

  final String cronExpression =
      '${startMinute} ${startHour} ${startDay}-${endDay} ${startMonth}-${endMonth} *';

  return cronExpression;
}
