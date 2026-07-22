import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/fields_container.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class GraphicalNode extends StatelessWidget {
  const GraphicalNode({
    super.key,
    required this.name,
    this.isParent = false,
  });

  final String name;
  final bool isParent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.kLogoBasedColor.withOpacity(0.3),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(
            color: isParent ? AppColors.kLogoBasedColor : AppColors.kGreyColor,
            width: 2,
          )),
      child: Row(
        children: [
          Expanded(
            child: MyText(
              text: name,
              color: AppColors.kBlackColor,
              align: TextAlign.center,
              height: 1,
              // paddingTop: 10,
              fontSize: 16,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
