import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/my_orders_model.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/widgets/my_listtile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class MySubscriptionOrdersPage extends StatefulWidget {
  const MySubscriptionOrdersPage({super.key});

  @override
  State<MySubscriptionOrdersPage> createState() => _MySubscriptionOrdersPageState();
}

class _MySubscriptionOrdersPageState extends State<MySubscriptionOrdersPage> {
  @override
  void initState() {
    super.initState();
    subscriptionsController.getMySubscriptionOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "My Subscription Orders",
        haveBackIcon: true,
        onBackPressed: () {
          Get.back();
        },
      ),
      body: Obx(() {
        return subscriptionsController.mySubscriptionOrders.isNotEmpty && !apiController.isLoadingMySubscriptionOrders.value
            ? EasyRefresh(
                onRefresh: () {
                  apiController.isLoadingMySubscriptionOrders.value = true;
                  subscriptionsController.getMySubscriptionOrders();
                },
                child: ListView.builder(
                  itemCount: subscriptionsController.mySubscriptionOrders.length,
                  itemBuilder: (BuildContext context, int index) {
                    // MySubscriptionOrder mySubscriptionOrder = subscriptionsController.mySubscriptionOrders.toList()[index];
                    MyOrder mySubscriptionOrder = subscriptionsController.mySubscriptionOrders.toList()[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.kSkyLightDullColor, width: 2),
                      ),
                      child: MyListTile(
                        title: MyText(
                          text: "(Invoice # ${mySubscriptionOrder.invoiceNumber})",
                          // text: "(Order # ${mySubscriptionOrder.orderId})",
                          align: TextAlign.center,
                          color: AppColors.kBlackColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          // paddingTop: 5,
                          // paddingBottom: 20,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text:
                                  "${mySubscriptionOrder.planType.toLowerCase() == "free" ? "Free Offer" : "Subscription"}: ${mySubscriptionOrder.offerName.capitalizeFirst}",
                              align: TextAlign.center,
                              color: AppColors.kGreyColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              // paddingTop: 5,
                              // paddingBottom: 10,
                            ),
                            MyText(
                              text:
                                  "Ordered at: ${mySubscriptionOrder.dateCreated.isNotEmpty ? AppConstants.dateFormatWithTime.format(DateTime.parse(mySubscriptionOrder.dateCreated)) : ""}",
                              align: TextAlign.center,
                              color: AppColors.kGreyColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              // paddingTop: 5,
                            ),
                            MyText(
                              text: getStatus(mySubscriptionOrder.status),
                              fontSize: 15,
                              color: getColour(mySubscriptionOrder.status),
                              paddingBottom: 10,
                            ),
                          ],
                        ),
                        // trailing: Column(
                        //   children: [
                        //     MyText(
                        //       text: "\$${mySubscriptionOrder.offerAmount}",
                        //       align: TextAlign.center,
                        //       color: AppColors.kBlackColor,
                        //       fontWeight: FontWeight.normal,
                        //       fontSize: 18,
                        //       // paddingTop: 5,
                        //       // paddingBottom: 20,
                        //     ),
                        //     // MyButton(
                        //     //   height: AppSizes.buttonHeight,
                        //     //   width: 150,
                        //     //   text: "Get item ➺",
                        //     //   fontSize: 20,
                        //     //   color: AppColors.kRedColor,
                        //     //   onPressed: () {
                        //     //     subscriptionsController.getSubscriptionOfferItems(mySubscriptionOrder.offerId);
                        //     //     navigate(
                        //     //         type: PageType.to,
                        //     //         page: SubscriptionItemsPage(
                        //     //           offerId: mySubscriptionOrder.offerId,
                        //     //         ));
                        //     //   },
                        //     // ),
                        //   ],
                        // ),
                      ),
                    );
                  },
                ),
              )
            : apiController.isLoadingMySubscriptionOrders.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kLogoBasedColor,
                    ),
                  )
                : const Center(
                    child: MyText(
                      text: "No orders to show",
                      fontSize: 16,
                    ),
                  );
      }),
    );
  }
}
