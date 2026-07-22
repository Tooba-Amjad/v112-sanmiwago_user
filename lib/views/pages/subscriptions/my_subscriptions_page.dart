import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/subscription_models/my_subscription_model.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/subscription_items_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_dialog.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class MySubscriptionsPage extends StatefulWidget {
  final bool shouldHaveBackIcon;

  const MySubscriptionsPage({super.key, this.shouldHaveBackIcon = true});

  @override
  State<MySubscriptionsPage> createState() => _MySubscriptionsPageState();
}

class _MySubscriptionsPageState extends State<MySubscriptionsPage> {
  @override
  void initState() {
    super.initState();

    subscriptionsController.getMySubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "My Subscriptions",
        haveBackIcon: widget.shouldHaveBackIcon,
        onBackPressed: () {
          Get.back();
        },
      ),
      body: Obx(() {
        return subscriptionsController.mySubscriptionsList.isNotEmpty && !apiController.isLoadingMySubscriptions.value
            ? EasyRefresh(
                onRefresh: () {
                  apiController.isLoadingMySubscriptions.value = true;
                  subscriptionsController.getMySubscriptions();
                },
                child: ListView.builder(
                  itemCount: subscriptionsController.mySubscriptionsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    MySubscription mySubscription = subscriptionsController.mySubscriptionsList.toList()[index];
                    log("Restaurant Id in ListView.builder ${mySubscription.restaurantId}");
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: MyText(
                                  text: mySubscription.offerName.capitalizeFirst,
                                  // text: (mySubscription.offerName.isNotEmpty ? mySubscription.offerName : "").capitalizeFirst,
                                  align: TextAlign.start,
                                  color: AppColors.kBlackColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  maxLines: 2,
                                  // paddingTop: 5,
                                  // paddingBottom: 20,
                                ),
                              ),
                              Expanded(
                                child: MyText(
                                  text: "\$${mySubscription.offerAmount}",
                                  align: TextAlign.center,
                                  color: AppColors.kBlackColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  // paddingTop: 5,
                                  // paddingBottom: 20,
                                ),
                              ),
                            ],
                          ),
                          MyText(
                            text: "Restaurant: ${mySubscription.branchName.capitalizeFirst}",
                            align: TextAlign.left,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            // paddingTop: 5,
                            paddingBottom: 5,
                          ),
                          MyText(
                            text: "Type: ${getOfferDuration(mySubscription.offerDuration.toLowerCase()).capitalizeFirst}",
                            align: TextAlign.left,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            // paddingTop: 5,
                            paddingBottom: 5,
                          ),
                          MyText(
                            text:
                                "Next Billing Date: ${mySubscription.nextBillingDate.isNotEmpty ? AppConstants.dateFormat.format(DateTime.tryParse(mySubscription.nextBillingDate) ?? DateTime.now()) : ""}",
                            align: TextAlign.left,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            // paddingTop: 5,
                            paddingBottom: 10,
                          ),

                          // dividerCommon(),
                          SizedBox(height: 5),
                          mySubscription.autoRenew == "1"
                              ? Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      showMyAnimatedDialog(
                                        context: context,
                                        child: MyNewConfirmDialog(
                                          title: "Stop Auto-Renewal?",
                                          msg: "Your subscription will not be renewed after it completes the subscribed period. This cannot be undone!",
                                          rightButtonText: "Yes",
                                          leftButtonText: "No",
                                          rightButtonWidth: 90,
                                          leftButtonWidth: 70,
                                          yesOnPressed: () {
                                            apiController.stopAutoRenewalOfSubscription(subId: mySubscription.id);
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: MyText(
                                        text: "Stop Auto-renewal",
                                        align: TextAlign.center,
                                        color: AppColors.kRedColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        paddingTop: 5,
                                        paddingBottom: 5,
                                        paddingRight: 5,
                                        paddingLeft: 5,
                                      ),
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: MyText(
                                    text: "Auto-renewal Stopped",
                                    align: TextAlign.center,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                          SizedBox(height: 5),

                          mySubscription.isRefund == "0"
                              ? Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      showMyAnimatedDialog(
                                        context: context,
                                        child: MyNewConfirmDialog(
                                          title: "Cancel Subscription?",
                                          msg:
                                              "Your amount based on the remaining time will be refunded to you and you will not be able to order again using this subscription. This cannot be undone!",
                                          rightButtonText: "Yes",
                                          leftButtonText: "No",
                                          rightButtonWidth: 90,
                                          leftButtonWidth: 70,
                                          yesOnPressed: () {
                                            apiController.cancelSubscription(subId: mySubscription.id, offerId: mySubscription.offerId);
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: MyText(
                                        text: "Cancel Subscription",
                                        align: TextAlign.center,
                                        color: AppColors.kRedColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        paddingTop: 5,
                                        paddingBottom: 5,
                                        paddingRight: 5,
                                        paddingLeft: 5,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),

                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.center,
                            child: MyButton(
                              height: AppSizes.buttonHeight,
                              width: 200,
                              text: "Redeem item",
                              // text: "Redeem item ➺",
                              fontSize: 20,
                              color: AppColors.kRedColor,
                              onPressed: () {
                                log("On Pressed offerId :  ${mySubscription.offerId} and  Id is  : ${mySubscription.id} Restaurant Id : ${mySubscription.restaurantId} ");
                                log("");
                                subscriptionsController.getSubscriptionOfferItems(mySubscription.offerId);
                                log("mySubscription.restaurantId Before going to next page : ${mySubscription.restaurantId}");
                                log("Before going to items page items page restaurant Id : ${mySubscription.restaurantId}");
                                log("mySubscription.restaurantId != null ${mySubscription.restaurantId != null}");
                                log("mySubscription.restaurantId.isNotEmpty ${mySubscription.restaurantId.isNotEmpty}");
                                log("mySubscription.restaurantId != " " ${mySubscription.restaurantId != ""}");
                                if (mySubscription.restaurantId.isNotEmpty || mySubscription.restaurantId != "") {
                                  log("inside if (mySubscription.restaurantId ${mySubscription.restaurantId}");
                                  navigate(
                                    type: PageType.to,
                                    page: SubscriptionItemsPage(
                                      offerId: mySubscription.offerId,
                                      offerRestaurantId: mySubscription.restaurantId,
                                    ),
                                  );
                                } else {
                                  log("inside else part ");
                                  showMsg(msg: "There seems to be some issue on our side. We will resolve it as soon as we can. Please try again after some time.!");
                                }
                              },
                            ),
                          ),

                          SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
              )
            : apiController.isLoadingMySubscriptions.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kLogoBasedColor,
                    ),
                  )
                : const Center(
                    child: MyText(
                      text: "No subscriptions to show",
                      fontSize: 16,
                    ),
                  );
      }),
    );
  }
}
