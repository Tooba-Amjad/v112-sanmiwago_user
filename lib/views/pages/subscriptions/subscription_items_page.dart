import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/subscription_models/subscription_offers_model.dart';
import 'package:sanmiwago_user/utils/custom_scroll_behavior.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/my_subscription_item_details_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/my_subscription_item_tile.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class SubscriptionItemsPage extends StatelessWidget {
  final String offerId;
  final String offerRestaurantId;

  const SubscriptionItemsPage({
    super.key,
    required this.offerId,
    required this.offerRestaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "Items",
        haveBackIcon: true,
        onBackPressed: () {
          Get.back();
        },
      ),
      body: Obx(() {
        return subscriptionsController.mySubscriptionsOfferProducts.isNotEmpty && !apiController.isLoadingSubscriptionOffers.value
            ? Column(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      /* + Making a better looking one item based View + */
                      child: ListView.separated(
                        padding: EdgeInsets.only(top: 20),
                        itemCount: subscriptionsController.mySubscriptionsOfferProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (subscriptionsController.mySubscriptionsOfferProducts[index].itemDetail.isEmpty) {
                            return const SizedBox();
                          }
                          MenuItem item = subscriptionsController.mySubscriptionsOfferProducts[index].itemDetail.first;

                          return Obx(() {
                            return MySubscriptionItemTile(
                              onTap: () async {
                                log("MySubscriptionItemTile clicked");
                                if (subscriptionsController.selectedOfferItem.value.itemId == item.itemId) {
                                  subscriptionsController.selectedOfferItem.value = MenuItem();
                                } else {
                                  subscriptionsController.selectedOfferItem.value = item;
                                }
                              },
                              isSelected: subscriptionsController.selectedOfferItem.value.itemId == item.itemId,
                              name: item.itemName,
                              description: "${item.itemDescription.capitalize}",
                              points: item.pointsToPurchase,
                              price: item.itemCost,
                              image: item.itemImageName,
                            );
                          });
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                    ),
                  ),
                  MyButton(
                    height: AppSizes.buttonHeight,
                    // width: 150,
                    text: "Redeem Item",
                    fontSize: 20,
                    color: subscriptionsController.selectedOfferItem.value.itemId.isEmpty ? AppColors.kLightGreyColor : AppColors.kGreenColor,
                    // color: apiController.isBuyingItemsFromSubscriptionOffer.value ? AppColors.kRedColor : AppColors.kGreenColor,
                    onPressed: () {
                      if (subscriptionsController.selectedOfferItem.value.itemId.isNotEmpty) {
                        /* + Navigate to item details page + */
                        // subscriptionsController.placeSubscriptionOfferItemsOrder(offerId: offerId);
                        subscriptionsController.clearItemDetailsData();

                        navigate(
                            type: PageType.to,
                            page: MySubscriptionItemDetailsPage(
                              item: subscriptionsController.selectedOfferItem.value,
                              offerId: offerId,
                              offerRestaurantId: offerRestaurantId,
                            ));
                      } else {
                        showMsg(msg: "Please select an item to redeem");
                      }
                    },
                  ),
                ],
              )
            : apiController.isLoadingSubscriptionOffers.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kLogoBasedColor,
                    ),
                  )
                : const Center(
                    child: MyText(
                      text: "No Items to show",
                      fontSize: 16,
                    ),
                  );
      }),
    );
  }
}

class OneItemBasedSubscriptionItemView extends StatelessWidget {
  const OneItemBasedSubscriptionItemView({
    super.key,
    required this.products,
  });

  final List<OfferProduct> products;

  @override
  Widget build(BuildContext context) {
    OfferProduct pr = products[0];
    if (pr.itemDetail.isEmpty) {
      return const SizedBox();
    }
    MenuItem item = pr.itemDetail.first;
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(15),
      children: [
        MyText(
          text: item.itemName,
          align: TextAlign.start,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          // paddingLeft: 20,
          paddingBottom: item.itemImageName.isNotEmpty ? 20 : 10,
        ),

        //+ item image
        item.itemImageName.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CachedNetworkImage(
                  height: 225,
                  width: double.infinity,
                  imageUrl: item.itemImageName,
                  progressIndicatorBuilder: (context, url, progress) {
                    return MyCachedImageLoadingBuilder(
                      height: 225,
                      width: Get.width,
                      loadingProgress: progress.progress ?? 0,
                    );
                  },
                  errorWidget: (context, url, error) => MyImageErrorBuilder(
                    height: 225,
                    width: Get.width,
                  ),
                  fit: BoxFit.contain,
                ),
              )
            : const SizedBox(),
        //+ item description
        MyText(
          text: item.itemDescription,
          fontSize: 16,
          color: AppColors.kBlackColor,
          paddingTop: item.itemImageName.isNotEmpty ? 20 : 0,
          paddingBottom: 20,
        ),
      ],
    );
  }
}
