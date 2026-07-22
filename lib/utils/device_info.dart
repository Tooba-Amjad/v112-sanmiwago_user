import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // log('Running on ${androidInfo.toString()}');  // e.g. "Moto G (4)"
    return androidInfo;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    log('Running on ${iosInfo.utsname.machine}');
    return iosInfo;
  } else if (Platform.isWindows) {
    WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    return windowsInfo;
  }
}

getDeviceId() async {
  String deviceId = "";
  if (Platform.isAndroid) {
    AndroidDeviceInfo deviceInfo = await getDeviceInfo() as AndroidDeviceInfo;
    deviceId = deviceInfo.id;
    log("deviceInfo.id = ${deviceInfo.id}");
  } else {
    IosDeviceInfo deviceInfo = await getDeviceInfo() as IosDeviceInfo;
    deviceId = deviceInfo.identifierForVendor ?? "";
  }
  return deviceId;
}


Future<String> getOrCreateUUIDDeviceId() async {
  final prefs = await SharedPreferences.getInstance();
  var deviceId = prefs.getString('device_id');
  if (deviceId == null) {
    deviceId = const Uuid().v4(); // random unique string
    await prefs.setString('device_id', deviceId);
  }
  return deviceId;
}

