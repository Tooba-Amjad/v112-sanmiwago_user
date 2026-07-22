import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.text,
    this.icon,
    this.padding,
    this.marginTop,
    this.marginBottom,
    this.marginRight,
    this.marginLeft,
    this.color,
    this.textColor,
    this.height,
    this.width,
    this.onPressed,
    this.fontWeight,
    this.fontSize,
    this.iconSize,
    this.child,
  });

  final String? text;
  final IconData? icon;
  final double? iconSize;
  final double? height;
  final double? width;
  final double? padding;
  final double? marginTop;
  final double? marginBottom;
  final double? marginRight;
  final double? marginLeft;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Function()? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? AppSizes.buttonHeight,
      width: width ?? (Get.width - 30),
      padding: EdgeInsets.all(padding ?? AppSizes.buttonPadding),
      margin: EdgeInsets.only(top: marginTop ?? 0, bottom: marginBottom ?? 0, right: marginRight ?? 0, left: marginLeft ?? 0),
      // margin: EdgeInsets.only(top: marginTop ?? 0, bottom: marginBottom ?? 0),
      child: MaterialButton(
        color: color ?? AppColors.kButtonRedColor,
        // height: height ?? AppSizes.buttonHeight,
        minWidth: width ?? (Get.width - 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
        ),
        onPressed: onPressed,
        child: child ?? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: iconSize,
                    color: textColor ?? AppColors.kButtonTextColor,
                  )
                : const SizedBox(),
            icon != null ? const SizedBox(width: 5) : const SizedBox(),
            Expanded(
              child: MyText(
                text: text ?? "",
                maxLines: 1,
                align: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                color: textColor ?? AppColors.kButtonTextColor,
                fontWeight: fontWeight ?? AppSizes.buttonFontWeight,
                fontSize: fontSize ?? AppSizes.buttonFontSize,
              ),
            ),
          ],
        ),
        // authController.loading.value == true
        //     ? const Center(
        //         child: SizedBox(
        //           height: 25,
        //           width: 25,
        //           child: CircularProgressIndicator(
        //             color: Colors.white,
        //             strokeWidth: 2,
        //           ),
        //         ),
        //       )
        //     : SizedBox(),
      ),
    );
  }
}
