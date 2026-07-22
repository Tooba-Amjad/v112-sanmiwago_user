import 'package:flutter/services.dart';

class UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 3) buffer.write(') ');
      if (i == 6) buffer.write('-');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

String? normalizeUsPhoneNumber(String input) {
  // Strip all non-digits
  final digits = input.replaceAll(RegExp(r'\D'), '');

  // Must be exactly 10 digits for a U.S. number
  // if (digits.length != 10) return null;

  // Return E.164 format (+1 is U.S. country code)
  return digits;
}

String? formatUsPhoneNumber(String input) {
  // Strip all non-digits first
  final digits = input.replaceAll(RegExp(r'\D'), '');

  // If not exactly 10 digits, return input as-is
  if (digits.length != 10) return input;

  // Format as (123) 456-7890
  return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
}
