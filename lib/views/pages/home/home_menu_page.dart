import 'dart:async';
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/category_model.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/utils/custom_scroll_behavior.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/cart/cart_page.dart';
import 'package:sanmiwago_user/views/pages/home/my_category_tile.dart';
import 'package:sanmiwago_user/views/pages/home/my_item_tile.dart';
import 'package:sanmiwago_user/views/pages/item_details/item_details_page.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_drawer.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class HomeMenuPage extends StatefulWidget {
  const HomeMenuPage({super.key, this.reload = true});

  final bool reload;

  @override
  State<HomeMenuPage> createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _scrollIndex = 0;

  void fetchRequiredData() {
    Future.wait([apiController.getSiteInfo(), apiController.getSalesTax(), apiController.getUpdatedProfileData()]);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.reload) {
        catItemController.getCategoryList();
        // if (authController.userData.value.id.isNotEmpty) apiController.getUserPoints();
      }
      fetchRequiredData();
      locationController.determinePosition(context, showLoading: false);

      // restaurantController.getRestaurantsList();
    });

    // Start a timer to trigger scrolling every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (catItemController.categories.isEmpty) return;
      try {
        _autoScrollList();
      } catch (e) {
        log("error in list scroll: $e");
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
        _timer?.cancel();
        _timer = Timer.periodic(Duration(seconds: 15), (timer) {
          try {
            _autoScrollList();
          } catch (e) {
            log("error in list scroll: $e");
          }
        });
      } else {
        // if(_scrollController.offset == _scrollController.position.minScrollExtent) {
        _timer?.cancel();
        _timer = Timer.periodic(Duration(seconds: 3), (timer) {
          try {
            _autoScrollList();
          } catch (e) {
            log("error in list scroll: $e");
          }
        });
      }
      // if (_scrollController.position.isScrollingNotifier.value) {
      //   if (!_isScrolling) {
      //     setState(() => _isScrolling = true);
      //   }
      // } else {
      //   if (_isScrolling) {
      //     setState(() => _isScrolling = false);
      //   }
      // }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when widget is disposed
    _scrollController.dispose(); // Dispose the controller
    super.dispose();
  }

  void _autoScrollList() {
    // Calculate the next index to scroll to
    _scrollIndex++;
    if (_scrollIndex >= catItemController.categories.length && _scrollController.offset == _scrollController.position.maxScrollExtent) {
      _scrollIndex = 0; // Reset index when reaching the end
    }

    // Animate the list to the new index
    _scrollController.animateTo(
      _scrollController.offset == _scrollController.position.maxScrollExtent && !_scrollController.position.isScrollingNotifier.value
          ? _scrollController.position.minScrollExtent
          : _scrollController.offset + 150,
      // _scrollIndex * 150.0, // Adjust item size if necessary
      duration: Duration(milliseconds: _scrollController.offset == _scrollController.position.maxScrollExtent ? 2000 : 500), // Animation duration
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused || AppLifecycleState.detached || AppLifecycleState.inactive:
        log("App was paused");
        apiController.getUpdatedProfileData();
        break;
      case AppLifecycleState.resumed:
        log("App was resumed");
        apiController.getUpdatedProfileData();
        break;
      default:
    }
  }

  final ScrollController categoriesScrollController = ScrollController();
  bool scroll = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSkyLightDullColor,

      key: authController.isLoggedIn.value ? null : drawerController.homeScaffoldKey,
      drawer: authController.isLoggedIn.value ? null : const MyDrawer(),
      appBar: simpleAppBar(
        title: "Menu",
        haveBackIcon: false,
        haveDrawerIcon: true,
        actions: [
          Obx(() {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                MyButton(
                  width: 120,
                  text: "Cart",
                  textColor: AppColors.kBlackColor,
                  fontSize: 14,
                  iconSize: 20,
                  icon: Icons.shopping_cart_outlined,
                  color: AppColors.kWhiteColor,
                  onPressed: () {
                    // navigate(type: PageType.to, page: const CartPage());
                    if (authController.userData.value.id.isNotEmpty || authController.isContinuedAsGuest.value) {
                      navigate(type: PageType.to, page: const CartPage());
                    } else {
                      navigate(type: PageType.to, page: const LoginPage(isFromCart: true));
                    }
                  },
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Visibility(
                    visible: orderController.cartItems.isNotEmpty,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      constraints: const BoxConstraints(minHeight: 15, maxHeight: 15, minWidth: 15),
                      // height: 15,
                      // width: 15
                      decoration: BoxDecoration(color: AppColors.kLogoBasedColor, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: MyText(
                          text: orderController.cartItems.fold(0, (previousValue, element) => previousValue + element.itemCount).toString(),
                          align: TextAlign.center,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          paddingTop: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
        onBackPressed: () {
          Get.back();
        },
      ),
      // endDrawer: const MyDrawer(),
      body: EasyRefresh(
        header: MaterialHeader(color: AppColors.kLogoBasedColor),
        onRefresh: () async {
          catItemController.getCategoryList();
        },
        child: Container(
          height: Get.height,
          color: AppColors.kPrimaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.pagePadding,
            // vertical: AppSizes.pagePadding,
          ),
          child: Obx(() {
            return catItemController.categories.isNotEmpty && !apiController.isLoadingCategories.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyText(
                        text: "Categories",
                        align: TextAlign.left,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        paddingTop: 10,
                        paddingBottom: 8,
                      ),
                      SizedBox(
                        height: 50,
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: Obx(() {
                            return apiController.isLoadingCategories.value
                                ? Center(child: showInlineLoading())
                                : ListView.builder(
                                    itemCount: catItemController.categories.length,
                                    scrollDirection: Axis.horizontal,
                                    controller: _scrollController,
                                    itemBuilder: (BuildContext context, int index) {
                                      MenuCategory cat = catItemController.categories[index];
                                      // if (scroll) {
                                      //   Future.delayed(const Duration(milliseconds: 300), () async {
                                      //     categoriesScrollController.animateTo(
                                      //         // categoriesScrollController.position.maxScrollExtent,
                                      //         catItemController.categories.length * 100,
                                      //         duration: const Duration(milliseconds: 1200),
                                      //         curve: Curves.easeIn);
                                      //     await Future.delayed(const Duration(seconds: 1));
                                      //     categoriesScrollController.animateTo(categoriesScrollController.position.minScrollExtent,
                                      //         duration: const Duration(milliseconds: 1700), curve: Curves.easeIn);
                                      //   });
                                      //
                                      //   WidgetsBinding.instance!.addPostFrameCallback((_) {
                                      //     setState(() {
                                      //       scroll = false;
                                      //     });
                                      //   });
                                      // }

                                      return Obx(() {
                                        return MyCategoryTile(
                                          padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                                          /* ! Don't remember why this weird improper padding was added but for now, I have commented it ! */
                                          // padding: const EdgeInsets.only(top: 0, left: 4, right: 13),
                                          onTap: () {
                                            catItemController.selectACategory(cat.menuId);
                                            // _scrollIndex = index;
                                          },
                                          name: cat.menuName.trim(),
                                          image: cat.menuImageName,
                                          isSelected: catItemController.selectedMenuIdObx.value == cat.menuId,
                                        );
                                      });
                                    },
                                  );
                          }),
                        ),
                      ),
                      const MyText(text: "Items", align: TextAlign.start, color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, paddingTop: 20),
                      Expanded(
                        child: Obx(() {
                          return !apiController.isLoadingItems.value
                              ? ListView.separated(
                                  itemCount: catItemController.currentCategoryItems.length,
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.only(bottom: 10),
                                  separatorBuilder: (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemBuilder: (BuildContext context, int index) {
                                    MenuItem item = catItemController.currentCategoryItems[index];
                                    return MyItemTile(
                                      onTap: () async {
                                        log(
                                          "--------------- item at "
                                          "$index with name ${item.itemName} "
                                          "tapped  ---------------",
                                        );
                                        catItemController.clearItemVariables();
                                        catItemController.selectItem(item);
                                        showCircularLoading();
                                        await catItemController.getItemDetails();
                                        dismissLoading();
                                        navigate(
                                          type: PageType.to,
                                          page: const ItemDetailsPage(),
                                          // transition: Transition.downToUp,
                                        );
                                      },
                                      name: item.itemName,
                                      description: "${item.itemDescription.capitalize}",
                                      points: item.pointsToPurchase,
                                      price: item.itemCost,
                                      image: item.itemImageName,
                                    );
                                  },
                                )
                              : const Center(child: CircularProgressIndicator(color: AppColors.kLogoBasedColor));
                        }),
                      ),
                    ],
                  )
                : apiController.isLoadingCategories.value
                ? const Center(child: CircularProgressIndicator(color: AppColors.kLogoBasedColor))
                : const Center(child: MyText(text: "No menu available for selected branch", fontSize: 16));
          }),
        ),
      ),
    );
  }
}
