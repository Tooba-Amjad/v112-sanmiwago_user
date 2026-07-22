import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

showMsg({String? msg, Color? color, bool isSuccess = false, SnackPosition? position, Duration? time}) {
  if (Get.isSnackbarOpen) {
    Get.back();
  }
  Get.rawSnackbar(
    icon: isSuccess
        ? Icon(
            Icons.check_circle_outline_rounded,
            color: isSuccess ? AppColors.kSnackbarTextColor : AppColors.kSnackbarTextColor,
          )
        : Icon(
            Icons.error_outline,
            color: isSuccess ? AppColors.kSnackbarTextColor : AppColors.kSnackbarTextColor,
          ),
    messageText: MyText(
      text: msg ?? "",
      style: TextStyle(
        color: isSuccess ? AppColors.kSnackbarTextColor : AppColors.kSnackbarTextColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    isDismissible: true,
    duration: time ?? const Duration(seconds: 2),
    backgroundColor: color ?? (isSuccess ? AppColors.kGreenColor : AppColors.kRedColor),
    snackStyle: SnackStyle.GROUNDED,
    snackPosition: position ?? SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(20),
  );
}

/*! The Scaffold Messenger based snackbar !*/
void showScaffoldMsg({required BuildContext context, String? msg, Color? color, bool isSuccess = false, SnackPosition? position, Duration? time}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color ?? (isSuccess ? AppColors.kGreenColor : AppColors.kRedColor),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      content: Row(
        children: [
          isSuccess
              ? Icon(
                  Icons.check_circle_outline_rounded,
                  color: isSuccess ? AppColors.kSnackbarTextColor : AppColors.kSnackbarTextColor,
                )
              : Icon(
                  Icons.error_outline,
                  color: isSuccess ? AppColors.kSnackbarTextColor : AppColors.kSnackbarTextColor,
                ),
          const SizedBox(width: 15),
          Flexible(
            child: MyText(
              text: msg ?? "",
              style: TextStyle(
                color: isSuccess ? AppColors.kSnackbarTextColor : AppColors.kSnackbarTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      // action: SnackBarAction(
      //   label: 'Hide',
      //   backgroundColor: const Color(0xffFFFFFF),
      //   onPressed: () {
      //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //   },
      // ),
      duration: time ?? const Duration(seconds: 2),
    ),
  );
}

showCircularLoading({Color? color = AppColors.kTertiaryColor2, bool isDismissible = true}) {
  Get.dialog(
    barrierDismissible: isDismissible,
    Center(
      child: SizedBox(
        height: 35,
        width: 35,
        child: CircularProgressIndicator(
          color: color ?? AppColors.kGreenColor,
          strokeWidth: 1.5,
        ),
      ),
    ),
  );
}

dismissLoading() {
  if (Get.isSnackbarOpen) {
    log("snack bar open");
    Get.back();
  }
  if (Get.isDialogOpen == true) {
    log("dialog open");
    Get.back();
  }
}

showInlineLoading({Color color = AppColors.kLogoBasedColor, size = 16.0}) {
  return SpinKitThreeBounce(
    color: color,
    size: size,
  );
}

showMyAnimatedDialog({required BuildContext context, required Widget child}) {
  return showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: child,
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}
