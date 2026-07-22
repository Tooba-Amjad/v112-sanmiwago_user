import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/home/home_menu_page.dart';
import 'package:sanmiwago_user/views/pages/profile/my_orders_pages/my_orders_page.dart';
import 'package:sanmiwago_user/views/pages/profile/profile_menu_page.dart';
import 'package:sanmiwago_user/views/pages/restaurants_list/bottom_restaurant_list_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/subscription_offers_page.dart';
import 'package:sanmiwago_user/views/widgets/my_drawer.dart';

class BottomNavBarPage extends StatefulWidget {
  final bool homeReload;

  const BottomNavBarPage({super.key, this.homeReload = false});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  @override
  void initState() {
    super.initState();
  }

  DateTime? _lastPressedAt; // stores the last pressed time

  bool get canPop {
    DateTime now = DateTime.now();
    if (_lastPressedAt == null || now.difference(_lastPressedAt!) > Duration(seconds: 2)) {
      // Show a toast or snackbar here if needed
      showMsg(msg: "Tap again to exit");
      _lastPressedAt = now;
      return false;
    }
    return true;
  }

  bool canPopNow = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPopNow,
      onPopInvoked: (canPop) {
        DateTime now = DateTime.now();
        if (_lastPressedAt == null || now.difference(_lastPressedAt!) > Duration(seconds: 2)) {
          // Show a toast or snackbar here if needed
          _lastPressedAt = now;
          // setState(() {
          //   canPopNow = false;
          // });
          showMsg(msg: "Tap again to exit");
        }
        // else {
        //   setState(() {
        //     canPopNow = true;
        //   });
        // }
        else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        key: drawerController.scaffoldKey,
        drawer: const MyDrawer(),
        body: Obx(() {
          return IndexedStack(
            index: bottomNavBarController.selectedIndex.value,
            children: [
              HomeMenuPage(reload: widget.homeReload),
              BottomRestaurantListPage(isFromBottomNavBarPage: true),
              MyOrdersPage(isFromBottomNavBar: true),
              ProfileMenuPage(),
              // MyPointsPage(),
              SubscriptionOffersPage(showBack: false),
            ],
          );
        }),
        bottomNavigationBar: Obx(() {
          return SizedBox(
            height: Platform.isIOS ? 95 : 107,
            child: Material(
              elevation: 20,
              child: BottomNavigationBar(
                elevation: 20,
                currentIndex: bottomNavBarController.selectedIndex.value,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.kSiteBasedLogoLikeColor,
                unselectedItemColor: AppColors.kBlackColor,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                backgroundColor: AppColors.kPrimaryColor,
                onTap: (int index) {
                  bottomNavBarController.updateIndex(index);
                  log("index: $index");
                  if (index == 4) {
                    subscriptionsController.getSubscriptionOffers();
                  } else if (index == 2) {
                    log("apiController.isLoadingMyOrdersSimple: ${apiController.isLoadingMyOrdersSimple}");

                    /* + Using the isLoadingMyOrdersSimple because the other one has to be kept true so that  + */
                    /* + in case when loading the next page of records, the loading still comes and it does not show + */
                    /* + No records found at the end of the list unless there actually aren't any left + */
                    if (!apiController.isLoadingMyOrdersSimple) {
                      log("is Loading of orders was not true");
                      apiController.isLoadingMyOrders.value = true;
                      myOrdersController.myOrdersList.clear();
                      apiController.getMyOrdersList(enforceOffset: true);
                    }
                  }
                },
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Menu"),
                  BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Stores"),
                  BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "My Orders"),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
                  BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: "Offers"),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
