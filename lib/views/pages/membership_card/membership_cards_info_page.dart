import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/api_constants.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/membership_models/membership_category_model.dart';
import 'package:sanmiwago_user/views/pages/membership_card/buy_membership_form_page.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class MembershipCardsInfoPage extends StatefulWidget {
  const MembershipCardsInfoPage({Key? key}) : super(key: key);

  @override
  State<MembershipCardsInfoPage> createState() => _MembershipCardsInfoPageState();
}

class _MembershipCardsInfoPageState extends State<MembershipCardsInfoPage> {
  @override
  void initState() {
    membershipController.getMembershipCategories();
    super.initState();
  }

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.kGreyColor,
      backgroundColor: AppColors.kSkyLightDullColor,
      appBar: simpleAppBar(
        title: "Membership Cards",
        haveBackIcon: true,
        onBackPressed: () {
          Get.back();
        },
      ),
      // endDrawer: const MyDrawer(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.center,
              child: MyText(
                text: "Unlock your membership",
                align: TextAlign.center,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 38,
                paddingLeft: 10,
                paddingRight: 10,
                paddingTop: 20,
                paddingBottom: 20,
              ),
            ),
            const MyText(
              text: "Join Sanmiwago GiftCard Membership to avail free food, drinks, and exclusive discount.",
              align: TextAlign.center,
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 24,
              paddingTop: 10,
              paddingBottom: 20,
            ),
            const MyText(
              text: "Select a giftcard membership that's right for you.",
              align: TextAlign.center,
              color: AppColors.kLogoBasedColor,
              fontWeight: FontWeight.normal,
              fontSize: 24,
              paddingBottom: 20,
            ),
            MyButton(
              height: AppSizes.buttonHeight + 10,
              width: Get.width * 0.90,
              text: "Most Popular Cards",
              fontSize: 24,
              color: AppColors.kLogoBasedColor,
              onPressed: () {},
            ),
            const SizedBox(height: 20),
            Obx(() {
              return (!apiController.isLoadingMembershipCategories.value && membershipController.membershipCategories.isNotEmpty)
                  ? SizedBox(
                      height: 550,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          PageView.builder(
                            controller: controller,
                            itemCount: membershipController.membershipCategories.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              MembershipCategory mc = membershipController.membershipCategories[index];
                              return SizedBox(
                                width: Get.width - 10,
                                child: Column(
                                  children: [
                                    MyButton(
                                      height: AppSizes.buttonHeight + 10,
                                      width: Get.width * 0.90,
                                      text: "\$${mc.price}",
                                      fontSize: 24,
                                      color: const Color(0xff393939),
                                      textColor: const Color(0xffD38E22),
                                      onPressed: () {},
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.kWhiteColor,
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              height: 250,
                                              width: Get.width,
                                              imageUrl: "${ApiConstants.baseUrl}/assets/front/images/membership-card.webp",
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
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 20.0, left: 30),
                                                  child: Icon(
                                                    FontAwesomeIcons.check,
                                                    size: 22,
                                                    color: AppColors.kLogoBasedColor,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 20,
                                                child: MyText(
                                                  text: "${mc.percentage}% discount on selected items",
                                                  maxLines: 5,
                                                  overflow: TextOverflow.ellipsis,
                                                  align: TextAlign.center,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  paddingTop: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    MyButton(
                                      height: AppSizes.buttonHeight + 10,
                                      width: Get.width * 0.90,
                                      text: "Buy \$${mc.price} Card",
                                      fontSize: 24,
                                      color: AppColors.kRedColor,
                                      onPressed: () {
                                        membershipController.selectedMembershipCategory = mc;
                                        Get.to(
                                          () => const BuyMembershipFormPage(),
                                          transition: Transition.rightToLeftWithFade,
                                          duration: const Duration(milliseconds: 500),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 210,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                log("tapped rrighttttt ${controller.page}");
                                controller.nextPage(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOutCubic,
                                );
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.kLogoBasedColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 210,
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                log("tapped lefffttttt: ${controller.page}");
                                controller.previousPage(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOutCubic,
                                );
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.kLogoBasedColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : apiController.isLoadingMembershipCategories.value
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 80.0),
                            child: CircularProgressIndicator(
                              color: AppColors.kLogoBasedColor,
                            ),
                          ),
                        )
                      : const Center(
                          child: MyText(
                            text: "No Membership Cards available right now",
                            fontSize: 16,
                            align: TextAlign.center,
                            paddingTop: 30,
                            paddingRight: 60,
                            paddingLeft: 60,
                          ),
                        );
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
