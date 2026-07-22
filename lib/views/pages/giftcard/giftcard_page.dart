import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/pages/giftcard/buy_gift_card_form.dart';
import 'package:sanmiwago_user/views/pages/giftcard/buy_gift_card_page.dart';
import 'package:sanmiwago_user/views/pages/giftcard/check_gift_card_balance_form.dart';
import 'package:sanmiwago_user/views/pages/giftcard/recover_gift_card_form.dart';
import 'package:sanmiwago_user/views/pages/giftcard/recovered_gift_card_data.dart';
import 'package:sanmiwago_user/views/pages/giftcard/reload_gift_card_form.dart';
import 'package:sanmiwago_user/views/widgets/my_drawer.dart';
import 'package:sanmiwago_user/views/widgets/my_giftcard_tab_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class GiftCardPage extends StatefulWidget {
  const GiftCardPage({super.key, this.reload = true});

  final bool reload;

  @override
  State<GiftCardPage> createState() => _GiftCardPageState();
}

class _GiftCardPageState extends State<GiftCardPage> {
  @override
  void initState() {
    giftCardController.selectedMenu.value = giftCardController.menus[0];
    giftCardController.isCardSelected.value = false;
    super.initState();
  }

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.kGreyColor,
      backgroundColor: AppColors.kSkyLightDullColor,
      appBar: simpleAppBar(
        title: "Gift Card Store",
        haveBackIcon: true,
        onBackPressed: () {
          if (giftCardController.isCardSelected.value && giftCardController.selectedMenu.value == giftCardController.menus[0]) {
            giftCardController.isCardSelected.value = false;
            giftCardController.clearAllControllers();
          } else {
            Get.back();
            giftCardController.isCardSelected.value = false;
          }
        },
      ),
      // drawer: const MyDrawer(),
      body: Column(
        children: [
          //+ top buttons section
          IntrinsicHeight(
            child: Container(
              // height: (giftCardController.selectedMenu.value == giftCardController.menus[0] && giftCardController.isCardSelected.value == false) ? 200 : 80,
              color: const Color(0xffff7925),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: AppSizes.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return giftCardController.selectedMenu.value == giftCardController.menus[0] && giftCardController.isCardSelected.value == false
                        ? const Align(
                            child: MyText(
                              text: "Give the Perfect Gift",
                              align: TextAlign.center,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              paddingBottom: 10,
                            ),
                          )
                        : const SizedBox();
                  }),
                  Obx(() {
                    return giftCardController.selectedMenu.value == giftCardController.menus[0] && giftCardController.isCardSelected.value == false
                        ? const Align(
                            alignment: Alignment.center,
                            child: MyText(
                              text: "Get a Voucher for Yourself or Gift one to a Friend",
                              align: TextAlign.center,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              paddingBottom: 10,
                            ),
                          )
                        : const SizedBox();
                  }),
                  SizedBox(
                    height: 40,
                    width: Get.width,
                    child: Wrap(
                      direction: Axis.horizontal,
                      clipBehavior: Clip.none,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          height: 35,
                          child: Obx(() {
                            return MyGiftcardTabTile(
                              padding: const EdgeInsets.fromLTRB(5, 7, 5, 5),
                              borderColor: Colors.transparent,
                              selectedColor: AppColors.kBlackColor,
                              borderRadius: 30,
                              onTap: () {
                                giftCardController.selectMenu(giftCardController.menus[0]);
                              },
                              name: giftCardController.menus[0],
                              isSelected: giftCardController.selectedMenu.value == giftCardController.menus[0],
                            );
                          }),
                        ),
                        SizedBox(
                          height: 35,
                          child: Obx(() {
                            return MyGiftcardTabTile(
                              padding: const EdgeInsets.fromLTRB(5, 7, 5, 5),
                              borderColor: Colors.transparent,
                              selectedColor: AppColors.kBlackColor,
                              borderRadius: 30,
                              onTap: () {
                                giftCardController.selectMenu(giftCardController.menus[1]);
                              },
                              name: giftCardController.menus[1],
                              isSelected: giftCardController.selectedMenu.value == giftCardController.menus[1],
                            );
                          }),
                        ),
                        SizedBox(
                          height: 35,
                          child: Obx(() {
                            return MyGiftcardTabTile(
                              padding: const EdgeInsets.fromLTRB(5, 7, 5, 5),
                              borderColor: Colors.transparent,
                              selectedColor: AppColors.kBlackColor,
                              borderRadius: 30,
                              onTap: () {
                                giftCardController.selectMenu(giftCardController.menus[2]);
                                giftCardController.clearAllControllers();
                              },
                              name: giftCardController.menus[2],
                              isSelected: giftCardController.selectedMenu.value == giftCardController.menus[2] ||
                                  giftCardController.selectedMenu.value == giftCardController.menus[3],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (giftCardController.selectedMenu.value == giftCardController.menus[0] && giftCardController.isCardSelected.value == false) {
                //+ Buy gift card page
                return BuyGiftCardPage(controller: controller);
              } else if (giftCardController.selectedMenu.value == giftCardController.menus[0] && giftCardController.isCardSelected.value == true) {
                //+ Buy Gift Card form
                return const BuyGiftCardForm();
              } else if (giftCardController.selectedMenu.value == giftCardController.menus[1]) {
                //+ Reload card form
                return const ReloadGiftCardForm();
              } else if (giftCardController.selectedMenu.value == giftCardController.menus[3]) {
                //+ Recover Gift Card form
                return const RecoverGiftCardForm();
              } else if (giftCardController.selectedMenu.value == giftCardController.menus[4]) {
                //+ Recovered Gift Card Data
                return const RecoveredGiftCardData();
              } else {
                //+ Check balance form
                return const CheckGiftCardBalanceForm();
              }
            }),
          ),
        ],
      ),
    );
  }
}
