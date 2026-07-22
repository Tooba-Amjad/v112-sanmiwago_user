import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/generated/assets.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/cart/cart_item_widget.dart';
import 'package:sanmiwago_user/views/pages/cart/cart_total_section.dart';
import 'package:sanmiwago_user/views/pages/checkout/checkout_page.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_dialog.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "Cart",
        haveBackIcon: true,
        onBackPressed: () {
          Get.back();
        },
        actions: [
          MyButton(
            width: 150,
            text: "Clear cart",
            color: orderController.cartItems.isNotEmpty ? AppColors.kRedColor : AppColors.kLightRedColor,
            onPressed: () {
              if (orderController.cartItems.isEmpty) return;
              showMyAnimatedDialog(
                context: context,
                child: MyNewConfirmDialog(
                  title: "Clear Cart?",
                  msg: "All items will be removed",
                  rightButtonText: "Clear",
                  leftButtonText: "Cancel",
                  rightButtonWidth: 110,
                  leftButtonWidth: 110,
                  yesOnPressed: () {
                    Navigator.of(context).pop();
                    orderController.clearCart(
                      onSuccess: () {
                        showScaffoldMsg(
                          context: context,
                          msg: "Cart cleared!",
                          isSuccess: true,
                        );
                      },
                    );
                  },
                ),
                // MyConfirmDialog(
                //   msg: "Are you sure you want to clear the cart?",
                //   yesOnPressed: () {
                //     Navigator.of(context).pop();
                //     orderController.clearCart(
                //       onSuccess: () {
                //         showScaffoldMsg(
                //           context: context,
                //           msg: "Cart cleared!",
                //           isSuccess: true,
                //         );
                //       },
                //     );
                //   },
                // ),
              );
            },
          ),
        ],
      ),
      body: Container(
        height: Get.height,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
        child: Obx(() {
          return orderController.cartItems.isNotEmpty
              ? ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: orderController.cartItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          MenuItem cartItem = orderController.cartItems[index];
                          // double totalItemPrice = ((double.tryParse(cartItem.itemCost) ?? 0.0) * cartItem.itemCount) +
                          //     cartItem.options.fold(0.0, (previousValue, element) => previousValue + (double.tryParse(element.price) ?? 0.0)) +
                          //     cartItem.addons.fold(0.0, (previousValue, element) => previousValue + (double.tryParse(element.price) ?? 0.0));
                          return Column(
                            children: [
                              CartItemWidget(
                                index: index,
                                cartItem: cartItem,
                                totalItemPrice: cartItem.totalPrice,
                              ),
                              dividerCommon(height: 0.1)
                            ],
                          );
                        },
                      );
                    }),
                    const SizedBox(height: AppSizes.formsSizeBoxHeight),

                    /**/

                    // Container(
                    //   margin: const EdgeInsets.symmetric(vertical: 5),
                    //   child: dividerCommon(),
                    // ),

                    const CartTotalSection(isFromCart: true),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: dividerCommon(),
                    ),
                    // const SizedBox(height: AppSizes.formsSizeBoxHeight),
                    /* + earn-able points from the order + */
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Visibility(
                    //       visible: "a" == "a",
                    //       child: Container(
                    //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //         decoration: BoxDecoration(
                    //           color: Colors.grey[400],
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         child: const MyText(
                    //           text: "Pts Label Earn",
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.black,
                    //           align: TextAlign.center,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    /* + for showing user points + */
                    // Container(
                    //   margin: const EdgeInsets.symmetric(vertical: 10),
                    //   child: dividerCommon(),
                    // ),
                    /* + Available user points part + */
                    // Row(
                    //   children: [
                    //     orderController.cartItems.isNotEmpty
                    //         ? const MyText(
                    //             text: "Available User Points Label ",
                    //             fontWeight: FontWeight.normal,
                    //             fontSize: 16,
                    //           )
                    //         : const SizedBox(),
                    //   ],
                    // ),

                    /* + points redeem text field part + */
                    // "a" == "a"
                    //     ? "a" == "a"
                    //         // userDetails.type.toLowerCase() == "cashier" && customerInfoProvider.selectedCustomer.clientId.isNotEmpty
                    //         //     ? (provider.onlineCartDetails.pointsApply.isNotEmpty && provider.onlineCartDetails.pointsApply != "0")
                    //         ? Row(
                    //             children: [
                    //               Expanded(
                    //                 child: GestureDetector(
                    //                   onTap: () {},
                    //                   child: Container(
                    //                     padding: const EdgeInsets.symmetric(
                    //                       horizontal: 5,
                    //                       vertical: 5,
                    //                     ),
                    //                     margin: const EdgeInsets.only(bottom: 10, left: 0),
                    //                     height: 45,
                    //                     decoration: BoxDecoration(
                    //                       color: AppColors.kLogoBasedColor,
                    //                       border: Border.all(color: Colors.transparent),
                    //                       borderRadius: BorderRadius.circular(6),
                    //                     ),
                    //                     child: const Center(
                    //                       child: MyText(
                    //                         text: 'Remove points',
                    //                         maxLines: 1,
                    //                         overflow: TextOverflow.ellipsis,
                    //                         style: TextStyle(
                    //                           color: Colors.white,
                    //                           fontSize: 14,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           )
                    //         : Row(
                    //             children: [
                    //               // provider.onlineCartItems.isNotEmpty && provider.loadCartDetailsModel.availablePoints != 0
                    //               "a" == "a"
                    //                   ? Expanded(
                    //                       child: MyTextField(
                    //                         controller: TextEditingController(),
                    //                         validator: (value) {
                    //                           return null;
                    //                         },
                    //                         hint: "Enter Points Here",
                    //                         textInputAction: TextInputAction.next,
                    //                       ),
                    //                     )
                    //                   : const SizedBox(),
                    //
                    //               // const SizedBox(height: AppSizes.formsSizeBoxHeight),
                    //             ],
                    //           )
                    //     : const SizedBox(),

                    /* + Voucher section + */
                    // //(provider.orderTotalModel.voucherType?.isNotEmpty ?? false)
                    // "a" == "a"
                    //     //+ remove voucher button
                    //     ? Row(
                    //         children: [
                    //           Expanded(
                    //             child: GestureDetector(
                    //               onTap: () {},
                    //               child: Container(
                    //                 padding: const EdgeInsets.symmetric(vertical: 5),
                    //                 margin: const EdgeInsets.only(bottom: 20),
                    //                 height: 45,
                    //                 decoration: BoxDecoration(
                    //                   color: AppColors.kLogoBasedColor,
                    //                   border: Border.all(color: Colors.transparent),
                    //                   borderRadius: BorderRadius.circular(6),
                    //                 ),
                    //                 child: const Center(
                    //                   child: MyText(
                    //                     text: 'Remove Voucher',
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     color: Colors.white,
                    //                     fontSize: 14,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       )
                    //     : Row(
                    //         //+ voucher field and button
                    //         children: [
                    //           orderController.cartItems.isNotEmpty
                    //               ? Expanded(
                    //                   child: MyTextField(
                    //                     controller: TextEditingController(),
                    //                     validator: (value) {
                    //                       return null;
                    //                     },
                    //                     hint: "Enter Voucher Here",
                    //                     textInputAction: TextInputAction.next,
                    //                   ),
                    //                 )
                    //               : const SizedBox(),
                    //           //+ voucher button
                    //           orderController.cartItems.isNotEmpty
                    //               ? GestureDetector(
                    //                   onTap: () {},
                    //                   child: Container(
                    //                     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    //                     margin: const EdgeInsets.only(bottom: 20, left: 10),
                    //                     height: 45,
                    //                     decoration: BoxDecoration(
                    //                       color: AppColors.kLogoBasedColor,
                    //                       border: Border.all(color: Colors.transparent),
                    //                       borderRadius: BorderRadius.circular(6),
                    //                     ),
                    //                     child: const Center(
                    //                       child: MyText(
                    //                         text:'Use Voucher',
                    //                         maxLines: 1,
                    //                         overflow: TextOverflow.ellipsis,
                    //                         style: TextStyle(
                    //                           color: Colors.white,
                    //                           fontSize: 14,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 )
                    //               : const SizedBox(),
                    //         ],
                    //       ),
                    /* */
                    //+ Reset and Clear Buttons Row
                    Obx(() {
                      return orderController.cartItems.isNotEmpty
                          ? SizedBox(
                              height: 52,
                              child: MyButton(
                                text: "Proceed to Checkout",
                                // height: 52,
                                width: Get.width - 30,
                                padding: 0,
                                marginBottom: 10,
                                color: AppColors.kGreenColor,
                                onPressed: () async {
                                  //+ handle location
                                  // try {
                                  //   await locationController.determinePosition(context);
                                  //   log("means we got the permission");
                                  // } catch (e) {
                                  //   showScaffoldMsg(context: context, msg: "Location is disabled. Please enable it.");
                                  //   log("error in location: $e");
                                  //   return;
                                  // }
                                  log("Permission for location is granted  ");
                                  showCircularLoading();
                                  // checkoutController.getStates();

                                  log("Proceed to Checkout Button Pressed");
                                  log("now before at click of Go to Checkout is: ${DateTime.now()}");

                                  // if (authController.userData.value.id.isNotEmpty) await apiController.getUserPoints();
                                  // checkoutController.getDiscountedPayableTotal();
                                  // await checkoutController.getIsDeliveryOrderAllowed();
                                  // if (authController.userData.value.id.isNotEmpty) await checkoutController.getUserInfoAndAddressForCheckout();
                                  // await locationController.determinePosition(context, showLoading: false);
                                  final stopwatch = Stopwatch()..start();
                                  await Future.wait(
                                    [
                                      apiController.getUserPoints(),
                                      checkoutController.getIsDeliveryOrderAllowed(),
                                      checkoutController.getUserInfoAndAddressForCheckout(shouldFactorInUserId: true),
                                    ],
                                  );
                                  // locationController.determinePosition(context, showLoading: false);

                                  stopwatch.stop();

                                  log('Execution time of Go to Checkout stopwatch: ${stopwatch.elapsedMilliseconds} ms');
                                  log("now after the await of all three Futures on click of Go to Checkout is: ${DateTime.now()}");

                                  checkoutController.getDiscountedPayableTotal();

                                  dismissLoading();
                                  navigate(type: PageType.to, page: CheckoutPage());
                                },
                              ),
                            )
                          : const SizedBox();
                    }),

                    const SizedBox(height: AppSizes.formsSizeBoxHeight),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.iconsEmptyCartBlack,
                      height: 200,
                      width: 200,
                    ),
                    // const Icon(
                    //   FontAwesomeIcons.cartArrowDown,
                    //   size: 120,
                    // ),
                    Align(
                      alignment: Alignment.center,
                      child: MyText(
                        text: "YOUR CART IS EMPTY",
                        align: TextAlign.center,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 32,
                        paddingTop: 30,
                        paddingBottom: 10,
                      ),
                    ),
                    MyText(
                      text: "Please add some items from the \"Menu\" page to proceed to checkout and place an order with us.",
                      align: TextAlign.center,
                      fontWeight: FontWeight.normal,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.grey,
                      fontSize: 18,
                      // paddingTop: 30,
                      paddingBottom: 30,
                      paddingRight: 15,
                      paddingLeft: 15,
                    ),
                    MyButton(
                      text: "Go To Menu",
                      icon: Icons.arrow_back_ios_rounded,
                      width: Get.width * .6,
                      padding: 0,
                      marginBottom: 10,
                      color: AppColors.kRedColor,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
