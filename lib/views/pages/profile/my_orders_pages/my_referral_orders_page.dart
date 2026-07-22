import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/constants/my_logger.dart';
import 'package:sanmiwago_user/models/my_referral_models/my_referral_order_model.dart';
import 'package:sanmiwago_user/views/pages/profile/my_orders_pages/my_order_container.dart';
import 'package:sanmiwago_user/views/pages/profile/my_orders_pages/my_referral_order_container.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class MyReferralOrdersPage extends StatefulWidget {
  const MyReferralOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyReferralOrdersPage> createState() => _MyReferralOrdersPageState();
}

class _MyReferralOrdersPageState extends State<MyReferralOrdersPage> {
  ScrollController myReferralOrdersListScrollController = ScrollController();

  @override
  void initState() {
    myReferralOrdersListScrollController.addListener(() {
      if (myReferralOrdersListScrollController.position.maxScrollExtent == myReferralOrdersListScrollController.offset) {
        myReferralsController.getMyReferralOrdersList();
      }
    });

    // if (myOrdersController.myReferralOrdersList.isEmpty) {
    apiController.isLoadingMyReferralOrders.value = true;
    myReferralsController.myReferralOrdersList.clear();
    myReferralsController.getMyReferralOrdersList(enforceOffset: true);

    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "Share Item",
        haveBackIcon: true,
      ),
      body: Obx(() {
        return myReferralsController.myReferralOrdersList.isNotEmpty
            ? EasyRefresh(
                onRefresh: () {
                  apiController.isLoadingMyReferralOrders.value = true;
                  myReferralsController.myReferralOrdersList.clear();
                  myReferralsController.getMyReferralOrdersList(enforceOffset: true);
                },
                child: ListView.builder(
                  itemCount: myReferralsController.myReferralOrdersList.length + 1,
                  controller: myReferralOrdersListScrollController,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < myReferralsController.myReferralOrdersList.length) {
                      MyReferralOrder order = myReferralsController.myReferralOrdersList[index];
                      return MyReferralOrderContainer(
                        id: order.orderId,
                        invoiceNumber: order.invoiceNumber,
                        status: order.status,
                        price: order.totalCost,
                        paymentType: order.paymentType,
                        isPointRedeemed: order.isPointsRedeemed,
                        dateTime: order.dateCreated,
                        isReferralOrder: true,
                        userName: order.customerName,
                        userEmail: order.email,
                        userPhone: order.phone,
                        order: order
                      );
                    } else {
                      if (myReferralsController.myReferralOrdersList.length < 10) {
                        return const SizedBox();
                      } else {
                        return Obx(() {
                          if (!apiController.isLoadingMyReferralOrders.value) {
                            infoLog("My referral order page ${apiController.isLoadingMyReferralOrders.value}");
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Center(child: MyText(text: "No more data to show".tr)),
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: AppColors.kLogoBasedColor,
                                ),
                              ),
                            ),
                          );
                        });
                      }
                    }
                    //   Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(5),
                    //       border: Border.all(color: AppColors.kSkyLightDullColor, width: 2)
                    //   ),
                    //   child: const MyListTile(
                    //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    //     title: MyText(
                    //       text: "(Order # 1231)",
                    //       fontSize: 16,
                    //     ),
                    //     subtitle: MyText(
                    //       text: "Accept",
                    //       fontSize: 14,
                    //     ),
                    //     trailing: MyText(
                    //       text: "\$5.99",
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //     trailingTopPadding: 10,
                    //   ),
                    // );
                  },
                ),
              )
            : apiController.isLoadingMyReferralOrders.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kLogoBasedColor,
                    ),
                  )
                : const Center(
                    child: MyText(
                      text: "No data to show",
                      fontSize: 16,
                    ),
                  );
      }),
    );
  }
}
