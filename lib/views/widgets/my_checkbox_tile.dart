import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';

import 'my_text.dart';

class MyCheckBoxTile extends StatelessWidget {
  // final double textPaddingTop;
  final bool value;
  final String title;
  final double borderRadius;
  final double? cbh;
  final double? cbw;
  /// Only affects the scaling when cbh and cbw both are provided
  final double scale;
  final Color? color;
  final Function(bool?)? onChanged;

  /// To restrict the checkbox from taking too much space, please provide both cbh and cbw -- scaling
  /// by default in this case will be set to 0.75 but you can set accordingly as you want.
  const MyCheckBoxTile({
    super.key,
    // this.textPaddingTop = 0,
    this.title = "",
    this.borderRadius = 3,
    required this.value,
    this.color,
    this.onChanged,
    this.cbh,
    this.cbw,
    this.scale = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // key: ValueKey(title),
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // crossAxisAlignment: isTopAligned ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (cbh != null && cbw != null)
              ? SizedBox(
                  height: cbh,
                  width: cbw,
                  child: Transform.scale(
                    scale: scale,
                    child: Checkbox(
                      value: value,
                      activeColor: color ?? AppColors.kSecondaryColor,
                      onChanged: onChanged,
                      side: const BorderSide(
                        color: AppColors.kSecondaryColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                    ),
                  ),
                )
              : Checkbox(
                  value: value,
                  activeColor: color ?? AppColors.kSecondaryColor,
                  onChanged: onChanged,
                  side: const BorderSide(
                    color: AppColors.kSecondaryColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                ),
          Expanded(
            child: MyText(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              text: title,
              fontSize: 14,
              color: AppColors.kSecondaryColor,
              // paddingTop: textPaddingTop,
            ),
          ),
        ],
      ),
    );
  }
}
