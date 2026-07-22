import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/gift_card_models/gift_card_details_model.dart';
import 'package:sanmiwago_user/views/pages/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:sanmiwago_user/views/pages/home/home_menu_page.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_listtile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class GiftCardHistoryPage extends StatefulWidget {
  const GiftCardHistoryPage({super.key});

  @override
  State<GiftCardHistoryPage> createState() => _GiftCardHistoryPageState();
}

class _GiftCardHistoryPageState extends State<GiftCardHistoryPage> {
  ExpandableController redeemHistory = ExpandableController(initialExpanded: false);
  ExpandableController reloadHistory = ExpandableController(initialExpanded: false);
  ExpandableController refundHistory = ExpandableController(initialExpanded: false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        giftCardController.checkBalanceGiftPinController.clear();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.kSkyLightDullColor,
        appBar: simpleAppBar(
          title: "GiftCard Details",
          haveBackIcon: true,
          onBackPressed: () {
            Get.back();
            giftCardController.checkBalanceGiftPinController.clear();
          },
        ),
        body: MyFormPage(
          pageTopPadding: Get.height * 0.05,
          children: [
            const Align(
              alignment: Alignment.center,
              child: MyText(
                text: "SANMIWAGO GIFTCARD",
                align: TextAlign.center,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 26,
                paddingTop: 20,
                paddingBottom: 10,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  height: 230,
                  width: Get.width,
                  imageUrl: giftCardController.myGiftCardDetails.value.data?.items?.itemImageName ?? "",
                  // imageUrl: "https://sanmiwagodumpling.com/uploads/gift_item/gift_item_68.webp",
                  progressIndicatorBuilder: (context, url, progress) {
                    return MyCachedImageLoadingBuilder(
                      height: 200,
                      width: Get.width,
                      loadingProgress: progress.progress ?? 0,
                    );
                  },
                  errorWidget: (context, url, error) => MyImageErrorBuilder(
                    height: 200,
                    width: Get.width,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            //+ total amount in gift card
            Align(
              alignment: Alignment.center,
              child: MyText(
                text: "\$${giftCardController.myGiftCardDetails.value.data?.totalAmount ?? "0.0"}",
                align: TextAlign.center,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                paddingTop: 20,
                paddingBottom: 5,
              ),
            ),

            //+ current balance text
            const Align(
              alignment: Alignment.center,
              child: MyText(
                text: "CURRENT BALANCE",
                align: TextAlign.center,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                // paddingTop: 20,
                paddingBottom: 10,
              ),
            ),

            //+ shop online / Go to menu button
            Align(
              alignment: Alignment.center,
              child: MyButton(
                height: AppSizes.buttonHeight,
                width: Get.width * 0.50,
                text: "SHOP ONLINE",
                color: AppColors.kRedColor,
                onPressed: () {
                  Get.offAll(
                    () => !authController.isLoggedIn.value ? const BottomNavBarPage() : const BottomNavBarPage(),
                    // () => !authController.isLoggedIn.value ? const HomeMenuPage() : const BottomNavBarPage(),
                    transition: Transition.rightToLeftWithFade,
                    duration: const Duration(milliseconds: 500),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            dividerCommon(height: 5, thickness: 5, color: AppColors.kGreenColor),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ here comes the QR.
            Center(
              child: QrImageView(
                data: giftCardController.myGiftCardDetails.value.data?.giftCardNo ?? "Not available",
                version: QrVersions.auto,
                size: 100.0,
              ),
            ),

            //+ gift card no. field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
              child: MyTextField(
                hint: "Gift Card No.",
                textAlign: TextAlign.center,
                isReadOnly: true,
                controller: giftCardController.checkBalanceGiftCardController,
                validator: (String? value) {
                  return null;
                },
              ),
            ),

            //+ copy link button
            Align(
              alignment: Alignment.center,
              child: MyButton(
                height: AppSizes.buttonHeight,
                width: Get.width * 0.40,
                text: "Copy Code",
                color: AppColors.kRedColor,
                onPressed: () {
                  giftCardController.copyGiftCardCode(giftCardController.myGiftCardDetails.value.data?.giftCardNo ?? "");
                },
              ),
            ),

            // const SizedBox(height: AppSizes.formsSizeBoxHeight),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            dividerCommon(height: 5, thickness: 5, color: AppColors.kGreenColor),
            const SizedBox(height: AppSizes.formsSizeBoxHeight * 2),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  //+ email row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.email),
                      MyText(
                        text: giftCardController.myGiftCardDetails.value.data?.senderEmail ?? "0.0",
                        align: TextAlign.center,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        paddingLeft: 10,
                        // paddingTop: 20,
                        paddingBottom: 0,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),

                  //+ phone row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.phone),
                      MyText(
                        text: giftCardController.myGiftCardDetails.value.data?.senderPhone ?? "0.0",
                        align: TextAlign.center,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        paddingLeft: 10,
                        // paddingTop: 20,
                        paddingBottom: 0,
                      ),
                    ],
                  ),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: "Transaction History:",
                      align: TextAlign.left,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      paddingLeft: 10,
                      paddingTop: 20,
                      paddingBottom: 0,
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: "Purchased for: \$${giftCardController.myGiftCardDetails.value.data?.cardAmount ?? "0.0"}",
                      align: TextAlign.left,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      paddingLeft: 10,
                      paddingTop: 5,
                      paddingBottom: 0,
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: "Dated: ${giftCardController.myGiftCardDetails.value.data?.dateCreated != null ? AppConstants.dateFormatWithTime.format(DateTime.parse(giftCardController.myGiftCardDetails.value.data?.dateCreated ?? DateTime.now().toIso8601String())) : ""}",
                      align: TextAlign.left,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      paddingLeft: 10,
                      // paddingTop: 5,
                      paddingBottom: 0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            dividerCommon(height: 5, thickness: 5, color: AppColors.kGreenColor),
            const SizedBox(height: AppSizes.formsSizeBoxHeight * 2),

            //+ Redeem History Expandable
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(),
              child: ExpandablePanel(
                controller: redeemHistory,
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
                        text: "Redeem History",
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
                expanded: ListView.builder(
                  itemCount: giftCardController.myGiftCardDetails.value.redeemHistory.length,
                  shrinkWrap: true,
                  // reverse: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    RedeemHistory rh = giftCardController.myGiftCardDetails.value.redeemHistory[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: AppColors.kSkyLightDullColor, width: 2)),
                      child: MyListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        title: MyText(
                          text: "${rh.message.capitalizeFirst} for invoice #${rh.invoiceNumber}", // order: ${rh.orderId}",
                          maxLines: 2,
                          fontSize: 16,
                        ),
                        subtitle: MyText(
                          text: rh.dateTime.isNotEmpty ? AppConstants.dateFormatWithTime.format(DateTime.tryParse(rh.dateTime) ?? DateTime.now()) : "",
                          // text: rh.dateTime,
                          fontSize: 14,
                          color: AppColors.kLightGreyColor,
                        ),
                        trailing: MyText(
                          text: "\$${rh.redeemAmount}",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        trailingTopPadding: 25,
                      ),
                    );
                  },
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

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ Reload History Expandable
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(),
              child: ExpandablePanel(
                controller: reloadHistory,
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
                        text: "Reload History",
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
                expanded: ListView.builder(
                  itemCount: giftCardController.myGiftCardDetails.value.reloadAmount.length,
                  shrinkWrap: true,
                  // reverse: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    ReloadAmount rA = giftCardController.myGiftCardDetails.value.reloadAmount[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: AppColors.kSkyLightDullColor, width: 2)),
                      child: MyListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        title: const MyText(
                          text: "Amount Reloaded",
                          fontSize: 16,
                        ),
                        subtitle: MyText(
                          text: rA.dateCreated.isNotEmpty ? AppConstants.dateFormatWithTime.format(DateTime.tryParse(rA.dateCreated) ?? DateTime.now()) : "",
                          fontSize: 14,
                          color: AppColors.kLightGreyColor,
                        ),
                        trailing: MyText(
                          text: "\$${rA.reloadAmount}",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        trailingTopPadding: 15,
                      ),
                    );
                  },
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

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ Refund History Expandable
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(),
              child: ExpandablePanel(
                controller: refundHistory,
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
                        text: "Refund History",
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
                expanded: ListView.builder(
                  itemCount: giftCardController.myGiftCardDetails.value.refundHistory.length,
                  shrinkWrap: true,
                  // reverse: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    RefundHistory rfh = giftCardController.myGiftCardDetails.value.refundHistory[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: AppColors.kSkyLightDullColor, width: 2)),
                      child: MyListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        title: MyText(
                          text: "${rfh.message.capitalizeFirst} for invoice #${rfh.invoiceNumber}", //  order: ${rfh.orderId}",
                          // text: "Amount Refunded",
                          fontSize: 16,
                        ),
                        subtitle: MyText(
                          text: rfh.dateTime.isNotEmpty ? AppConstants.dateFormatWithTime.format(DateTime.tryParse(rfh.dateTime) ?? DateTime.now()) : "",
                          // text: rh.dateTime,
                          fontSize: 14,
                          color: AppColors.kLightGreyColor,
                        ),
                        trailing: MyText(
                          text: "\$${rfh.refundAmount}",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        trailingTopPadding: 15,
                      ),
                    );
                  },
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
        bottomNavigationBar: Row(
          children: [
            Expanded(
              flex: 1,
              child: MyButton(
                height: AppSizes.buttonHeight,
                text: "Cancel",
                color: AppColors.kRedColor,
                onPressed: () {
                  giftCardController.checkBalanceGiftPinController.clear();
                  Get.back();
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: MyButton(
                height: AppSizes.buttonHeight,
                text: "Add More Funds",
                fontSize: 16,
                color: AppColors.kGreenColor,
                onPressed: () {
                  giftCardController.selectMenu(giftCardController.menus[1]);
                  giftCardController.reloadGiftCardController.text = giftCardController.myGiftCardDetails.value.data?.giftCardNo ?? "";
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
