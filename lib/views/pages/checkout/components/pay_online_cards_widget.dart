import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/generated/assets.dart';
import 'package:sanmiwago_user/views/widgets/my_checkbox_tile.dart';

class PayOnlineCardsWidget extends StatelessWidget {
  const PayOnlineCardsWidget({
    super.key,
    required this.checkBoxValue,
    this.onChanged,
  });

  final bool checkBoxValue;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1),
        border: Border.all(color: AppColors.kLightGreyColor, width: 1),
      ),
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyCheckBoxTile(
            title: "Pay Online",
            value: checkBoxValue,
            color: AppColors.kLogoBasedColor,
            borderRadius: 10,
            onChanged: onChanged,
          ),
          Container(
            height: 50,
            width: Get.width,
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.kSkyLightDullColor,
              borderRadius: BorderRadius.circular(1),
              // border: Border.all(color: AppColors.kLightGreyColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.iconsDiscover,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  Assets.iconsAmex,
                  height: 45,
                  width: 45,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  Assets.iconsMastercard,
                  height: 45,
                  width: 45,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  Assets.iconsVisa,
                  height: 50,
                  width: 50,
                ),
                // Image.asset(Assets.iconsDiscover),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
