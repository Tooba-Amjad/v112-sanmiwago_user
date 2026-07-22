import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_checkbox_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_listtile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MyRestaurantTile extends StatelessWidget {
  const MyRestaurantTile({
    super.key,
    this.onTap,
    this.name,
    this.address,
    this.phone,
    this.isSelected = false,
    this.onChanged,
  });

  final Function()? onTap;
  final Function(bool?)? onChanged;
  final String? name;
  final String? address;
  final String? phone;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppColors.kLogoBasedColor.withOpacity(0.3),
      color: isSelected ? AppColors.kLogoBasedColor.withOpacity(0.3) : Colors.transparent,
      child: MyListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          title: MyText(
            text: name,
            align: TextAlign.start,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          subtitle: RichText(
            text: TextSpan(
              text: address ?? "",
              style: const TextStyle(
                color: AppColors.kGreyColor2,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: " \n+1 ${phone ?? ""}",
                  style: const TextStyle(
                    color: AppColors.kGreyColor2,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          trailing: SizedBox(
            height: 30,
            width: 60,
            child: MyCheckBoxTile(
              value: isSelected,
              color: AppColors.kLogoBasedColor,
              borderRadius: 10,
              onChanged: onChanged,
            ),
          )
          // MyText(
          //   text: "\$$price",
          //   align: TextAlign.start,
          //   color: Colors.black,
          //   fontWeight: FontWeight.bold,
          //   fontSize: 16,
          //   paddingLeft: 0,
          // ),
          ),
    );
  }
}
