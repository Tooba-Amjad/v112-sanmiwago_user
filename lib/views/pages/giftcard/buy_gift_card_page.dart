import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/gift_card_models/gift_card_model.dart';
import 'package:sanmiwago_user/utils/formatters/us_phone_number_formatter.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class BuyGiftCardPage extends StatelessWidget {
  const BuyGiftCardPage({super.key, required this.controller});

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const MyText(
            text: "Sanmiwago Gift Cards",
            align: TextAlign.center,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            paddingTop: 20,
            paddingBottom: 20,
          ),
          SizedBox(
            height: 320,
            child: Obx(() {
              return (!apiController.isLoadingGiftCards.value && giftCardController.giftCardsList.isNotEmpty)
                  ? Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Obx(() {
                          return PageView.builder(
                            controller: controller,
                            itemCount: giftCardController.giftCardsList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              GiftCard gc = giftCardController.giftCardsList[index];
                              // log("gc.image : ${gc.itemImageName}");
                              return GestureDetector(
                                onTap: () {
                                  giftCardController.isCardSelected.value = true;
                                  giftCardController.selectedCardId = gc.itemId;
                                  giftCardController.selectedCardImage = gc.itemImageName;
                                  giftCardController.clearAllControllers();

                                  giftCardController.buyGiftCardSenderNameController.text = authController.userData.value.username;
                                  giftCardController.buyGiftCardSenderEmailController.text = authController.userData.value.email;
                                  giftCardController.buyGiftCardSenderPhoneController.text =
                                      formatUsPhoneNumber(authController.userData.value.phone) ?? authController.userData.value.phone;

                                  giftCardController.isPaymentStripeSelected.value = false;
                                  if (authController.userData.value.id.isNotEmpty) {
                                    showMsg(
                                      msg:
                                          "Some fields were filled with "
                                          "your profile data for your ease. "
                                          "You can edit them if you want.",
                                      isSuccess: true,
                                      time: const Duration(seconds: 3),
                                    );
                                  }
                                },
                                child: SizedBox(
                                  width: Get.width - 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.kWhiteColor),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            height: 250,
                                            width: Get.width,
                                            imageUrl: gc.itemImageName,
                                            progressIndicatorBuilder: (context, url, progress) {
                                              return MyCachedImageLoadingBuilder(height: 200, width: Get.width, loadingProgress: progress.progress ?? 0);
                                            },
                                            errorWidget: (context, url, error) => MyImageErrorBuilder(height: 200, width: Get.width),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MyText(
                                                text: gc.itemName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                align: TextAlign.center,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                paddingTop: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        Positioned(
                          top: 150,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              log("tapped rrighttttt ${controller.page}");
                              controller.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(color: AppColors.kLogoBasedColor, borderRadius: BorderRadius.circular(30)),
                              child: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 150,
                          left: 0,
                          child: GestureDetector(
                            onTap: () {
                              log("tapped lefffttttt: ${controller.page}");
                              controller.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(color: AppColors.kLogoBasedColor, borderRadius: BorderRadius.circular(30)),
                              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                            ),
                          ),
                        ),
                      ],
                    )
                  : apiController.isLoadingGiftCards.value
                  ? const Center(child: CircularProgressIndicator(color: AppColors.kLogoBasedColor))
                  : const Center(child: MyText(text: "No GiftCards to show right now", fontSize: 16));
            }),
          ),
          const SizedBox(height: 40),

          /* +++ COMMENTING THIS PART TO GET A BUILD WITHOUT THESE SECTIONS +++ */
          /* + Membership Section + */

          // Column(
          //   children: <Widget>[
          //     const MyText(
          //       text: "Apply",
          //       align: TextAlign.center,
          //       color: Colors.black,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 36,
          //       paddingBottom: 0,
          //     ),
          //     const MyText(
          //       text: "GIFTCARD \n MEMBERSHIP",
          //       align: TextAlign.center,
          //       color: AppColors.kLogoBasedColor,
          //       fontWeight: FontWeight.bold,
          //       height: 1,
          //       fontSize: 36,
          //       paddingBottom: 20,
          //     ),
          //     Obx(() {
          //       return ClipRRect(
          //         borderRadius: BorderRadius.circular(20),
          //         child: BeforeAfter(
          //           value: giftCardController.beforeAfterValue.value,
          //           before: Image.asset(Assets.imagesAfter),
          //           after: Image.asset(Assets.imagesBefore),
          //           thumbColor: AppColors.kLogoBasedColor,
          //           trackColor: AppColors.kLogoBasedColor,
          //           onValueChanged: (value) {
          //             giftCardController.beforeAfterValue.value = value;
          //             // setState(() => this.value = value);
          //           },
          //         ),
          //       );
          //     }),
          //     const SizedBox(height: 20),
          //     Obx(() {
          //       return MyButton(
          //         height: AppSizes.buttonHeight,
          //         width: Get.width * 0.80,
          //         text: "Become A Member 👉",
          //         color: authController.userData.value.giftCardMembership == "yes" ? Colors.red[300] : AppColors.kRedColor,
          //         onPressed: () {
          //           //+ navigate to membership page
          //           if (authController.userData.value.giftCardMembership != "yes") {
          //             Get.to(
          //               () => const MembershipCardsInfoPage(),
          //               transition: Transition.rightToLeftWithFade,
          //               duration: const Duration(milliseconds: 500),
          //             );
          //           } else {
          //             showMsg(
          //               msg: "You have already bought a membership card. Go to your profile to view your membership details.",
          //               time: const Duration(seconds: 4),
          //             );
          //           }
          //         },
          //       );
          //     }),
          //   ],
          // ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
