import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/api_constants.dart';
import 'package:sanmiwago_user/utils/time_formatters.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../utils/snack_bar.dart';
import '../../widgets/my_text.dart';
import '../../widgets/simple_appbar.dart';
import 'package:sanmiwago_user/utils/enums.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    readJson();
    super.initState();
  }

  Map<String, dynamic> countJson = {};
  readJson() async {
    final String jsonString = await rootBundle.loadString('build_count.json');
    setState(() {
      log("jsonString: $jsonString");
      countJson = jsonDecode(jsonString) as Map<String, dynamic>;
    });
  }

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: "About", haveBackIcon: true),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 25),
                MyText(
                  text: "Environment: ${ApiConstants.env.name.capitalizeFirst}",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  paddingBottom: 10,
                ),
                MyText(
                  // text: "Version: #${countJson[ApiConstants.env.name]?["count"] ?? "0.0.0"}",
                  text: "Version: #${countJson[ApiConstants.env.name]?["count"] ?? countJson[EnvType.merge.name]?["count"] ?? 1}",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  paddingBottom: 10,
                ),
                MyText(
                  text: "Release Date: ${countJson[ApiConstants.env.name]?["date"] ?? now.formattedDate}",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  paddingBottom: 10,
                ),
                // const Divider(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
