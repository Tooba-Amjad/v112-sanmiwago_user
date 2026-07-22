import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MyGiftcardTabTile extends StatelessWidget {
  const MyGiftcardTabTile({
    super.key,
    required this.name,
    this.onTap,
    this.isSelected = false,
    this.borderRadius = 20,
    this.borderColor = AppColors.kBorderColor,
    this.selectedColor,
    this.padding,
  });

  final String name;
  final Function()? onTap;
  final bool isSelected;
  final double borderRadius;
  final Color borderColor;
  final Color? selectedColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height,
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        padding: padding ?? const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: isSelected ? (selectedColor ?? AppColors.kLogoBasedColor) : AppColors.kPrimaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            MyText(
              text: name,
              align: TextAlign.start,
              color: isSelected ? AppColors.kPrimaryColor : Colors.black,
              fontWeight: FontWeight.bold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              paddingLeft: 0,
            ),
          ],
        ),
      ),
    );
  }
}
