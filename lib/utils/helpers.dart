import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:url_launcher/url_launcher.dart';

//+ commented because currently GetUtils one is also there
extension StringExtension on String {
  String capitalizeItsFirst() {
    return "${this[0].toUpperCase()}${substring(1)}";
    // return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

//+ remove all navigate functions and put the normal Get navigation functions back in place
navigate({required PageType type, required page, Transition transition = Transition.rightToLeft}) {
  if (Get.isSnackbarOpen) {
    Get.back();
  }
  switch (type) {
    case PageType.to:
      log("in to");
      Get.to(
        page,
        transition: transition,
        duration: const Duration(milliseconds: 300),
      );
      break;
    case PageType.off:
      log("in off");
      Get.off(
        page,
        transition: transition,
        duration: const Duration(milliseconds: 300),
      );
      break;
    case PageType.offAll:
      log("in off ALl");
      Get.offAll(
        page,
        transition: transition,
        duration: const Duration(milliseconds: 300),
      );
      break;
    default:
      Get.to(
        () => page,
        transition: transition,
        duration: const Duration(milliseconds: 300),
      );
  }
}

Color getColour(String orderName) {
  switch (orderName) {
    case "missed":
      return Colors.red;

    case "ready":
      return Colors.black;

    case "delivered":
      return Colors.black;

    case "arrived":
      return Colors.black;

    case "process":
      return Colors.black;

    case "out_to_deliver":
      return Colors.black;

    case "on_the_way":
      return Colors.black;

    case "accept":
    case "prepared":
      // case "ready":
      // case "arrived":
      // case "delivered":
      return Colors.green;

    case "cancel":
      return Colors.red;

    case "cancelled":
      return Colors.red;

    case "Earned":
      return Colors.green;

    case "Redeem":
      return Colors.red;

    case "Refund":
      return Colors.green;

    case "Reversed":
      return Colors.red;

    default:
      return Colors.black;
  }
}

String getStatus(String? status) {
  // verboseLog("status: $status");
  switch (status ?? "new") {
    case "missed":
      return "Missed";

    case "new":
      return "New";

    case "delivered":
      return "Ready";

    case "ready":
      return "Ready";

    case "process":
      return "In process";

    case "out_to_deliver":
      return "Out to deliver";

    case "on_the_way":
      return "On the way";

    case "arrived":
      return "Arrived";

    case "accept":
    case "prepared":
      return "Accepted";

    case "cancel":
      return "Cancelled";

    case "cancelled":
      return "Rejected";

    case "refund":
      return "Refunded";

    case "partially_refund":
      return "Partially Refunded";

    default:
      return (status ?? "").replaceAll("_", " ").capitalizeFirst ?? "";
  }
}

getRefundTypeText(String type) {
  switch (type) {
    case "fully":
      return "Full refund";
    case "partial":
      return "Partial refund";
    default:
      return "${type.capitalizeFirst} refund";
  }
}

getPaymentTypeText(String type, String planType) {
  type = type.toLowerCase();
  planType = planType.toLowerCase();
  switch (type) {
    case "stripe":
    case "card":
      return "Card";
    case "subscription":
      return planType == "free" ? "Free Offer" : type.capitalizeFirst;
    default:
      return type.capitalizeFirst;
  }
}

bool isValidDate(String date) {
  log("date: $date");
  List<String> dl = date.split("/");
  // dl[0] = month
  // dl[1] = day/date
  // dl[2] = year
  int day = int.tryParse(dl[1]) ?? 1;
  int month = int.tryParse(dl[0]) ?? 1;
  int year = 2000;
  // int year = int.tryParse(dl[2]) ?? 2000;

  String str = "2000-${dl[0]}-${dl[1]}";

  log("str: $str");
  log("month: $month day: $day");
  DateTime? parsedData = DateTime.tryParse(str);
  if (parsedData != null) {
    log("date not null: ${parsedData.toIso8601String()}");
    if (month <= 12 && day <= 31) {
      return true;
    }
  }
  log("----- date null -----");
  return false;
}

bool isValidExpiry(int month, int year) {
  // Get the current date
  final currentDate = DateTime.now();
  final currentMonth = currentDate.month;
  final currentYear = currentDate.year;

  // Check if the year is in the past
  if (year < currentYear) {
    return false;
  }

  // If the year is the same as the current year, check the month
  if (year == currentYear && month < currentMonth) {
    return false;
  }

  // The expiry date is valid
  return true;
}

String getOfferDuration(String offerDuration) {
  switch (offerDuration) {
    case 'day':
      return 'daily';
    case 'month':
      return 'monthly';
    case 'year':
      return 'yearly';
    default:
      return offerDuration;
  }
}

getFormattedDate(String date, {bool reversed = true}) {
  if (date.isEmpty) {
    return "";
  }

  List<String> dl = date.split("/");
  // dl[0] = month
  // dl[1] = day/date
  // dl[2] = year
  log("");
  if (reversed) {
    return "2000-${dl[0]}-${dl[1]}";
  }
  return "${dl[1]}-${dl[0]}-2000";
}

String getFormattedAddress(String? houseNo, String? street, String? landmark, String? city, String? state, String? zipcode) {
  List<String> components = [];
  // log("\n\n  order ID ----------------- $oID");
  // , {String? oID}
  // log("zipcode: $zipcode");

  if (houseNo != null && houseNo.trim().isNotEmpty) {
    // log("address: $address");
    components.add(houseNo);
  }

  if (street != null && street.trim().isNotEmpty) {
    // log("address: $address");
    components.add(street);
  }

  if (landmark != null && landmark.trim().isNotEmpty) {
    // log("address: $address");
    components.add(landmark);
  }

  if (city != null && city.trim().isNotEmpty) {
    // log("city: $city");
    components.add(city);
  }

  if (state != null && state.trim().isNotEmpty) {
    // log("state: $state");
    components.add(state);
  }

  if (zipcode != null && zipcode.trim().isNotEmpty && !(street?.contains(zipcode) ?? false)) {
    // log("zipcode: $zipcode");
    components.add(zipcode);
  }

  // log("joined address is: ${components.join(", ")}");
  return components.join(", ");
}

String removeDirectionalFormatting(String text) {
  return text.replaceAll('\u202C', ''); // '\u202C' represents the U+202C character
}

void hideKeyboard(context) => FocusScope.of(context).requestFocus(FocusNode());
//+Url Launcher
Future<void> launchUrlExternal(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

String encodeReservedCharacters(String url) {
  // Define the reserved characters and encode them
  // return Uri.encodeFull(url);
  // Parse the URL
  Uri uri = Uri.parse(url);

  log("uri.queryParameters:  ${uri.queryParameters}");

  // Encode the query parameter values correctly
  Map<String, String> encodedQueryParameters = uri.queryParameters.map(
    (key, value) => MapEntry(key, Uri.encodeComponent(value!)),
  );

  // Build and return the correctly encoded URL
  return Uri(
    scheme: uri.scheme,
    host: uri.host,
    path: uri.path,
    queryParameters: encodedQueryParameters,
  ).toString();
}

String encodeUrl(String baseUrl, Map<String, String> queryParams) {
  // Build the URL manually with encoded query parameters
  Uri uri = Uri.parse(baseUrl);
  String queryString = queryParams.entries.map((entry) {
    // Encode key and value
    String encodedKey = Uri.encodeQueryComponent(entry.key);
    String encodedValue = Uri.encodeQueryComponent(entry.value);
    return '$encodedKey=$encodedValue';
  }).join('&');

  // Rebuild the final URL with encoded query string
  return '${uri.scheme}://${uri.host}${uri.path}?$queryString';
}

extension DoubleFormatting on double {
  String formatNumber() {
    var formatter = NumberFormat("###.##"); // Customize the format as needed
    return formatter.format(this);
  }
}

String getCardType(String cardNumber) {
  if (cardNumber.isEmpty) return "Unknown";

  final Map<String, List<RegExp>> cardPatterns = {
    "Visa": [RegExp(r"^4")],
    "MasterCard": [RegExp(r"^5[1-5]"), RegExp(r"^222[1-9]"), RegExp(r"^22[3-9]"), RegExp(r"^2[3-6]"), RegExp(r"^27[01]"), RegExp(r"^2720")],
    "American Express": [RegExp(r"^3[47]")],
    "Discover": [RegExp(r"^6011"), RegExp(r"^65"), RegExp(r"^64[4-9]"), RegExp(r"^622(1[2-9]|[2-8]|9[01])")],
    "Diners Club": [RegExp(r"^3(0[0-5]|[68])")],
    "JCB": [RegExp(r"^35(2[89]|[3-8][0-9])")],
    "UnionPay": [RegExp(r"^62")],
  };

  for (var entry in cardPatterns.entries) {
    for (var pattern in entry.value) {
      if (pattern.hasMatch(cardNumber)) {
        return entry.key;
      }
    }
  }

  return "Unknown";
}

String getDeliveryInfoMessage(Map<String, dynamic> response) {
  final dynamic doordashFee = response["doordash_delivery_fee"];
  final dynamic distance = response["distance"];
  final dynamic responseMessage = response["responce"] is Map ? response["responce"]["message"] : null;

  final List<dynamic> messageCandidates = [
    doordashFee,
    distance,
    responseMessage,
  ];

  for (final candidate in messageCandidates) {
    final extracted = _extractDeliveryMessage(candidate);
    if (extracted != null) return extracted;
  }

  return "Something went wrong.";
}

String? _extractDeliveryMessage(dynamic candidate) {
  if (candidate == null) return null;
  if (candidate is String) {
    final trimmed = candidate.trim();
    if (trimmed.isEmpty) return null;
    // Skip purely numeric values such as "0.00"
    if (double.tryParse(trimmed) != null) return null;
    return trimmed;
  }
  if (candidate is num) return null;
  return null;
}
