import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/order_view_model.dart';
import 'package:sanmiwago_user/models/user_model/user_promotions_model.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/my_cached_network_image.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class UserPromotionsItemWidget extends StatelessWidget {
  const UserPromotionsItemWidget({
    Key? key,
    required this.index,
    required this.promoItem,
  }) : super(key: key);

  final int index;
  final UserPromotion promoItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        // color: AppColors.kSkyLightDullColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.kSkyLightDullColor, width: 2),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyText(
                      text: "Message: ",
                      align: TextAlign.left,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
          dividerCommon(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child:  MyText(
                  text: promoItem.description.capitalizeItsFirst(),
                  align: TextAlign.left,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  paddingTop: 5,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
