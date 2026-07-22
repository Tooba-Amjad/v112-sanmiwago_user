import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';

dividerCommon({double thickness = 1, double height = 2, Color color = AppColors.kBorderColor}) {
  return Divider(
    thickness: thickness,
    height: height,
    color: color,
  );
}
