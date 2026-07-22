import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MyConfirmDialog extends StatelessWidget {
  const MyConfirmDialog({
    Key? key,
    required this.msg,
    this.height = 220,
    required this.yesOnPressed,
    this.noOnPressed,
    this.isSuccessMessage = false,
  }) : super(key: key);

  final String msg;
  final double height;
  final Function() yesOnPressed;
  final Function()? noOnPressed;
  final bool isSuccessMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      content: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !isSuccessMessage
                ? const Icon(
                    Icons.error,
                    color: AppColors.kRedColor,
                    size: 35,
                  )
                : const Icon(
                    Icons.check_circle,
                    color: AppColors.kGreenColor,
                    size: 35,
                  ),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            MyText(
              text: msg,
              color: AppColors.kBlackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              align: TextAlign.center,
              paddingBottom: 10,
            ),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: MyButton(
                      text: "No",
                      height: 52,
                      width: Get.width - 30,
                      padding: 0,
                      marginBottom: 10,
                      color: AppColors.kButtonRedColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                        noOnPressed != null ? noOnPressed!() : () {};
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: MyButton(
                      text: "Yes",
                      height: 52,
                      width: Get.width - 30,
                      padding: 0,
                      marginBottom: 10,
                      color: AppColors.kGreenColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                        yesOnPressed();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyNewConfirmDialog extends StatelessWidget {
  const MyNewConfirmDialog({
    super.key,
    required this.title,
    required this.msg,
    this.rightButtonText,
    this.leftButtonText,
    this.height = 220,
    this.rightButtonWidth = 80,
    this.leftButtonWidth = 80,
    required this.yesOnPressed,
    this.noOnPressed,
    this.isSuccessMessage = false,
  });

  final String title;
  final String msg;
  final String? rightButtonText;
  final String? leftButtonText;
  final double height;
  final double rightButtonWidth;
  final double leftButtonWidth;
  final Function() yesOnPressed;
  final Function()? noOnPressed;
  final bool isSuccessMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      content: Container(
        // height: height,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.kSkyLightColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: MyText(
                      text: title,
                      color: AppColors.kBlackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      align: TextAlign.left,
                      // paddingBottom: 10,
                      paddingLeft: 10,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
            // dividerCommon(),
            const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
            MyText(
              text: msg,
              color: AppColors.kGreyColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              align: TextAlign.left,
              paddingBottom: 0,
              paddingLeft: 10,
              paddingRight: 10,
            ),
            const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
            dividerCommon(),
            const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                    width: leftButtonWidth,
                    child: MyButton(
                      text: leftButtonText ?? "Cancel",
                      height: 52,
                      fontSize: 15,
                      width: leftButtonWidth,
                      padding: 0,
                      marginBottom: 10,
                      color: AppColors.kButtonRedColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                        noOnPressed != null ? noOnPressed!() : () {};
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 50,
                    // width: rightButtonWidth,
                    child: MyButton(
                      text: rightButtonText ?? "Confirm!",
                      height: 52,
                      fontSize: 15,
                      width: rightButtonWidth,
                      padding: 0,
                      marginBottom: 10,
                      color: AppColors.kGreenColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                        yesOnPressed();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyInfoDialog extends StatelessWidget {
  const MyInfoDialog({
    Key? key,
    required this.msg,
    this.height = 220,
    this.buttonText,
    this.buttonOnPressed,
    this.isSuccessMessage = false,
  }) : super(key: key);

  final String msg;
  final String? buttonText;
  final double height;
  final Function()? buttonOnPressed;
  final bool isSuccessMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      content: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !isSuccessMessage
                ? const Icon(
                    Icons.error,
                    color: AppColors.kRedColor,
                    size: 35,
                  )
                : const Icon(
                    Icons.check_circle,
                    color: AppColors.kGreenColor,
                    size: 35,
                  ),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            MyText(
              text: msg,
              color: AppColors.kBlackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              align: TextAlign.center,
              paddingBottom: 10,
            ),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: MyButton(
                      text: buttonText ?? "Ok",
                      height: 52,
                      width: Get.width - 30,
                      padding: 0,
                      marginBottom: 10,
                      color: AppColors.kGreenColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                        buttonOnPressed != null ? buttonOnPressed!() : () {};
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
