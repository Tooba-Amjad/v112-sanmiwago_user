import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';

class DropDownDeco {
  static final dropDownDeco = BoxDecoration(
    borderRadius: BorderRadius.circular(6),
    border: Border.all(
      width: 1.0,
      color: AppColors.kBorderColor,
    ),
  );

  static const dropDownText = TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.kBlackColor,
    fontSize: 16.0,
  );
  static const dropDownSignUpText = TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.kBorderColor,
    fontSize: 16.0,
  );
  static const dropDownSignUpSelectedText = TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.kBlackColor,
    fontSize: 16.0,
  );
}

class CustomInputDecoration {
  static const cursorColor = AppColors.kGreyColor;
  static const padding = EdgeInsets.symmetric(
    horizontal: AppSizes.fieldsPadding,
    vertical: 0,
  );
  static const textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.kBlackColor,
  );
  static const hintStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.kGreyColor,
  );
  static const fixStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.kBlackColor,
  );
  static const fixHintStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.kGreyColor,
  );
  static const fixLabelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.kBlackColor,
  );
  static final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(
      color: AppColors.kBorderColor,
      width: 1,
    ),
  );
  static final fixBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(
      color: AppColors.kBorderColor,
      width: 1,
    ),
  );
  static final focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(
      color: AppColors.kBorderColor,
      width: 1,
    ),
  );
  static final errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(
      color: Colors.red,
      width: 1,
    ),
  );
  static const errorStyle = TextStyle(color: Colors.red);
}
