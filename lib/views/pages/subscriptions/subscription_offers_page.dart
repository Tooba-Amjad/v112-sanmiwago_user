import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/item_models/item_options_model.dart';
import 'package:sanmiwago_user/models/subscription_models/subscription_offers_model.dart';
import 'package:sanmiwago_user/utils/custom_scroll_behavior.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/my_subscription_item_details_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/my_subscription_item_tile.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/my_subscriptions_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/subscription_payment_form.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_listtile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class SubscriptionOffersPage extends StatefulWidget {
  final bool showBack;

  const SubscriptionOffersPage({super.key, this.showBack = true});

  @override
  State<SubscriptionOffersPage> createState() => _SubscriptionOffersPageState();
}

class _SubscriptionOffersPageState extends State<SubscriptionOffersPage> {
  Timer? _timer;

  PageController pageController = PageController(initialPage: 0);
  RxInt currentPageIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    currentPageIndex.value = 0;
    subscriptionsController.getSubscriptionOffers();

    // Listen to changes in subscription offers
    ever(subscriptionsController.subscriptionOffers, (_) {
      if (subscriptionsController.subscriptionOffers.isNotEmpty) {
        // Reset currentPageIndex and PageController when subscription offers are updated.
        WidgetsBinding.instance.addPostFrameCallback((time) {
          currentPageIndex.value = 0;
          if (pageController.hasClients) {
            pageController.jumpToPage(0);
          }
        });
      }
    });

    // subscriptionsController.pageController = PageController(initialPage: 0);
    /*
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (subscriptionsController.currentIndexPage < 3) {
        subscriptionsController.currentIndexPage++;
      } else {
        subscriptionsController.currentIndexPage = 0;
      }

      subscriptionsController.pageController.animateToPage(
        subscriptionsController.currentIndexPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
    */
  }

  @override
  void dispose() {
    // subscriptionsController.pageController.dispose();
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  updateIndex(int index) {
    currentPageIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      updateIndex(0);
      try {
        pageController.jumpToPage(0);
      } catch (e) {
        log("error in moving to index 0 page");
      }
    });
    return Scaffold(
      appBar: simpleAppBar(
        title: "Offers", //"Subscriptions",
        haveBackIcon: widget.showBack,
        haveDrawerIcon: true,
        onBackPressed: () {
          Get.back();
        },
      ),
      body: Obx(() {
        return subscriptionsController.subscriptionOffers.isNotEmpty && !apiController.isLoadingSubscriptionOffers.value
            ? Stack(
                children: [
                  SizedBox(
                    height: Get.height,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: subscriptionsController.subscriptionOffers.length,
                      onPageChanged: (int index) {
                        updateIndex(index);
                        final SubscriptionOffer offer = subscriptionsController.subscriptionOffers[index];

                        if (offer.planType.toLowerCase() == "free" || offer.isSubscribed) {
                          WidgetsBinding.instance.addPostFrameCallback((time) {
                            subscriptionsController.getSubscriptionOfferItems(offer.offerId, callGetSubOffers: false);
                          });
                        }
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: Get.height,
                          child: SubscriptionDetailsWidget(index: index),
                        );
                      },
                    ),
                  ),
                  /* + Right arrow button + */
                  Positioned(
                    bottom: (Get.height / 2) - 80,
                    right: 0,
                    // left: 0,
                    child: Obx(() {
                      return currentPageIndex.value != (subscriptionsController.subscriptionOffers.length - 1)
                          ? GestureDetector(
                              onTap: () {
                                pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.linear);
                              },
                              child: Container(
                                height: 52,
                                width: 52,
                                decoration: const BoxDecoration(
                                  color: AppColors.kTertiaryColor,
                                  // color: AppColors.kPrimaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.kBlackColor,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox();
                    }),
                  ),

                  /* + Left arrow button + */
                  Positioned(
                    bottom: (Get.height / 2) - 80,
                    // right: 0,
                    left: 0,
                    child: Obx(() {
                      return currentPageIndex.value != 0
                          ? GestureDetector(
                              onTap: () {
                                pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.linear);
                              },
                              child: Container(
                                height: 52,
                                width: 52,
                                decoration: const BoxDecoration(
                                  color: AppColors.kTertiaryColor,
                                  // color: AppColors.kPrimaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: AppColors.kBlackColor,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox();
                    }),
                  ),
                ],
              )
            : SizedBox(
                height: Get.height,
                child: apiController.isLoadingSubscriptionOffers.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.kLogoBasedColor,
                        ),
                      )
                    : const Center(
                        child: MyText(
                          text: "No offers to show right now",
                          fontSize: 16,
                        ),
                      ),
              );
      }),
    );
  }
}

class SubscriptionDetailsWidget extends StatelessWidget {
  final int index;

  const SubscriptionDetailsWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final ExpandableController termsExpandController = ExpandableController(initialExpanded: true);
    final SubscriptionOffer offer = subscriptionsController.subscriptionOffers[index];
    log("offer.offerImageName: ${offer.offerImageName}");

    int totalAddonsLength = offer.offerProducts.expand((product) => product.itemDetail).expand((detail) => detail.addons).length;
    int totalOptionsLength = offer.offerProducts.expand((product) => product.itemDetail).expand((detail) => detail.offerOptions).length;

    log("totalOptionsLength: $totalOptionsLength");

    int totalCategoriesLength = offer.offerProducts
        .expand((product) => product.itemDetail)
        .expand((detail) => detail.addons)
        .map((addon) => addon.categoryName)
        .toSet() // This removes duplicates by converting to a Set
        .length;

    // (offer.isSubscribed && offer.planType.toLowerCase() != "free")
    /* + moved to the the onPageChanged callback + */
    // if (offer.planType.toLowerCase() == "free" || offer.isSubscribed) {
    //   WidgetsBinding.instance.addPostFrameCallback((time) {
    //     subscriptionsController.getSubscriptionOfferItems(offer.offerId, callGetSubOffers: false);
    //   });
    // }

    ScrollController sc = ScrollController();
    return Scaffold(
      key: ValueKey(offer.offerId),
      backgroundColor: AppColors.kSkyLightDullColor,
      /* + will put an obx here or maybe up there to update the values in these fields and show a loading in the meantime, to avoid any weird jank type feeling if there is any + */
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 10,
        controller: sc,
        radius: const Radius.circular(10),
        interactive: true,
        trackVisibility: true,
        child: MyFormPage(
          pageTopPadding: Get.height * 0.03,
          pageBottomPadding: Get.height * 0.07,
          showBottomPadding: true,
          sc: sc,
          children: [
            /* + Subscription image + */
            offer.offerImageName.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        height: 200,
                        width: Get.width,
                        imageUrl: offer.offerImageName,
                        // imageUrl: "https://picsum.photos/seed/picsum/200/300",
                        progressIndicatorBuilder: (context, url, progress) {
                          return MyCachedImageLoadingBuilder(
                            height: 200,
                            width: Get.width,
                            loadingProgress: progress.progress ?? 0,
                          );
                        },
                        errorWidget: (context, url, error) => MyImageErrorBuilder(
                          height: 200,
                          width: Get.width,
                        ),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            /* + Title & Desc container + */
            Container(
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.kLogoBasedColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyText(
                    text: offer.offerName.capitalizeFirst,
                    align: TextAlign.center,
                    color: AppColors.kWhiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    paddingTop: 20,
                    paddingBottom: 10,
                    paddingLeft: 10,
                    paddingRight: 10,
                  ),
                  offer.offerSubscriptions.isNotEmpty
                      ? MyText(
                          text: offer.offerSubscriptions.capitalizeFirst,
                          align: TextAlign.center,
                          color: AppColors.kSkyLightColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 22,
                          // paddingTop: 5,
                          paddingBottom: 20,
                          paddingLeft: 30,
                          paddingRight: 30,
                        )
                      : SizedBox(),
                  // offer.planType.toLowerCase() == "free"
                  //     ?
                  Container(
                    // width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Icon(
                          Icons.info_outline,
                          color: Colors.green[700],
                          size: 18,
                        ),
                        MyText(
                          color: Colors.green[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          maxLines: 3,
                          text: "This is for in-store pickup only!",
                          align: TextAlign.left,
                          // paddingTop: 10,
                          // paddingBottom: 10,
                          paddingLeft: 6,
                          // paddingRight: 10,
                        ),
                      ],
                    ),
                  ),
                  //    : SizedBox(),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            /* + Perks or Items container + */
            Container(
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.kWhiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   height: 50,
                  //   // width: Get.width,
                  //   decoration: const BoxDecoration(
                  //     color: AppColors.kLogoBasedColor,
                  //     borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                  //   ),
                  //   child: Center(
                  //     child: const MyText(
                  //       text: "Perks/Items",
                  //       align: TextAlign.center,
                  //       color: AppColors.kWhiteColor,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 22,
                  //       // paddingTop: 5,
                  //       // paddingBottom: 20,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: AppSizes.formsSizeBoxHeight),
                  // const MyText(
                  //   text: "You will be able to enjoy the following Item(s) as per the given Terms & Conditions.",
                  //   align: TextAlign.center,
                  //   color: AppColors.kLightGreyColor,
                  //   fontWeight: FontWeight.normal,
                  //   fontSize: 18,
                  //   paddingTop: 5,
                  //   paddingBottom: 20,
                  //   paddingLeft: 15,
                  //   paddingRight: 15,
                  // ),
                  // const SizedBox(height: AppSizes.formsSizeBoxHeight),
                  // + Name Perks
                  // MyText(
                  //   text: "Perks of ${offer.offerName.capitalizeFirst}",
                  //   align: TextAlign.center,
                  //   color: AppColors.kBlackColor,
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 18,
                  //   paddingTop: 5,
                  //   paddingBottom: 20,
                  // ),

                  /* + Products + */
                  offer.offerProducts.isNotEmpty
                      ? offer.planType.toLowerCase() != "free" && offer.offerProducts.isNotEmpty && !offer.isSubscribed
                          ? SizedBox(
                              height: (offer.offerProducts.length * 65) + (totalCategoriesLength * 30) + (totalAddonsLength * 40) + (totalOptionsLength * 70),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: offer.offerProducts.length,
                                itemBuilder: (BuildContext context, int ind) {
                                  if (offer.offerProducts[ind].itemDetail.isEmpty) {
                                    return const SizedBox();
                                  }
                                  MenuItem item = offer.offerProducts[ind].itemDetail[0];

                                  Map<String, List<MenuItemAddon>> groupedAddons = {};

                                  // Group the addons by category_name
                                  for (var addon in item.addons) {
                                    groupedAddons.putIfAbsent(addon.categoryName, () => []).add(addon);
                                  }

                                  return MyListTile(
                                    title: MyText(
                                      text: item.itemName,
                                      align: TextAlign.left,
                                      color: AppColors.kBlackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      // paddingTop: 5,
                                      // paddingBottom: 20,
                                    ),
                                    subtitle: item.addons.isNotEmpty || item.offerOptions.isNotEmpty
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              /* + options text + */
                                              item.offerOptions.isNotEmpty
                                                  ? MyText(
                                                      text: "Options:",
                                                      align: TextAlign.left,
                                                      color: AppColors.kGreyColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      paddingLeft: 5,
                                                      // paddingTop: 5,
                                                      // paddingBottom: 5,
                                                    )
                                                  : const SizedBox(),

                                              /* + Options list + */
                                              Container(
                                                color: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                child: GridView.builder(
                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 1,
                                                    crossAxisSpacing: 10,
                                                    mainAxisExtent: 30,
                                                    mainAxisSpacing: 0,
                                                  ),
                                                  itemCount: item.offerOptions.length,
                                                  // itemCount: catItemController.selectedItem.value.addons.length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  physics: const BouncingScrollPhysics(),
                                                  itemBuilder: (context, checkboxGridIndex) {
                                                    // MenuItemAddon addon = catItemController.selectedItem.value.addons[checkboxGridIndex];
                                                    MenuItemOption option = item.offerOptions[checkboxGridIndex];
                                                    // log("seems like this is getting rebuild");
                                                    log("OPTIONS >>>>>>>>>>>>>>>>>>>>>>>>>>");
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(width: 10),
                                                        const Icon(
                                                          Icons.circle,
                                                          size: 10,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(width: 9),
                                                        //+ name of addon
                                                        Expanded(
                                                          child: MyText(
                                                            text: option.optionName,
                                                            color: AppColors.kGreyColor,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            paddingLeft: 10,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),

                                                        //+ price of addon
                                                        // Expanded(
                                                        //   flex: 3,
                                                        //   child: MyText(
                                                        //     text: "\$${addon.price}",
                                                        //     color: AppColors.kGreyColor,
                                                        //     fontSize: 14,
                                                        //     fontWeight: FontWeight.bold,
                                                        //     paddingLeft: 10,
                                                        //   ),
                                                        // ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                // ListView.builder(
                                                //   shrinkWrap: true,
                                                //   physics: const BouncingScrollPhysics(),
                                                //   itemCount: item.offerOptions.length,
                                                //   itemBuilder: (context, categoryIndex) {
                                                //     // String categoryName = groupedAddons.keys.elementAt(categoryIndex);
                                                //     // List<MenuItemAddon> addonsForCategory = groupedAddons[categoryName] ?? [];
                                                //     return Column(
                                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                                //       children: [
                                                //         // Category Title
                                                //         // Container(
                                                //         //   width: double.infinity,
                                                //         //   // Makes the container stretch horizontally
                                                //         //   color: AppColors.kSkyLightColor,
                                                //         //   // Optional: Add background color to make it more prominent
                                                //         //   padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16),
                                                //         //   margin: EdgeInsets.only(top: 5),
                                                //         //   child: MyText(
                                                //         //     text: categoryName,
                                                //         //     color: AppColors.kGreyColor,
                                                //         //     fontWeight: FontWeight.bold,
                                                //         //     fontSize: 15,
                                                //         //     align: TextAlign.left, // Align text to the left
                                                //         //   ),
                                                //         // ),
                                                //         // Grid View for Addons under the current category
                                                //       ],
                                                //     );
                                                //   },
                                                // ),
                                              ),
                                              SizedBox(height: item.offerOptions.isNotEmpty && item.addons.isNotEmpty ? 10 : 0),
                                              (item.addons.isNotEmpty)
                                                  ? MyText(
                                                      text: "Addons:",
                                                      align: TextAlign.left,
                                                      color: AppColors.kGreyColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      paddingLeft: 5,
                                                      // paddingTop: 5,
                                                      // paddingBottom: 5,
                                                    )
                                                  : const SizedBox(),
                                              Container(
                                                color: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
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
                                                          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16),
                                                          margin: EdgeInsets.only(top: 5),
                                                          child: MyText(
                                                            text: categoryName,
                                                            color: AppColors.kGreyColor,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15,
                                                            align: TextAlign.left, // Align text to the left
                                                          ),
                                                        ),
                                                        // Grid View for Addons under the current category
                                                        GridView.builder(
                                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 1,
                                                            crossAxisSpacing: 10,
                                                            mainAxisExtent: 30,
                                                            mainAxisSpacing: 0,
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
                                                            return Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                const SizedBox(width: 10),
                                                                const Icon(
                                                                  Icons.circle,
                                                                  size: 10,
                                                                  color: Colors.grey,
                                                                ),
                                                                const SizedBox(width: 9),
                                                                //+ name of addon
                                                                Expanded(
                                                                  child: MyText(
                                                                    text: addon.addonName,
                                                                    color: AppColors.kGreyColor,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 14,
                                                                    paddingLeft: 10,
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),

                                                                //+ price of addon
                                                                // Expanded(
                                                                //   flex: 3,
                                                                //   child: MyText(
                                                                //     text: "\$${addon.price}",
                                                                //     color: AppColors.kGreyColor,
                                                                //     fontSize: 14,
                                                                //     fontWeight: FontWeight.bold,
                                                                //     paddingLeft: 10,
                                                                //   ),
                                                                // ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                    // trailing: MyText(
                                    //   text: "\$ ${item.itemCost}",
                                    //   align: TextAlign.center,
                                    //   color: AppColors.kBlackColor,
                                    //   fontWeight: FontWeight.normal,
                                    //   fontSize: 16,
                                    //   // paddingTop: 5,
                                    //   // paddingBottom: 20,
                                    // ),
                                  );
                                },
                              ),
                            )
                          /* + free item selection widget + */
                          : SizedBox(
                              height: (offer.offerProducts.length * 85),
                              child: SelectableItemsWidget(),
                            )
                      : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            dividerCommon(height: 5, thickness: 5, color: AppColors.kGreenColor),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            /* + Price container + */
            offer.planType.toLowerCase() != "free" && !offer.isSubscribed
                ? Container(
                    margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                    padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColors.kLogoBasedColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const MyText(
                              text: "Plan: ",
                              align: TextAlign.center,
                              color: AppColors.kWhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              // paddingTop: 20,
                              // paddingBottom: 5,
                            ),
                            MyText(
                              text: offer.planType.toLowerCase() != "free"
                                  ? getOfferDuration(offer.offerDurations.toLowerCase()).capitalizeFirst
                                  : offer.planType.capitalizeFirst,
                              align: TextAlign.center,
                              color: AppColors.kWhiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              paddingLeft: 5,
                              // paddingTop: 5,
                              // paddingBottom: 20,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const MyText(
                              text: "Price: ",
                              align: TextAlign.center,
                              color: AppColors.kWhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              // paddingTop: 20,
                              // paddingBottom: 5,
                            ),
                            MyText(
                              text: "\$${offer.offerCost}",
                              align: TextAlign.center,
                              color: AppColors.kWhiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              paddingLeft: 5,
                              // paddingTop: 5,
                              // paddingBottom: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            offer.planType.toLowerCase() != "free" ? const SizedBox(height: AppSizes.formsSizeBoxHeight) : const SizedBox(),

            offer.planType.toLowerCase() == "free" || offer.isSubscribed
                //+Order Now Button
                ? Center(
                    child: (offer.isSubscribed && offer.planType.toLowerCase() != "free") || (offer.planType.toLowerCase() == "free" && !offer.isSubscribed)
                        ? MyButton(
                            height: AppSizes.buttonHeight,
                            width: 220,
                            text: (offer.planType.toLowerCase() != "free" && offer.isSubscribed) || (offer.planType.toLowerCase() == "free" && !offer.isSubscribed)
                                ? "Redeem Item"
                                : "Redeemed",
                            //"Order Now",
                            fontSize: 20,
                            color: (offer.planType.toLowerCase() != "free" && offer.isSubscribed) || (offer.planType.toLowerCase() == "free" && !offer.isSubscribed)
                                ? AppColors.kRedColor
                                : AppColors.kLightGreyColor,
                            onPressed: () {
                              // subscriptionsController.getSubscriptionOfferItems(offer.offerId);
                              if ((offer.planType.toLowerCase() != "free" && offer.isSubscribed) || (offer.planType.toLowerCase() == "free" && !offer.isSubscribed)) {
                                if (authController.userData.value.id.isNotEmpty) {
                                  if (subscriptionsController.selectedOfferItem.value.itemId.isNotEmpty) {
                                    /* + Navigate to item details page + */
                                    // subscriptionsController.placeSubscriptionOfferItemsOrder(offerId: offerId);
                                    subscriptionsController.clearItemDetailsData();

                                    navigate(
                                      type: PageType.to,
                                      page: MySubscriptionItemDetailsPage(
                                        item: subscriptionsController.selectedOfferItem.value,
                                        offerId: offer.offerId,
                                        offerRestaurantId: offer.restaurantId,
                                      ),
                                    );
                                  } else {
                                    showMsg(msg: "Please select an item to redeem");
                                  }
                                  // navigate(
                                  //   type: PageType.to,
                                  //   page: SubscriptionItemsPage(
                                  //     offerId: offer.offerId,
                                  //     offerRestaurantId: offer.restaurantId,
                                  //   ),
                                  // );
                                } else {
                                  navigate(
                                    type: PageType.to,
                                    page: LoginPage(
                                      showGuestButton: false,
                                      allowBackIcon: true,
                                    ),
                                  );
                                  showMsg(
                                    msg: "Free offer is only available for our new members. If you are already a member and haven't used your free offer, "
                                        "please sign-in and if you are not a member yet, please sign-up",
                                    time: Duration(seconds: 5),
                                  );
                                }
                              } else {
                                showMsg(msg: "You have already availed this offer");
                              }
                            },
                          )
                        : Container(
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xfffff3cd),
                              borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.brown[700],
                                  size: 18,
                                ),
                                MyText(
                                  color: Colors.brown[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  maxLines: 3,
                                  text: "Already redeemed it!",
                                  align: TextAlign.left,
                                  // paddingTop: 10,
                                  // paddingBottom: 10,
                                  paddingLeft: 6,
                                  // paddingRight: 10,
                                ),
                              ],
                            ),
                          ),
                  )
                : Center(
                    child: MyButton(
                      height: AppSizes.buttonHeight,
                      width: 220,
                      text: !offer.isSubscribed ? "Subscribe Now" : "Subscribed",
                      fontSize: 20,
                      color: !offer.isSubscribed ? AppColors.kRedColor : AppColors.kGreenColor,
                      onPressed: () {
                        if (!offer.isSubscribed) {
                          if (authController.userData.value.id.isNotEmpty) {
                            subscriptionsController.setSelectedOfferData(offer);
                            navigate(type: PageType.to, page: SubscriptionPaymentForm());
                          } else {
                            navigate(
                              type: PageType.to,
                              page: LoginPage(
                                showGuestButton: false,
                                allowBackIcon: true,
                              ),
                            );
                            showMsg(
                              msg: "Subscriptions are only available for our members. If you are already a member, "
                                  "please sign-in and if you are not a member yet, please sign-up",
                              time: Duration(seconds: 5),
                            );
                          }
                        } else {
                          navigate(type: PageType.to, page: const MySubscriptionsPage());
                        }
                      },
                    ),
                  ),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            dividerCommon(height: 5, thickness: 5, color: AppColors.kGreenColor),
            const SizedBox(height: AppSizes.formsSizeBoxHeight * 2),

            /* + Terms & Conditions Expandable + */
            offer.offerConditions.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(),
                    child: ExpandablePanel(
                      controller: termsExpandController,
                      theme: const ExpandableThemeData(
                        iconColor: AppColors.kBlackColor,
                        iconPadding: EdgeInsets.zero,
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: const Row(
                        children: [
                          Expanded(
                            child: MyText(
                              text: "Terms & Conditions",
                              // text: "apiController selectedOrder Data Data",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              paddingLeft: 5,
                              paddingBottom: 10,
                            ),
                          ),
                        ],
                      ),
                      collapsed: const SizedBox(),
                      expanded: MyText(
                        text: offer.offerConditions,
                        // text: "apiController selectedOrder Data Data",
                        fontSize: 16,
                        color: AppColors.kGreyColor,
                        fontWeight: FontWeight.normal,
                        overflow: TextOverflow.ellipsis,
                        // maxLines: 2,
                        paddingLeft: 5,
                        paddingBottom: 10,
                      ),
                      builder: (_, collapsed, expanded) {
                        return Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(
                            crossFadePoint: 0,
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class SelectableItemsWidget extends StatelessWidget {
  const SelectableItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    log("this being called : ${subscriptionsController.mySubscriptionsOfferProducts.length}");
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      /* + Making a better looking one item based View + */
      child: Obx(() {
        if (subscriptionsController.mySubscriptionsOfferProducts.isEmpty && apiController.isLoadingSubscriptionOffersForAllRestaurants.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.kLogoBasedColor,
            ),
          );
        }
        // else if (subscriptionsController.mySubscriptionsOfferProducts.isEmpty && !apiController.isLoadingSubscriptionOffersForAllRestaurants.value) {
        //   return const Center(
        //     child: MyText(
        //       text: "No items to show right now",
        //       fontSize: 16,
        //     ),
        //   );
        // }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 20),
          itemCount: subscriptionsController.mySubscriptionsOfferProducts.length,
          itemBuilder: (BuildContext context, int index) {
            if (subscriptionsController.mySubscriptionsOfferProducts[index].itemDetail.isEmpty) {
              return const SizedBox();
            }
            MenuItem item = subscriptionsController.mySubscriptionsOfferProducts[index].itemDetail.first;

            return Obx(() {
              return MySubscriptionItemTile(
                showImage: false,
                fontSize: 18,
                textLeftPadding: 0,
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
        );
      }),
    );
  }
}
