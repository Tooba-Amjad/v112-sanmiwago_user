import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_options_model.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';
import 'package:sanmiwago_user/views/widgets/textarea_field.dart';

class ItemDetailsPage extends StatelessWidget {
  // final BuildContext homeContext;
  const ItemDetailsPage({
    Key? key,
    // required this.homeContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSkyLightDullColor,
      appBar: simpleAppBar(
        title: catItemController.selectedItem.value.itemName,
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
                Obx(() {
                  return MyText(
                    text: catItemController.selectedItem.value.itemName,
                    fontSize: 18,
                    color: AppColors.kBlackColor,
                    fontWeight: FontWeight.bold,
                    paddingBottom: catItemController.selectedItem.value.itemImageName.isNotEmpty ? 20 : 10,
                  );
                }),

                //+ item image
                catItemController.selectedItem.value.itemImageName.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CachedNetworkImage(
                          height: 225,
                          width: double.infinity,
                          imageUrl: catItemController.selectedItem.value.itemImageName,
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
                Obx(() {
                  return MyText(
                    text: catItemController.selectedItem.value.itemDescription,
                    fontSize: 16,
                    color: AppColors.kBlackColor,
                    paddingTop: catItemController.selectedItem.value.itemImageName.isNotEmpty ? 20 : 0,
                    paddingBottom: 20,
                  );
                }),

                //+Increase decrease Button
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                catItemController.decreaseItemCount();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.grey.withOpacity(.26),
                                ),
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.grey[800],
                                  size: 19,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 17),
                              child: Obx(() {
                                return MyText(
                                  text: "${catItemController.itemCount.value}",
                                  color: AppColors.kBlackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                );
                              }),
                            ),
                            InkWell(
                              onTap: () {
                                catItemController.increaseItemCount();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.grey.withOpacity(.26),
                                ),
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey[800],
                                  size: 19,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.formsSizeBoxHeight),
                // const SizedBox(height: AppSizes.formsSizeBoxHeight),

                //+ Options heading
                Obx(() {
                  if (catItemController.selectedItem.value.options.isNotEmpty || apiController.isLoadingItemOptions.value) {
                    return const MyText(
                      text: "Options",
                      color: AppColors.kBlackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      paddingBottom: 10,
                    );
                  }
                  return const SizedBox();
                }),

                //+ Options
                Obx(() {
                  if (catItemController.selectedItem.value.options.isNotEmpty) {
                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.fieldsPadding,
                        vertical: AppSizes.fieldsPadding,
                      ),
                      child: Obx(() {
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 40,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: catItemController.selectedItem.value.options.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, radioGridIndex) {
                            MenuItemOption option = catItemController.selectedItem.value.options[radioGridIndex];
                            return InkWell(
                              onTap: () {
                                catItemController.selectOption(option.optionId);
                              },
                              child: Row(
                                children: [
                                  //+ check box
                                  Expanded(
                                    flex: 2,
                                    child: Obx(() {
                                      return Container(
                                        margin: const EdgeInsets.only(top: 0),
                                        child: catItemController.selectedOptionId.value == option.optionId
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
                                    flex: 14,
                                    child: MyText(
                                      text: option.optionName,
                                      color: AppColors.kBlackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),

                                  //+ price of addon
                                  Expanded(
                                    flex: 4,
                                    child: MyText(
                                      text: "\$${option.price}",
                                      color: AppColors.kGreyColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      paddingLeft: 10,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    );
                  } else if (apiController.isLoadingItemOptions.value) {
                    return Center(
                      child: showInlineLoading(),
                    );
                  }
                  return const SizedBox();
                }),

                const SizedBox(height: AppSizes.formsSizeBoxHeight),

                //+ Addons Heading
                Obx(() {
                  if (catItemController.selectedItem.value.addons.isNotEmpty || apiController.isLoadingItemAddons.value) {
                    return const MyText(
                      text: "Addons",
                      color: AppColors.kBlackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      paddingBottom: 10,
                    );
                  }
                  return const SizedBox();
                }),

                //+ Addons Grid-view
                Obx(() {
                  if (catItemController.selectedItem.value.addons.isNotEmpty) {
                    // Assuming 'addons' is a flat list but includes 'category_name' for grouping
                    Map<String, List<MenuItemAddon>> groupedAddons = {};

                    // Group the addons by category_name
                    for (var addon in catItemController.selectedItem.value.addons) {
                      groupedAddons.putIfAbsent(addon.categoryName, () => []).add(addon);
                    }

                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.fieldsPadding, vertical: AppSizes.fieldsPadding),
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
                                // itemCount: catItemController.selectedItem.value.addons.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, checkboxGridIndex) {
                                  // MenuItemAddon addon = catItemController.selectedItem.value.addons[checkboxGridIndex];
                                  MenuItemAddon addon = addonsForCategory[checkboxGridIndex];
                                  // log("seems like this is getting rebuild");
                                  return InkWell(
                                    onTap: () {
                                      catItemController.selectAddon(addon.addonId);
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
                                              child: catItemController.selectedAddonIds.contains(addon.addonId)
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
                                          flex: 14,
                                          child: MyText(
                                            text: addon.addonName,
                                            color: AppColors.kBlackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),

                                        //+ price of addon
                                        Expanded(
                                          flex: 4,
                                          child: MyText(
                                            text: "\$${addon.price}",
                                            color: AppColors.kGreyColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            paddingLeft: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else if (apiController.isLoadingItemAddons.value) {
                    return Center(
                      child: showInlineLoading(),
                    );
                  }
                  return const SizedBox();
                }),

                const SizedBox(height: AppSizes.formsSizeBoxHeight),

                //++Special instructions
                const MyText(
                  text: "Special instructions",
                  fontSize: 18,
                ),
                TextareaField(
                  controller: catItemController.noteController,
                  hintText: 'Add a note',
                ),

                const SizedBox(height: AppSizes.formsSizeBoxHeight),
              ],
            ),
          ),
          //+ Button
          Obx(() {
            return MyButton(
              text: "Add to Cart - \$${catItemController.itemTotal.toStringAsFixed(2)}",
              width: Get.width - 30,
              padding: 10,
              marginBottom: 10,
              color: authController.loading.value ? AppColors.kButtonGreenColor : AppColors.kButtonRedColor,
              onPressed: () {
                // orderController.addToCart(homeContext);
                orderController.modifiedAddToCart(onSuccess: () {
                  showScaffoldMsg(context: context, msg: "Item successfully added to cart", isSuccess: true);
                });
                Get.back();
              },
            );
          }),
        ],
      ),
    );
  }
}
