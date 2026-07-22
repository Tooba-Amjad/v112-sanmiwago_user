import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';

class MyText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final FontWeight? fontWeight;
  final TextAlign? align;
  final TextDecoration? decoration;
  final Color? color;
  final double? fontSize, height;
  final String? fontFamily;
  final int maxLines;
  final TextOverflow? overflow;
  final TextOverflow? overFlow2;
  final VoidCallback? onTap;
  final FontStyle? fontStyle;
  final double? paddingTop, paddingLeft, paddingRight, paddingBottom, letterSpacing;

  const MyText({
    super.key,
    this.text,
    this.style,
    this.fontSize,
    this.height,
    this.maxLines = 100,
    this.decoration = TextDecoration.none,
    this.color = AppColors.kSecondaryColor,
    this.letterSpacing,
    this.fontWeight = FontWeight.w400,
    this.align,
    this.overflow,
    this.overFlow2,
    this.fontFamily,
    this.paddingTop = 0,
    this.paddingRight = 0,
    this.paddingLeft = 0,
    this.paddingBottom = 0,
    this.fontStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop!,
        left: paddingLeft!,
        right: paddingRight!,
        bottom: paddingBottom!,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text ?? "",
          // textScaler: TextScaler.noScaling,
          style: style ?? TextStyle(
            fontSize: fontSize,
            color: color ?? Colors.black,
            fontWeight: fontWeight,
            decoration: decoration,
            fontFamily: fontFamily,
            height: height,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
            overflow: overFlow2,
          ),
          textAlign: align,
          maxLines: maxLines,
          overflow: overflow,
        ),
      ),
    );
  }
}
