import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_listtile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MyItemTile extends StatelessWidget {
  const MyItemTile({
    super.key,
    this.onTap,
    this.image,
    this.name,
    this.description,
    this.points,
    this.price,
  });

  final Function()? onTap;
  final String? image;
  final String? name;
  final String? description;
  final String? points;
  final String? price;

  @override
  Widget build(BuildContext context) {
    return MyListTile(
      onTap: onTap,
      leading: image != null && (image?.isNotEmpty ?? false)
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
                errorWidget: (context, url, error) =>
                    const MyImageErrorBuilder(
                      height: 70,
                      width: 70,
                    ),
                fit: BoxFit.contain,
              ),
              // Image.network(
              //   image ?? "",
              //   height: 70,
              //   width: 70,
              //   fit: BoxFit.fill,
              //   loadingBuilder: (context, child, loadingProgress) {
              //     if (loadingProgress == null) return child;
              //     // log("loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!");
              //     // log("${loadingProgress.expectedTotalBytes!}");
              //     return MyImageLoadingBuilder(
              //       height: 70,
              //       width: 70,
              //       loadingProgress: loadingProgress,
              //     );
              //   },
              //   errorBuilder: (context, error, stackTrace) {
              //     return const MyImageErrorBuilder(
              //       height: 70,
              //       width: 70,
              //     );
              //   },
              // ),
            )
          : null,
      // : const SizedBox(
      //     height: 70,
      //     width: 70,
      //     child: Icon(
      //       Icons.image_not_supported_outlined,
      //     ),
      //   ),
      title: MyText(
        text: name,
        align: TextAlign.start,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        paddingLeft: 0,
      ),
      subtitle: RichText(
        text: TextSpan(
          text: description ?? "",
          style: const TextStyle(
            color: AppColors.kLightGreyColor,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: " | To Redeem ${points ?? "0"} Points",
              style: const TextStyle(
                color: AppColors.kGreenColor,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      trailing: MyText(
        text: "\$$price",
        align: TextAlign.start,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        paddingLeft: 0,
      ),
    );
  }
}
