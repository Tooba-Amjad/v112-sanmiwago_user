import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

AppBar simpleAppBar({
  String? title,
  bool? haveBackIcon = false,
  bool? haveDrawerIcon = false,
  Function()? onBackPressed,
  List<Widget>? actions,
}) {
  return AppBar(
    leading: haveBackIcon == true
        ? GestureDetector(
            onTap: onBackPressed ??
                () {
                  log("pressed back Icon");
                  Get.back();
                },
            child: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            ),
          )
        : haveDrawerIcon == true
            ? GestureDetector(
                onTap: () {
                  drawerController.openDrawer();
                },
                child: const Icon(
                  Icons.menu_rounded,
                  // FontAwesomeIcons.barsStaggered,
                  color: Colors.black,
                ),
              )
            : null,
    automaticallyImplyLeading: false,
    centerTitle: false,
    title: Row(
      children: [
        Expanded(
          child: MyText(
            text: title ?? "",
            fontSize: 19,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    actions: actions,
    // flexibleSpace: PreferredSize(
    //   preferredSize: const Size.fromHeight(25.0),
    //   child: Container(
    //     color: AppColors.kRedColor,
    //     height: 25.0,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Icon(
    //           Icons.location_on_outlined,
    //           color: Colors.white,
    //           size: 19,
    //         ),
    //         MyText(
    //           text: restaurantController.selectedRestaurant.value.branchName,
    //           fontSize: 16,
    //           paddingLeft: 2,
    //           color: Colors.white,
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(25.0),
      child: Container(
        color: Color(0xffff7925), // AppColors.kLogoBasedColor,
        height: 25.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Colors.white,
              size: 19,
            ),
            Obx(() {
              return MyText(
                text: restaurantController.selectedRestaurant.value.branchName,
                fontSize: 16,
                paddingLeft: 2,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              );
            }),
          ],
        ),
      ),
    ),
  );
}
