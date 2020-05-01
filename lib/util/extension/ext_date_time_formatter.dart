import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {

  String formatDate(String format) {
    return DateFormat(format).format(this);
  }

} 