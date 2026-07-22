import 'package:intl/intl.dart';

class AppConstants {
  static const bool shouldRequireUpdate = true;
  static bool fallbackToUpgrader = false;
  static DateFormat dateFormat = DateFormat('MM-dd-yyyy'); // December 6, 2024 => 12-06-2024
  // static DateFormat dateFormat = DateFormat('MM-dd-yy'); // December 6, 2024 => 12-06-24
  // static DateFormat dateFormat = DateFormat.yMd('en_US'); December 6, 2024 => 12/6/2024
  // static DateFormat dateFormat = DateFormat.yMMMMd('en_US'); // December 6, 2024 => December 6, 2024

  static DateFormat dateFormatWithTime = DateFormat('MM-dd-yyyy').add_jm(); // December 6, 2024 => 12-06-2024
  // static DateFormat dateFormatWithTime = DateFormat('MM-dd-yy').add_jm(); // December 6, 2024 => 12-06-24

  static const String proxyUrl = 'https://us-central1-gym-app-kw.cloudfunctions.net/api/proxy'; // Your Proxy URL
  static const String apiKey = 'AIzaSyC2bJK3FU4zj2g352f2hMOq8vGcCoyvBDQ';

  static const int resendSignupOTPSecondsLimit = 60;

  /// Backend missed-order window; waiting page uses this + 1 minute buffer.
  static Duration missedOrderTimeLimit = const Duration(minutes: 4);
}
