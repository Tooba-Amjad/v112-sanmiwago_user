import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/restaurant_model.dart';
import 'package:sanmiwago_user/utils/custom_scroll_behavior.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/restaurants_list/my_restaurant_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class BottomRestaurantListPage extends StatefulWidget {
  final bool isFromSplash;
  final bool isFromBottomNavBarPage;

  const BottomRestaurantListPage({super.key, this.isFromSplash = false, this.isFromBottomNavBarPage = false});

  @override
  State<BottomRestaurantListPage> createState() => _BottomRestaurantListPageState();
}

class _BottomRestaurantListPageState extends State<BottomRestaurantListPage> {
  @override
  void initState() {
    restaurantController.getRestaurantsList();
    log("selectedRestaurantId.value: ${restaurantController.selectedRestaurantId.value}");
    super.initState();
  }

  //+Removed
//   onWillPop: () async {
//   if (widget.isFromSplash) {
//   return false;
//   } else {
//   return true;
//   }
// },
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSkyLightDullColor,
      // key: drawerController.scaffoldKey,
      // drawer: const MyDrawer(),
      appBar: simpleAppBar(
        title: "Restaurants",
        haveBackIcon: false,
        haveDrawerIcon: true,
        // haveBackIcon: !widget.isFromSplash,
        // onBackPressed: () {
        //   Get.back();
        // },
        actions: [
          authController.userData.value.id.isNotEmpty
              ? Center(
                  child: Obx(() {
                    log("authController.userData.value.createdOn: ${authController.userData.value.createdOn}");
                    DateTime createdOn = DateTime.fromMillisecondsSinceEpoch(
                        ((int.tryParse(authController.userData.value.createdOn) ?? (DateTime.now().millisecondsSinceEpoch / 1000)) * 1000).toInt());
                    return MyText(
                      text: AppConstants.dateFormat.format(createdOn),
                      // text: "${(createdOn.month).toString().padLeft(2, "0")}/${(createdOn.day).toString().padLeft(2, "0")}/${createdOn.year.toString().substring(2)}",
                      fontSize: 16,
                      paddingRight: 10,
                    );
                  }),
                )
              : SizedBox(),
        ],
      ),
      body: Column(
        children: [
          //+ top buttons section
          IntrinsicHeight(
            child: Container(
              // height: (giftCardController.selectedMenu.value == giftCardController.menus[0] && giftCardController.isCardSelected.value == false) ? 200 : 80,
              color: const Color(0xffff7925),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: AppSizes.pagePadding),
              // margin: EdgeInsets.only(bottom: Get.height * .3),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    child: MyText(
                      text: "Available Restaurants",
                      align: TextAlign.center,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      paddingBottom: 10,
                      paddingTop: 20,
                    ),
                  ),
                  MyText(
                    text: "Select the restaurant you want to order from 😋.",
                    align: TextAlign.center,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    paddingBottom: 30,
                    paddingLeft: 30,
                    paddingRight: 30,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              return !apiController.isLoadingRestaurants.value
                  ? ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: ListView.separated(
                        itemCount: restaurantController.restaurants.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          log("restaurantController.restaurants: ${restaurantController.restaurants.length}");
                          log("selectedRestaurantId.value: ${restaurantController.selectedRestaurantId.value}");

                          Restaurant rest = restaurantController.restaurants[index];
                          return Obx(() {
                            return MyRestaurantTile(
                              onTap: () async {
                                // if (restaurantController.selectedRestaurantId.value == rest.id) {
                                //   // do nothing
                                // } else {
                                restaurantController.updateSelectedRestaurant(
                                  rest.id,
                                  rest.address,
                                  rest.phone,
                                  restaurant: rest,
                                  isFromSplash: widget.isFromSplash,
                                  isFromBottomNavBarPage: true,
                                );
                                log("Restaurant Id restaurant page Bottom Nav Bar Page ${restaurantController.selectedRestaurantId.value}");
                                // }
                              },
                              name: rest.branchName.capitalize,
                              address: rest.address.capitalize,
                              phone: rest.phone,
                              isSelected: restaurantController.selectedRestaurantId.value == rest.id,
                              onChanged: (value) {
                                if (value ?? false) {
                                  restaurantController.updateSelectedRestaurant(
                                    rest.id,
                                    rest.address,
                                    rest.phone,
                                    restaurant: rest,
                                    isFromBottomNavBarPage: true,
                                  );
                                } else {
                                  showMsg(
                                    msg: "One of the branches has to be selected at all times. You cannot unselect it "
                                        "but you can select another one if you like.",
                                  );
                                }
                              },
                            );
                          });
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 2,
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.kLogoBasedColor,
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }
}
