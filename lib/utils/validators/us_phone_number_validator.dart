import 'package:get/get.dart';

String? validateUsPhoneNumber(String input) {
  // remove everything except digits
  final digits = input.replaceAll(RegExp(r'\D'), '');

  if (digits.isEmpty) {
    return "Phone number is required";
  }

  if (!digits.isNumericOnly) {
    return 'Phone number must be digits only';
  }

  if (digits.trim().length != 10) {
    return 'Phone number must be 10 digits';
  }
  // else if (digits.length != 10) {
  //   return 'Phone number must be 10 digits';
  // }

  // optional stricter rule: area code cannot start with 0 or 1
  if (digits.startsWith(RegExp(r'[01]'))) {
    return 'Invalid area code';
  }

  return null; // valid
}
