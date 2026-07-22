import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MyCategoryTile extends StatelessWidget {
  const MyCategoryTile({
    super.key,
    required this.name,
    this.image,
    this.onTap,
    this.isSelected = false,
    this.borderRadius = 20,
    this.borderColor = AppColors.kBorderColor,
    this.selectedColor,
    this.padding,
  });

  final String name;
  final String? image;
  final Function()? onTap;
  final bool isSelected;
  final double borderRadius;
  final Color borderColor;
  final Color? selectedColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    // double containerWidth = ((name.length <= 10)
    //     ? ((name.length + 2) * 13)
    //     : (name.length > 10 && name.length <= 15)
    //         ? (name.length * 13)
    //         : ((name.length - 1) * 13));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        /* width: image != null ? containerWidth : (containerWidth - 40),
        */
        //! anything equal to and less than 10 might need (length + 2)
        //! | between 11 and 15 is equal
        //! | else for 15+ (length - 2)
        height: Get.height,
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        alignment: Alignment.center,
        padding:
            // image != null && (image?.isNotEmpty ?? false) ? (padding ?? const EdgeInsets.fromLTRB(10, 10, 10, 0)) :
            (padding ?? const EdgeInsets.fromLTRB(10, 0, 10, 0)),
        // color: AppColors.kRedColor,
        decoration: BoxDecoration(
          color: isSelected ? (selectedColor ?? AppColors.kLogoBasedColor) : AppColors.kPrimaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
        ),
        child:
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            // const SizedBox(width: 5),
            /*+ Image part was commented out +*/
            // image != null && (image?.isNotEmpty ?? false)
            //     ? ClipRRect(
            //         borderRadius: BorderRadius.circular(10),
            //         child: CachedNetworkImage(
            //           height: 40,
            //           width: 40,
            //           imageUrl: image ?? "",
            //           progressIndicatorBuilder: (context, url, progress) {
            //             return MyCachedImageLoadingBuilder(
            //               height: 40,
            //               width: 40,
            //               loadingProgress: progress.progress ?? 0,
            //             );
            //           },
            //           errorWidget: (context, url, error) =>
            //           const MyImageErrorBuilder(
            //             height: 23,
            //             width: 30,
            //           ),
            //           fit: BoxFit.cover,
            //         ),
            //       )
            //     : const SizedBox(),
            MyText(
              text: name,
              align: TextAlign.start,
              color: isSelected ? AppColors.kPrimaryColor : Colors.black,
              fontWeight: FontWeight.bold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              paddingLeft: (image != null && (image?.isNotEmpty ?? false)) ? 10 : 0,
            ),
          ],
        ),
      ),
    );
  }
}
