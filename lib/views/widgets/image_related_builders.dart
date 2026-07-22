import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';

class MyImageLoadingBuilder extends StatelessWidget {
  const MyImageLoadingBuilder({
    super.key,
    required this.height,
    required this.width,
    this.loadingProgress,
    this.color,
  });

  final double height;
  final double width;
  final ImageChunkEvent? loadingProgress;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: CircularProgressIndicator(
          color: color ?? AppColors.kLogoBasedColor,
          value: loadingProgress?.expectedTotalBytes != null ? (loadingProgress?.cumulativeBytesLoaded ?? 0) / (loadingProgress?.expectedTotalBytes ?? 1) : null,
        ),
      ),
    );
  }
}

class MyCachedImageLoadingBuilder extends StatelessWidget {
  const MyCachedImageLoadingBuilder({
    super.key,
    required this.height,
    required this.width,
    required this.loadingProgress,
  });

  final double height;
  final double width;
  final double loadingProgress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.kLogoBasedColor,
          value: loadingProgress,
        ),
      ),
    );
  }
}

class MyImageErrorBuilder extends StatelessWidget {
  const MyImageErrorBuilder({
    super.key,
    required this.height,
    required this.width,
    this.widget,
  });

  final double height;
  final double width;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return widget ??
        SizedBox(
          height: height,
          width: width,
          child: const Icon(
            Icons.image_not_supported_outlined,
          ),
        );
  }
}
