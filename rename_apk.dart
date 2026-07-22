import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

import 'build_count_handler.dart';
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:googleapis_auth/auth_io.dart' as auth;

extension DateTimeFormatting on DateTime {
  // Format: MM-dd-yyyy
  String get formattedDate => DateFormat('MM-dd-yyyy').format(this);
}

List _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

Future<void> main(List<String> arguments) async {
  // if (arguments.length != 2) {
  //   print('Usage: dart rename_apk.dart <sourceApkPath> <newApkName>');
  //   return;
  // }

  // String sourceApkPath = arguments[0];
  // String newApkName = arguments[1];

  // Retrieve and increment the build count

  String env = arguments[0];
  int buildCount = getCurrentBuildCount(env);
  String sourceApkPath = "build/app/outputs/flutter-apk/app-release.apk";
  DateTime now = DateTime.now();
  String newApkName = "v$buildCount-sanmiwago-user-$env-${_months[now.month - 1]}${now.day}y${now.year}.apk";

  if (env == "prod1") {
    newApkName = "v$buildCount-sanmiwago-user-$env-mgrv45-${_months[now.month - 1]}${now.day}y${now.year}.apk";
  } else if (env == "prod1old") {
    newApkName = "v$buildCount-sanmiwago-user-$env-feb28v-${_months[now.month - 1]}${now.day}y${now.year}.apk";
  } else if (env == "prod1new") {
    newApkName = "v$buildCount-sanmiwago-user-$env-mar19v-${_months[now.month - 1]}${now.day}y${now.year}.apk";
  }

  // Check if the source APK file exists
  if (!File(sourceApkPath).existsSync()) {
    print('Error: Source APK file does not exist.');
    return;
  }

  try {
    // Rename the APK file
    File sourceApkFile = File(sourceApkPath);
    String destinationPath = sourceApkFile.parent.path + Platform.pathSeparator + newApkName;
    sourceApkFile.renameSync(destinationPath);
    // await uploadToDrive(destinationPath, newApkName, env);

    print('APK file renamed successfully to: $newApkName');
  } catch (e) {
    print('Error: Failed to rename APK file. ${e.toString()}');
  }
}

// uploadToDrive(String apkPath, String apkName, String env) async {
//   final credentials = File('client_secret_console_apk_upload.json').readAsStringSync();
//   final Map<String, dynamic> jsonCreds = jsonDecode(credentials);
//   print("jsonCreds: $jsonCreds");
//   final clientId = jsonCreds["installed"]["client_id"];
//   final clientSecret = jsonCreds["installed"]["client_secret"];
//   final scopes = [drive.DriveApi.driveFileScope];
//
//   final client = await auth.clientViaUserConsent(
//     auth.ClientId(clientId, clientSecret),
//     scopes,
//     (url) {
//       print('Please go to the following URL and grant access:');
//       print('$url');
//     },
//   );
//
//
//   final driveApi = drive.DriveApi(client);
//
//   // final credentials = File('drive-upload-service-key.json').readAsStringSync();
//   //
//   // final client = await auth.clientViaServiceAccount(
//   //   auth.ServiceAccountCredentials.fromJson(credentials),
//   //   [drive.DriveApi.driveFileScope],
//   // );
//   //
//   // final driveApi = drive.DriveApi(client);
//   final file = File(apkPath);
//
//   final driveFile = drive.File()
//     ..name = apkPath
//     ..parents = [getDriveFolderId(env)]; // Replace 'folderId' with the ID of the folder in your Google Drive
//
//   try {
//     final result = await driveApi.files.create(
//       driveFile,
//       uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
//     );
//
//     final shareableLink = await driveApi.permissions.create(
//       drive.Permission.fromJson({
//         'role': 'reader',
//         'type': 'anyone',
//       }),
//       result.id ?? "",
//     );
//
//     // Get the file metadata to retrieve the shareable link
//     final fileInfo = await driveApi.files.get(result.id ?? "", $fields: 'webViewLink') as drive.File;
//     final webViewLink = fileInfo.webViewLink;
//     print('File Info: ${fileInfo.toJson()}');
//     print('Shareable link: $webViewLink');
//
//     // print('Uploaded successfully. Shareable link: ${shareableLink.}');
//   } catch (e) {
//     print('Error uploading file: $e');
//   } finally {
//     client.close();
//   }
// }

getDriveFolderId(String env) {
  switch (env) {
    case "dev":
      return "1XmUKsJiVIoK8SEcFVjoc8owYo5mGRY-3";
    case "ddev":
      return "1eVpcxptgD8BDaFkfrOiUTDrs1JC0dE9M";
    case "prod2":
      return "1BLumfw92zqIPiii8foVjmFDsKSoN2cFS";
    case "prod":
      return "1BJAsTaMnbtwy1KWwpHHgUCZmLi0QYyhk";
    default:
      return "1XmUKsJiVIoK8SEcFVjoc8owYo5mGRY-3";
  }
}
