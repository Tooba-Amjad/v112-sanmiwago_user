import 'package:intl/intl.dart';


getNow() {
  return DateTime.now();
}

DateTime parseOrderDateTime(String? orderDate, String? orderTime) {
  if (orderDate == null || orderTime == null) {
    return getNow().cleanDateTime();
  }

  // Convert "order_time":"21:52 PM" into a proper 24-hour format
  orderTime = orderTime.replaceAll(" PM", "").replaceAll(" AM", ""); // Remove AM/PM if needed

  // Combine order date and time
  String dateTimeString = "$orderDate $orderTime";

  // Parse the date string into a DateTime object
  return DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTimeString);
}

extension DateTimeFormatting on DateTime {
  // Format: MM-dd-yyyy
  String get formattedDate => DateFormat('MM-dd-yyyy').format(this);

  // Format: MM-dd-yyyy hh:mm a
  String get formattedDateWithTime => DateFormat('MM-dd-yyyy').add_jm().format(this);

  // Format: hh:mm a (time only)
  String get formattedTime => DateFormat.jm().format(this);
}

extension Iso8601WithoutOffset on DateTime {
  String cleanIsoString() {
    return '${toIso8601String().split(".").first}.000';
  }

  DateTime cleanDateTime() {
    final cleanedString = cleanIsoString();
    return DateTime.tryParse(cleanedString) ?? getNow().cleanDateTime();
  }
}

extension IsoStringCleaner on String {
  String cleanIsoString() {
    // Split at '.' to remove milliseconds and offset
    final base = split('.').first;
    return '$base.000';
  }

  DateTime cleanDateTime() {
    final cleanedString = cleanIsoString();
    return DateTime.tryParse(cleanedString) ?? getNow().cleanDateTime();
  }
}

