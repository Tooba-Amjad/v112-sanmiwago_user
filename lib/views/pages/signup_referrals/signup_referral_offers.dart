import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/signup_referral_offer_models/signup_referral_offer_model.dart';
import 'package:sanmiwago_user/models/subscription_models/my_subscription_model.dart';
import 'package:sanmiwago_user/models/subscription_models/subscription_offers_model.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/signup_referrals/signup_referral_offer_details_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/subscription_items_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_dialog.dart';
import 'package:sanmiwago_user/views/widgets/my_listtile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class MySignupReferralOffersPage extends StatefulWidget {
  final bool shouldHaveBackIcon;

  const MySignupReferralOffersPage({super.key, this.shouldHaveBackIcon = true});

  @override
  State<MySignupReferralOffersPage> createState() => _MySignupReferralOffersPageState();
}

class _MySignupReferralOffersPageState extends State<MySignupReferralOffersPage> {
  @override
  void initState() {
    super.initState();

    subscriptionsController.getSignupReferralOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "Signup Referral Offers",
        haveBackIcon: widget.shouldHaveBackIcon,
        onBackPressed: () {
          Get.back();
        },
      ),
      body: Obx(() {
        return subscriptionsController.signupReferralOffers.isNotEmpty && !apiController.isLoadingSignupReferralOffers.value
            ? EasyRefresh(
                onRefresh: () {
                  apiController.isLoadingSignupReferralOffers.value = true;
                  subscriptionsController.getSignupReferralOffers();
                },
                child: ListView.builder(
                  itemCount: subscriptionsController.signupReferralOffers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ExpandableController historyExpandedController = ExpandableController(initialExpanded: false);
                    final sc = ScrollController();

                    SignupReferralOffer signupReferralOffer = subscriptionsController.signupReferralOffers.toList()[index];
                    log("Restaurant Id in ListView.builder ${signupReferralOffer.restaurantId}");
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.kSkyLightDullColor, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),

                          MyListTile(
                            trailingTopPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            title: SizedBox(),
                            leading: MyText(
                              text: signupReferralOffer.offerName.capitalizeFirst,
                              // text: (mySubscription.offerName.isNotEmpty ? mySubscription.offerName : "").capitalizeFirst,
                              align: TextAlign.center,
                              color: AppColors.kBlackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              maxLines: 2,
                              // paddingTop: 5,
                              // paddingBottom: 20,
                            ),
                            trailing: Row(
                              children: [
                                MyText(
                                  text: "Available: ",
                                  align: TextAlign.center,
                                  color: AppColors.kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  // paddingTop: 5,
                                  // paddingBottom: 20,
                                ),
                                MyText(
                                  text: signupReferralOffer.count,
                                  align: TextAlign.center,
                                  color: AppColors.kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  // paddingTop: 5,
                                  // paddingBottom: 20,
                                ),
                              ],
                            ),
                          ),

                          MyText(
                            text:
                                "Created at: ${signupReferralOffer.createdAt.isNotEmpty ? AppConstants.dateFormat.format(DateTime.tryParse(signupReferralOffer.createdAt) ?? DateTime.now()) : ""}",
                            align: TextAlign.left,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            // paddingTop: 5,
                            paddingBottom: 5,
                          ),

                          // dividerCommon(),

                          // SizedBox(height: 5),
                          signupReferralOffer.count != "0"
                              ? Align(
                                  alignment: Alignment.center,
                                  child: MyButton(
                                    height: AppSizes.buttonHeight,
                                    width: 170,
                                    text: "Redeem item",
                                    // text: "Redeem item ➺",
                                    fontSize: 16,
                                    color: AppColors.kRedColor,
                                    onPressed: () async {
                                      log("On Pressed offerId :  ${signupReferralOffer.offerId} and  Id is  : ${signupReferralOffer.id} Restaurant Id : ${signupReferralOffer.restaurantId} ");
                                      log("");

                                      showCircularLoading();
                                      SubscriptionOffer? offerDetails = await subscriptionsController.getSpecificSignupReferralOffer(signupReferralOffer.offerId);
                                      dismissLoading();
                                      // log("signupReferralOffer.restaurantId Before going to next page : ${signupReferralOffer.restaurantId}");
                                      // log("Before going to items page items page restaurant Id : ${signupReferralOffer.restaurantId}");
                                      // log("signupReferralOffer.restaurantId != null ${signupReferralOffer.restaurantId != null}");
                                      // log("signupReferralOffer.restaurantId.isNotEmpty ${signupReferralOffer.restaurantId.isNotEmpty}");
                                      // log("signupReferralOffer.restaurantId != " " ${signupReferralOffer.restaurantId != ""}");
                                      if (offerDetails != null) {
                                        log("inside if (offerDetails.restaurantId ${offerDetails.restaurantId}");
                                        navigate(
                                          type: PageType.to,
                                          page: SignupReferralOfferDetailsPage(
                                            prevOffer: offerDetails,
                                            showBack: true,
                                            signupOffer: signupReferralOffer,
                                          ),
                                        );
                                      } else {
                                        log("inside else part ");
                                        showMsg(
                                          msg: "Could not fetch the offer details. Please try again after some time.",
                                          // msg: "There seems to be some issue on our side. We will resolve it as soon as we can. Please try again after some time.!",
                                        );
                                      }
                                    },
                                  ),
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

                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: const BoxDecoration(),
                            child: ExpandablePanel(
                              controller: historyExpandedController,
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
                                      text: "Referral History",
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
                              expanded: SizedBox(
                                height: signupReferralOffer.referralHistory.length * 190,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: sc,
                                  itemCount: signupReferralOffer.referralHistory.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    ReferralHistory refH = signupReferralOffer.referralHistory[index];
                                    return Container(
                                      margin: const EdgeInsets.only(right: 12, left: 5, top: 5, bottom: 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: AppColors.kSkyLightDullColor, width: 2),
                                      ),
                                      child: Column(
                                        children: [
                                          /* + Type + */
                                          Row(
                                            children: [
                                              MyText(
                                                text: "Type: ",
                                                // text: "apiController selectedOrder Data Data",
                                                fontSize: 14,
                                                color: AppColors.kGreyColor,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                // maxLines: 2,
                                                paddingLeft: 5,
                                                paddingBottom: 5,
                                              ),
                                              MyText(
                                                text: refH.type?.capitalizeFirst ?? "N/A",
                                                // text: "apiController selectedOrder Data Data",
                                                fontSize: 14,
                                                color: AppColors.kGreyColor,
                                                fontWeight: FontWeight.normal,
                                                overflow: TextOverflow.ellipsis,
                                                // maxLines: 2,
                                                paddingLeft: 5,
                                                paddingBottom: 5,
                                              ),
                                            ],
                                          ),

                                          /* + Refer By + */
                                          Row(
                                            children: [
                                              MyText(
                                                text: "Refer By: ",
                                                // text: "apiController selectedOrder Data Data",
                                                fontSize: 14,
                                                color: AppColors.kGreyColor,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                // maxLines: 2,
                                                paddingLeft: 5,
                                                paddingBottom: 5,
                                              ),
                                              Expanded(
                                                child: MyText(
                                                  text: refH.parentName?.capitalizeFirst ?? "N/A",
                                                  // text: "apiController selectedOrder Data Data",
                                                  fontSize: 14,
                                                  color: AppColors.kGreyColor,
                                                  fontWeight: FontWeight.normal,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  paddingLeft: 5,
                                                  paddingBottom: 5,
                                                ),
                                              ),
                                            ],
                                          ),

                                          /* + Refer To + */
                                          Row(
                                            children: [
                                              MyText(
                                                text: "Refer To: ",
                                                // text: "apiController selectedOrder Data Data",
                                                fontSize: 14,
                                                color: AppColors.kGreyColor,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                // maxLines: 2,
                                                paddingLeft: 5,
                                                paddingBottom: 5,
                                              ),
                                              Expanded(
                                                child: MyText(
                                                  text: refH.childName?.capitalizeFirst ?? "N/A",
                                                  // text: "apiController selectedOrder Data Data",
                                                  fontSize: 14,
                                                  color: AppColors.kGreyColor,
                                                  fontWeight: FontWeight.normal,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  paddingLeft: 5,
                                                  paddingBottom: 5,
                                                ),
                                              ),
                                            ],
                                          ),

                                          /* + Description + */
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: "Description: ",
                                                // text: "apiController selectedOrder Data Data",
                                                fontSize: 14,
                                                color: AppColors.kGreyColor,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                // maxLines: 2,
                                                paddingLeft: 5,
                                                paddingBottom: 5,
                                              ),
                                              Expanded(
                                                child: MyText(
                                                  text: refH.description?.capitalizeFirst ?? "N/A",
                                                  // text: "apiController selectedOrder Data Data",
                                                  fontSize: 14,
                                                  color: AppColors.kGreyColor,
                                                  fontWeight: FontWeight.normal,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  paddingLeft: 5,
                                                  paddingBottom: 5,
                                                ),
                                              ),
                                            ],
                                          ),

                                          /* + Created at + */
                                          Row(
                                            children: [
                                              MyText(
                                                text: "Created at: ",
                                                // text: "apiController selectedOrder Data Data",
                                                fontSize: 14,
                                                color: AppColors.kGreyColor,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                // maxLines: 2,
                                                paddingLeft: 5,
                                                paddingBottom: 10,
                                              ),
                                              MyText(
                                                text:
                                                    (refH.createdAt != null) ? AppConstants.dateFormat.format(DateTime.tryParse(refH.createdAt!) ?? DateTime.now()) : "",
                                                // text: "apiController selectedOrder Data Data",
                                                fontSize: 14,
                                                color: AppColors.kGreyColor,
                                                fontWeight: FontWeight.normal,
                                                overflow: TextOverflow.ellipsis,
                                                // maxLines: 2,
                                                paddingLeft: 5,
                                                paddingBottom: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
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
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : apiController.isLoadingSignupReferralOffers.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kLogoBasedColor,
                    ),
                  )
                : const Center(
                    child: MyText(
                      text: "No signup referral offers to show",
                      fontSize: 16,
                    ),
                  );
      }),
    );
  }
}
