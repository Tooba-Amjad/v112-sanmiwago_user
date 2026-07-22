import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/item_models/item_options_model.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';
import 'package:sanmiwago_user/views/widgets/textarea_field.dart';

class MySubscriptionItemDetailsPage extends StatelessWidget {
  final MenuItem item;
  final String offerId;
  final String offerRestaurantId;
  final bool isSignupOfferOrder;

  const MySubscriptionItemDetailsPage({
    super.key,
    required this.item,
    required this.offerId,
    required this.offerRestaurantId,
    this.isSignupOfferOrder = false,
    // required this.homeContext,
  });

  @override
  Widget build(BuildContext context) {
    log("item addons on subscription details page: ${item.addons}");

    // Assuming 'addons' is a flat list but includes 'category_name' for grouping
    Map<String, List<MenuItemAddon>> groupedAddons = {};

    // Group the addons by category_name
    for (var addon in item.addons) {
      groupedAddons.putIfAbsent(addon.categoryName, () => []).add(addon);
    }
    return PopScope(
      canPop: true,
      onPopInvoked: (canPop) {
        subscriptionsController.clearItemDetailsData();
      },
      child: Scaffold(
        backgroundColor: AppColors.kSkyLightDullColor,
        appBar: simpleAppBar(
          title: item.itemName,
          haveBackIcon: true,
          onBackPressed: () {
            Get.back();
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(15),
                children: [
                  /*//+ item name*/
                  MyText(
                    text: item.itemName,
                    fontSize: 18,
                    color: AppColors.kBlackColor,
                    fontWeight: FontWeight.bold,
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

                  const SizedBox(height: AppSizes.formsSizeBoxHeight),
                  // const SizedBox(height: AppSizes.formsSizeBoxHeight),

                  /* + Options heading + */
                  // Obx(() {
                  (item.offerOptions.isNotEmpty)
                      ? const MyText(
                          text: "Options",
                          color: AppColors.kBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          paddingBottom: 10,
                        )
                      : const SizedBox(),
                  // }
                  // return const SizedBox();
                  // }),

                  /* + Options + */
                  (item.offerOptions.isNotEmpty)
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.fieldsPadding,
                            vertical: AppSizes.fieldsPadding,
                          ),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 40,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: item.offerOptions.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, radioGridIndex) {
                              MenuItemOption option = item.offerOptions[radioGridIndex];
                              return InkWell(
                                onTap: () {
                                  subscriptionsController.selectOption(option.optionId);
                                },
                                child: Row(
                                  children: [
                                    //+ check box
                                    Expanded(
                                      flex: 2,
                                      child: Obx(() {
                                        return Container(
                                          margin: const EdgeInsets.only(top: 0),
                                          child: subscriptionsController.selectedOptionId.value == option.optionId
                                              ? const Icon(
                                                  Icons.check_circle_rounded,
                                                  size: 20,
                                                  color: AppColors.kBlackColor,
                                                )
                                              : const Icon(
                                                  Icons.circle_outlined,
                                                  size: 20,
                                                ),
                                        );
                                      }),
                                    ),

                                    //+ name of addon
                                    Expanded(
                                      flex: 15,
                                      child: MyText(
                                        text: option.optionName,
                                        color: AppColors.kBlackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),

                                    //+ price of addon
                                    // Expanded(
                                    //   flex: 3,
                                    //   child: MyText(
                                    //     text: "\$${option.price}",
                                    //     color: AppColors.kGreyColor,
                                    //     fontSize: 14,
                                    //     fontWeight: FontWeight.bold,
                                    //     paddingLeft: 10,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox(),

                  const SizedBox(height: AppSizes.formsSizeBoxHeight),

                  //+ Addons Heading
                  (item.addons.isNotEmpty)
                      ? const MyText(
                          text: "Addons Part",
                          color: AppColors.kBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          paddingBottom: 10,
                        )
                      : const SizedBox(),

                  //+ Addons Grid-view

                  (item.addons.isNotEmpty)
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.fieldsPadding,
                            vertical: AppSizes.fieldsPadding,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: groupedAddons.keys.length,
                            itemBuilder: (context, categoryIndex) {
                              String categoryName = groupedAddons.keys.elementAt(categoryIndex);
                              List<MenuItemAddon> addonsForCategory = groupedAddons[categoryName] ?? [];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category Title
                                  Container(
                                    width: double.infinity,
                                    // Makes the container stretch horizontally
                                    color: AppColors.kSkyLightColor,
                                    // Optional: Add background color to make it more prominent
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                                    margin: EdgeInsets.only(top: 10),
                                    child: MyText(
                                      text: categoryName,
                                      color: AppColors.kBlackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      align: TextAlign.left, // Align text to the left
                                    ),
                                  ),
                                  // Grid View for Addons under the current category
                                  GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 10,
                                      mainAxisExtent: 40,
                                      mainAxisSpacing: 5,
                                    ),
                                    itemCount: addonsForCategory.length,
                                    // itemCount:item.addons.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, checkboxGridIndex) {
                                      // MenuItemAddon addon =item.addons[checkboxGridIndex];
                                      MenuItemAddon addon = addonsForCategory[checkboxGridIndex];
                                      // log("seems like this is getting rebuild");
                                      return InkWell(
                                        onTap: () {
                                          subscriptionsController.selectAddon(addon.addonId, item);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            //+ check box
                                            Expanded(
                                              flex: 2,
                                              child: Obx(() {
                                                return Container(
                                                  margin: const EdgeInsets.only(top: 0, left: 0),
                                                  child: subscriptionsController.selectedAddonIds.contains(addon.addonId)
                                                      ? const Icon(
                                                          Icons.check_box,
                                                          size: 20,
                                                          color: AppColors.kBlackColor,
                                                        )
                                                      : const Icon(
                                                          Icons.check_box_outline_blank,
                                                          size: 20,
                                                        ),
                                                );
                                              }),
                                            ),

                                            //+ name of addon
                                            Expanded(
                                              flex: 15,
                                              child: MyText(
                                                text: addon.addonName,
                                                color: AppColors.kBlackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),

                                            /* + price of addon + */
                                            // Expanded(
                                            //   flex: 3,
                                            //   child: MyText(
                                            //     text: "\$ 0.00",
                                            //     // text: "\$${addon.price}",
                                            //     color: AppColors.kGreyColor,
                                            //     fontSize: 14,
                                            //     fontWeight: FontWeight.bold,
                                            //     paddingLeft: 10,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : const SizedBox(),

                  const SizedBox(height: AppSizes.formsSizeBoxHeight),

                  //++Special instructions
                  const MyText(
                    text: "Special instructions",
                    fontSize: 18,
                  ),
                  TextareaField(
                    controller: subscriptionsController.noteController,
                    hintText: 'Add a note',
                  ),

                  const SizedBox(height: AppSizes.formsSizeBoxHeight),
                ],
              ),
            ),
            //+ Button
            Obx(() {
              return MyButton(
                text: "Redeem Item",
                width: Get.width - 30,
                padding: 10,
                marginBottom: 10,
                color: apiController.isBuyingItemsFromSubscriptionOffer.value ? AppColors.kRedColor : AppColors.kGreenColor,
                onPressed: () {
                  subscriptionsController.placeSubscriptionOfferItemsOrder(
                    offerId: offerId,
                    offerRestaurantId: offerRestaurantId,
                    isSignupOfferOrder: isSignupOfferOrder,
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
