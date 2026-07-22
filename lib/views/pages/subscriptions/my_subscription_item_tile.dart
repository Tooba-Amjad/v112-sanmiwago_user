import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_checkbox_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MySubscriptionItemTile extends StatelessWidget {
  const MySubscriptionItemTile({
    super.key,
    this.onTap,
    this.isSelected = false,
    this.onChanged,
    this.image,
    this.name,
    this.description,
    this.points,
    this.price,
    this.showImage = true,
    this.fontSize = 22,
    this.fontWeight = FontWeight.bold,
    this.textLeftPadding = 20,
  });

  final Function()? onTap;
  final bool isSelected;
  final Function(bool?)? onChanged;
  final String? image;
  final String? name;
  final String? description;
  final String? points;
  final String? price;
  final bool showImage;
  final double fontSize;
  final FontWeight fontWeight;
  final double textLeftPadding;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 30,
              width: 60,
              child: MyCheckBoxTile(
                value: isSelected,
                // color: Colors.pink,
                color: AppColors.kLogoBasedColor,
                borderRadius: 10,
                onChanged: onChanged,
              ),
            ),
            image != null && (image?.isNotEmpty ?? false) && showImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      height: 70,
                      width: 70,
                      imageUrl: image ?? "",
                      progressIndicatorBuilder: (context, url, progress) {
                        return MyCachedImageLoadingBuilder(
                          height: 70,
                          width: 70,
                          loadingProgress: progress.progress ?? 0,
                        );
                      },
                      errorWidget: (context, url, error) => const MyImageErrorBuilder(
                        height: 70,
                        width: 70,
                      ),
                      fit: BoxFit.contain,
                    ),
                  )
                : SizedBox(),
            Expanded(
              child: MyText(
                text: name,
                align: TextAlign.start,
                color: Colors.black,
                fontWeight: fontWeight,
                fontSize: fontSize,
                paddingLeft: textLeftPadding,
              ),
            ),
          ],
        ),
      ),
    );

    //   MyListTile(
    //   onTap: onTap,
    //   leading: image != null && (image?.isNotEmpty ?? false)
    //       ? ClipRRect(
    //           borderRadius: BorderRadius.circular(10),
    //           child: CachedNetworkImage(
    //             height: 70,
    //             width: 70,
    //             imageUrl: image ?? "",
    //             progressIndicatorBuilder: (context, url, progress) {
    //               return MyCachedImageLoadingBuilder(
    //                 height: 70,
    //                 width: 70,
    //                 loadingProgress: progress.progress ?? 0,
    //               );
    //             },
    //             errorWidget: (context, url, error) => const MyImageErrorBuilder(
    //               height: 70,
    //               width: 70,
    //             ),
    //             fit: BoxFit.contain,
    //           ),
    //         )
    //       : null,
    //   title: MyText(
    //     text: name,
    //     align: TextAlign.start,
    //     color: Colors.black,
    //     fontWeight: FontWeight.bold,
    //     fontSize: 22,
    //     paddingLeft: 0,
    //   ),
    //   // subtitle: RichText(
    //   //   text: TextSpan(
    //   //     text: description ?? "",
    //   //     style: const TextStyle(
    //   //       color: AppColors.kLightGreyColor,
    //   //       fontWeight: FontWeight.normal,
    //   //       fontSize: 14,
    //   //     ),
    //   //     children: [
    //   //       TextSpan(
    //   //         text: " | To Redeem ${points ?? "0"} Points",
    //   //         style: const TextStyle(
    //   //           color: AppColors.kGreenColor,
    //   //           fontWeight: FontWeight.normal,
    //   //           fontSize: 14,
    //   //         ),
    //   //       ),
    //   //     ],
    //   //   ),
    //   // ),
    //   trailing: MyText(
    //     text: "\$$price",
    //     align: TextAlign.start,
    //     color: Colors.black,
    //     fontWeight: FontWeight.bold,
    //     fontSize: 16,
    //     paddingLeft: 0,
    //   ),
    // );
  }
}
