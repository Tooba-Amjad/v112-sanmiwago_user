import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';

class MyCachedNetworkImage extends StatelessWidget {
  const MyCachedNetworkImage({
    Key? key,
    required this.image,
    required this.height,
    required this.width,
    this.loaderHeight,
    this.loaderWidth,
    this.errorHeight,
    this.errorWidth,
  }) : super(key: key);

  final String image;
  final double height;
  final double width;
  final double? loaderHeight;
  final double? loaderWidth;
  final double? errorHeight;
  final double? errorWidth;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        height: 40,
        width: 40,
        imageUrl: image,
        progressIndicatorBuilder: (context, url, progress) {
          return MyCachedImageLoadingBuilder(
            height: loaderHeight ?? height,
            width: loaderWidth ?? width,
            loadingProgress: progress.progress ?? 0,
          );
        },
        errorWidget: (context, url, error) => MyImageErrorBuilder(
          height: errorHeight ?? height,
          width: errorWidth ?? width,
        ),
        fit: BoxFit.fill,
      ),
    );
  }
}
