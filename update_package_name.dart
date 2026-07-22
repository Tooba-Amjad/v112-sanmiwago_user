import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'build_count_handler.dart';
import 'rename_apk.dart';

String _devPackageName = "com.sanmiwagodumplinghouse.sanmiwagoUserDev";
String _ddevPackageName = "com.sanmiwagodumplinghouse.sanmiwagoUserDDev";
String _mergePackageName = "com.sanmiwagodumplinghouse.sanmiwagoUserMerge";
String _prod1PackageName = "com.sanmiwagodumplinghouse.sanmiwagoUserPOne";
String _prod1OldPackageName = "com.sanmiwagodumplinghouse.sanmiwagoUserPOneOld";
String _prod1NewPackageName = "com.sanmiwagodumplinghouse.sanmiwagoUserPOneNew";
String _prod2PackageName = "com.sanmiwagodumplinghouse.sanmiwagoUserPT";
String _prodBackupPackageName = "com.sanmiwagodumplinghouse.sanmiwagoUserProdBackup";
String _prodPackageName = "com.sanmiwagodumplinghouse.sanmiwagoUser";
String _prodAWSPackageName = "com.sanmiwagodumplinghouse.sanmiwagoUserAWS";

String _devAppName = "Dev-User";
String _ddevAppName = "DDev-User";
String _mergeAppName = "User-M";
String _prod1AppName = "User-P1";
String _prod1OldAppName = "P1-Old-User";
String _prod1NewAppName = "P1-New-User";
String _prod2AppName = "P2-User";
String _prodBackupAppName = "PB-User";
String _prodAppName = "Sanmiwago";
String _prodAWSAppName = "sanmiuser";

List<String> _packagesList = [_devPackageName, _ddevPackageName, _prod2PackageName, _prodPackageName, _prodAWSPackageName];

String _packageName = "com.sanmiwagodumplinghouse.sanmiwagoManagerDev";
String _environment = "dev";

String _mainDir = "android/app/src/main";
String _lang = "kotlin";
String _activityFileName = "MainActivity";

void main(List<String> arguments) {
  // Check if correct arguments are passed
  if (arguments.length != 1 ||
      (arguments[0] != 'dev' &&
          arguments[0] != 'ddev' &&
          arguments[0] != 'merge' &&
          arguments[0] != 'prod1' &&
          arguments[0] != 'prod1old' &&
          arguments[0] != 'prod1new' &&
          arguments[0] != 'prod2' &&
          arguments[0] != 'prodbackup' &&
          arguments[0] != 'prod' &&
          arguments[0] != 'prodaws')) {
    print('Usage: dart update_package_name.dart [environment]');
    print('Environment should be either "dev", "ddev", "prod1", "prod1old", "prod1new", "prod2", "prodbackup" or "prod".');
    return;
  }

  _environment = arguments[0];

  _packageName = getPackageName(_environment);

  /// Update package name in AndroidManifest.xml
  updateAndroidManifest(_packageName);

  /// Update package name in app/build.gradle
  updateBuildGradle(_packageName);

  /// create the MainActivity.kt / MainActivity.java
  buildNewMainActivity(_packageName);

  print('Package name updated to: $_packageName for $_environment environment.');
}

void updateAndroidManifest(String packageName) {
  File mainManifestFile = File('android/app/src/main/AndroidManifest.xml');
  File profileManifestFile = File('android/app/src/profile/AndroidManifest.xml');
  File debugManifestFile = File('android/app/src/debug/AndroidManifest.xml');
  String mainFileContent = mainManifestFile.readAsStringSync();
  String profileFileContent = profileManifestFile.readAsStringSync();
  String debugFileContent = debugManifestFile.readAsStringSync();
  log("debugFileContent: $debugFileContent");

  // Replace package name in AndroidManifest.xml
  mainFileContent = mainFileContent.replaceAll(RegExp('package=".*?"'), 'package="$packageName"').replaceAll(
        RegExp('android:label="(.*)"'),
        'android:label="${getAppName(_environment)}"',
      );
  profileFileContent = profileFileContent.replaceAll(RegExp('package=".*?"'), 'package="$packageName"');
  debugFileContent = debugFileContent.replaceAll(RegExp('package=".*?"'), 'package="$packageName"');

  mainManifestFile.writeAsStringSync(mainFileContent);
  profileManifestFile.writeAsStringSync(profileFileContent);
  debugManifestFile.writeAsStringSync(debugFileContent);
}

void updateBuildGradle(String packageName) {
  File appLevelGradle = File('android/app/build.gradle');
  String appLevelGradleContent = appLevelGradle.readAsStringSync();

  // Replace package name in AndroidManifest.xml
  appLevelGradleContent = appLevelGradleContent
      .replaceAll(RegExp('applicationId ".*?"'), 'applicationId "$packageName"')
      .replaceAll(RegExp("applicationId '.*?'"), 'applicationId "$packageName"')
      .replaceAll(RegExp("namespace '.*?'"), 'namespace "$packageName"')
      .replaceAll(RegExp('namespace ".*?"'), 'namespace "$packageName"');

  appLevelGradle.writeAsStringSync(appLevelGradleContent);
}

void buildNewMainActivity(String packageName) {
  List<String> packageNameList = packageName.split(".");

  String fileExt = _lang == "kotlin" ? "kt" : "java";
  String packagePath = packageName.replaceAll(".", "/");

  File newMainActivity = File('$_mainDir/$_lang/$packagePath/$_activityFileName.$fileExt');
  newMainActivity.createSync(recursive: true);
  // String appLevelGradleContent = newMainActivity.readAsStringSync();

  // Replace package name in AndroidManifest.xml
  // appLevelGradleContent = appLevelGradleContent.replaceAll(RegExp('applicationId ".*?"'), 'applicationId "$packageName"');

  newMainActivity.writeAsStringSync(getLangMainActivityText());
}

getPackageName(String env) {
  switch (env) {
    case "dev":
      return _devPackageName;
    case "ddev":
      return _ddevPackageName;
    case "merge":
      return _mergePackageName;
    case "prod1":
      return _prod1PackageName;
    case "prod1old":
      return _prod1OldPackageName;
    case "prod1new":
      return _prod1NewPackageName;
    case "prod2":
      return _prod2PackageName;
    case "prodaws":
      return _prodAWSPackageName;
    case "prodbackup":
      return _prodBackupPackageName;
    case "prod":
      return _prodPackageName;
    default:
      return _devPackageName;
  }
}

getAppName(String env) {
  switch (env) {
    case "dev":
      return _devAppName;
    case "ddev":
      return _ddevAppName;
    case "merge":
      return "$_mergeAppName-v${getCurrentBuildCount(env)}";
    case "prod1":
      return "$_prod1AppName-v${getCurrentBuildCount(env)}";
    case "prod1old":
      return _prod1OldAppName;
    case "prod1new":
      return _prod1NewAppName;
    case "prod2":
      return _prod2AppName;
    case "prodaws":
      return _prodAWSAppName;
    case "prodbackup":
      return _prodBackupAppName;
    case "prod":
      return _prodAppName;
    default:
      return _devAppName;
  }
}

getLangMainActivityText() {
  for (String package in _packagesList) {
    final String fileExt = _lang == "kotlin" ? "kt" : "java";
    File oldMainActivity = File('$_mainDir/$_lang/${package.replaceAll(".", "/")}/$_activityFileName.$fileExt');
    if (oldMainActivity.existsSync()) {
      String oldMainActivityContent = oldMainActivity.readAsStringSync();

      // Replace package name in AndroidManifest.xml
      oldMainActivityContent = oldMainActivityContent.replaceAll(RegExp('package .*'), 'package $_packageName');
      return oldMainActivityContent;
    } else {
      return _lang == "kotlin" ? _androidKotlinMainActivityTemplate : _androidJavaMainActivityTemplate;
    }
  }
}

// ! Templates
final _androidKotlinMainActivityTemplate = '''
package $_packageName

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
''';

final _androidJavaMainActivityTemplate = '''
package $_packageName

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
}
''';
