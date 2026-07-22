import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/app_styles.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/constants/my_logger.dart';
import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/item_models/item_options_model.dart';
import 'package:sanmiwago_user/models/restaurant_model.dart';
import 'package:sanmiwago_user/models/signup_referral_offer_models/signup_referral_offer_model.dart';
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
import 'package:sanmiwago_user/views/widgets/my_dropdown_text_field.dart';
import 'package:sanmiwago_user/views/widgets/my_listtile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class SignupReferralOfferDetailsPage extends StatelessWidget {
  final bool showBack;
  final SignupReferralOffer signupOffer;
  final SubscriptionOffer prevOffer;

  const SignupReferralOfferDetailsPage({
    super.key,
    required this.signupOffer,
    required this.prevOffer,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final ExpandableController termsExpandController = ExpandableController(initialExpanded: true);
    final SubscriptionOffer offer = prevOffer;
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

    if (offer.planType.toLowerCase() == "free") {
      WidgetsBinding.instance.addPostFrameCallback((time) {
        subscriptionsController.getSubscriptionOfferItems(offer.offerId, callGetSubOffers: false);
      });
    }

    ScrollController sc = ScrollController();

    Restaurant? selectedRestaurant;

    return Scaffold(
      appBar: simpleAppBar(
        title: "Referral Offers", //"Subscriptions",
        haveBackIcon: showBack,
        haveDrawerIcon: true,
        onBackPressed: () {
          Get.back();
        },
      ),
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
                  MyRestaurantsDropDown(
                    isForEdit: true,
                    listItem: restaurantController.restaurants,
                    hintText: "Select Restaurant",
                    onChange: (value) {
                      infoLog("selected restaurant: ${value?.branchName}");
                      selectedRestaurant = value;
                    },
                    validator: (value) {
                      if (selectedRestaurant == null) {
                        return "Please select a restaurant to pick this up from";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppSizes.formsSizeBoxHeight),

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
                      ? offer.planType.toLowerCase() != "free"
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
                              child: SignupReferralOfferSelectableItemsWidget(products: offer.offerProducts),
                            )
                      : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            dividerCommon(height: 5, thickness: 5, color: AppColors.kGreenColor),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            // offer.planType.toLowerCase() != "free" ? const SizedBox(height: AppSizes.formsSizeBoxHeight) : const SizedBox(),

            /* + Redeem Item +  */
            Center(
              child: !offer.isSubscribed && signupOffer.count != "0"
                  ? MyButton(
                      height: AppSizes.buttonHeight,
                      width: 220,
                      text: "Redeem Item",
                      //"Order Now",
                      fontSize: 20,
                      color: !offer.isSubscribed ? AppColors.kRedColor : AppColors.kLightGreyColor,
                      onPressed: () {
                        // subscriptionsController.getSubscriptionOfferItems(offer.offerId);
                        if (signupOffer.count != "0") {
                          if (authController.userData.value.id.isNotEmpty) {
                            if (selectedRestaurant != null) {
                              if (subscriptionsController.selectedOfferItem.value.itemId.isNotEmpty) {
                                /* + Navigate to item details page + */
                                // subscriptionsController.placeSubscriptionOfferItemsOrder(offerId: offerId);
                                subscriptionsController.clearItemDetailsData();

                                navigate(
                                  type: PageType.to,
                                  page: MySubscriptionItemDetailsPage(
                                    item: subscriptionsController.selectedOfferItem.value,
                                    offerId: offer.offerId,
                                    offerRestaurantId: selectedRestaurant?.id ?? "",
                                    isSignupOfferOrder: true,
                                  ),
                                );
                              } else {
                                showMsg(msg: "Please select an item to redeem");
                              }
                            } else {
                              showMsg(msg: "Please select a restaurant to pick this order from");
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

class MyRestaurantsDropDown extends StatelessWidget {
  final Function(Restaurant?)? validator;
  final Function(Restaurant?)? onChange;
  final Restaurant? initialValue;
  final String? hintText;
  final String? labelText;
  final List<Restaurant>? listItem;

  final bool isForEdit;

  const MyRestaurantsDropDown({
    super.key,
    this.validator,
    this.onChange,
    this.initialValue,
    this.listItem,
    this.hintText,
    this.isForEdit = false,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.fieldsPadding),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(6),
      //   border: Border.all(
      //     width: 1.0,
      //     color: AppColors.kBorderColor,
      //   ),
      // ),
      child: DropdownButtonFormField<Restaurant>(
        decoration: isForEdit == true
            ? InputDecoration(
                contentPadding: CustomInputDecoration.padding,
                enabledBorder: CustomInputDecoration.fixBorder,
                focusedBorder: CustomInputDecoration.fixBorder,
                hintStyle: CustomInputDecoration.fixStyle,
                labelStyle: CustomInputDecoration.fixLabelStyle,
                focusedErrorBorder: CustomInputDecoration.errorBorder,
                errorBorder: CustomInputDecoration.errorBorder,
                labelText: labelText ?? "",
              )
            : const InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
        validator: (val) => validator != null ? validator!(val) : null,
        hint: MyText(
          text: hintText ?? "",
          style: isForEdit == true ? null : DropDownDeco.dropDownSignUpText,
        ),
        dropdownColor: isForEdit == true ? AppColors.kPrimaryColor : AppColors.kPrimaryColor,
        icon: Icon(
          FontAwesomeIcons.angleDown,
          color: isForEdit == true ? AppColors.kBlackColor : AppColors.kSecondaryColor,
          size: 22,
        ),
        iconSize: isForEdit == true ? 25 : 40,
        style: isForEdit == true ? null : DropDownDeco.dropDownSignUpSelectedText,
        isExpanded: true,
        value: initialValue,
        onChanged: (value) => onChange!(value),
        items: listItem?.map((rlItem) {
          return DropdownMenuItem(
            value: rlItem,
            child: MyText(text: rlItem.branchName),
          );
        }).toList(),
      ),
    );
  }
}

class SignupReferralOfferSelectableItemsWidget extends StatelessWidget {
  final List<OfferProduct> products;
  const SignupReferralOfferSelectableItemsWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    log("this being called : ${products.length}");
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      /* + Making a better looking one item based View + */
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 20),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          if (products[index].itemDetail.isEmpty) {
            return const SizedBox();
          }
          MenuItem item = products[index].itemDetail.first;

          return Obx(() {
            return MySubscriptionItemTile(
              showImage: false,
              fontSize: 18,
              textLeftPadding: 0,
              onTap: () async {
                log("SignupReferralOfferItemTile clicked");
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
    );
  }
}
