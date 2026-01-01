// change dateTime to string in format yyyy-MM-dd
import 'package:intl/intl.dart';

String dateTimeToString(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd', 'en').format(dateTime.toUtc());
}
