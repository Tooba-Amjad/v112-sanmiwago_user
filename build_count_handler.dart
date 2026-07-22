import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String get formattedDate => DateFormat('MM-dd-yyyy').format(this);
}

void main(List<String> arguments) {
  if (arguments.length != 1) {
    print('Usage: dart build_count_handler.dart [environment]');
    exit(1);
  }

  String env = arguments[0];
  int newBuildCount = incrementBuildCount(env);

  print('✅ Build count updated for "$env" → New version: v$newBuildCount');
}

int incrementBuildCount(String env) {
  final File buildCountFile = File('build_count.json');
  int buildCount = 1;

  if (buildCountFile.existsSync()) {
    try {
      final DateTime now = DateTime.now();
      final String jsonString = buildCountFile.readAsStringSync();
      Map<String, dynamic> buildCounts = jsonDecode(jsonString);

      // If the environment doesn't exist, initialize it based on 'merge' or start at 1
      if (!buildCounts.containsKey(env)) {
        final int fallbackCount = buildCounts['merge']?['count'] ?? 1;
        buildCounts[env] = {'count': fallbackCount, 'date': now.formattedDate};
      }

      // Increment and update the build count
      buildCount = (buildCounts[env]['count'] ?? 0) + 1;
      buildCounts = updateCountForAllEnvs(buildCounts, buildCount);
      buildCounts[env]['date'] = now.formattedDate;

      // Save updated JSON back to file
      buildCountFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(buildCounts));
    } catch (e) {
      print('❌ Error updating build count: $e');
      exit(1);
    }
  } else {
    // File doesn't exist; create initial structure
    try {
      buildCountFile.createSync();
      buildCountFile.writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert({
          env: {'count': 1, 'date': DateTime.now().formattedDate}
        }),
      );
      print("ℹ️ Created 'build_count.json' with initial count for '$env'.");
    } catch (e) {
      print('❌ Error creating build_count.json: $e');
      exit(1);
    }
  }

  return buildCount;
}

Map<String, dynamic> updateCountForAllEnvs(Map<String, dynamic> buildCounts, int newBuildCount) {
  buildCounts.forEach((env, value) {
    if (value is Map<String, dynamic>) {
      value['count'] = newBuildCount;
    }
  });
  return buildCounts;
}

int getCurrentBuildCount(String env) {
  final File buildCountFile = File('build_count.json');
  if (!buildCountFile.existsSync()) {
    print('❌ Error: build_count.json not found.');
    exit(1);
  }

  try {
    final String jsonString = buildCountFile.readAsStringSync();
    final Map<String, dynamic> buildCounts = jsonDecode(jsonString);

    return buildCounts[env]?['count'] ?? buildCounts['merge']?['count'] ?? 1;
  } catch (e) {
    print('❌ Error reading build_count.json: $e');
    exit(1);
  }
}
