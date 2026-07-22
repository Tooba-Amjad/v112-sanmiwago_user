import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/constants/my_logger.dart';
import 'package:sanmiwago_user/models/my_points_model.dart';
import 'package:sanmiwago_user/views/pages/profile/my_points_container.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class MyPointsPage extends StatefulWidget {
  final bool isFromProfilePage;
  const MyPointsPage({Key? key, this.isFromProfilePage = false}) : super(key: key);

  @override
  State<MyPointsPage> createState() => _MyPointsPageState();
}

class _MyPointsPageState extends State<MyPointsPage> {
  ScrollController myPointsListScrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // apiController.getUserPoints();
      myPointsListScrollController.addListener(() {
        if (myPointsListScrollController.position.maxScrollExtent == myPointsListScrollController.offset) {
          apiController.getMyPointsList();
        }
      });

      // if (myPointsController.myPointsList.isEmpty) {
      apiController.isLoadingMyPoints.value = true;
      myPointsController.myPointsList.clear();
      apiController.getUserPoints();
      apiController.getMyPointsList(enforceOffset: true);
      // }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "My Points",
        haveBackIcon: widget.isFromProfilePage ? true : false,
        haveDrawerIcon: widget.isFromProfilePage ? false : true,
      ),
      body: SizedBox(
        height: Get.height,
        child: Column(
          children: [
            Container(
              height: 50,
              color: AppColors.kSkyLightColor,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppColors.kLogoBasedColor,
                  ),
                  Obx(() {
                    return MyText(
                      text: "Balance: ${(double.tryParse(authController.userData.value.userPoints) ?? 0.0).toPrecision(2).toStringAsFixed(2)} Points",
                      fontWeight: FontWeight.bold,
                      color: AppColors.kLogoBasedColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      paddingTop: 10,
                      paddingBottom: 10,
                      paddingLeft: 7,
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                return myPointsController.myPointsList.isNotEmpty
                    ? EasyRefresh(
                        onRefresh: () {
                          apiController.isLoadingMyPoints.value = true;
                          myPointsController.myPointsList.clear();
                          apiController.getUserPoints();
                          apiController.getMyPointsList(enforceOffset: true);
                        },
                        child: ListView.builder(
                          controller: myPointsListScrollController,
                          itemCount: myPointsController.myPointsList.length + 1,
                          // physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            if (index < myPointsController.myPointsList.length) {
                              MyPoints point = myPointsController.myPointsList[index];
                              // log("points: ${point.points}");
                              // log("points: ${point.createdOn}");
                              return MyPointsContainer(
                                orderId: point.orderId,
                                invoiceId: point.invoiceNumber,
                                type: point.transactionType,
                                description: point.description,
                                dateTime: point.createdOn,
                                amount: double.tryParse(point.points) == null ? point.points : (double.tryParse(point.points) ?? 0.0).toPrecision(2).toStringAsFixed(2),
                              );
                            } else {
                              if (myPointsController.myPointsList.length < 10) {
                                return const SizedBox();
                              } else {
                                return Obx(() {
                                  if (!apiController.isLoadingMyPoints.value) {
                                    infoLog("My points page ${apiController.isLoadingMyPoints.value}");
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
                          },
                        ),
                      )
                    : apiController.isLoadingMyPoints.value
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
            ),
          ],
        ),
      ),
    );
  }
}
