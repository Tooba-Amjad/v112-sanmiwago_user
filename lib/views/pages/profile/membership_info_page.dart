import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/pages/membership_card/membership_cards_info_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class MembershipInfoPage extends StatefulWidget {
  const MembershipInfoPage({Key? key}) : super(key: key);

  @override
  State<MembershipInfoPage> createState() => _MembershipInfoPageState();
}

class _MembershipInfoPageState extends State<MembershipInfoPage> {
  @override
  void initState() {
    membershipController.getMembershipData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        // backgroundColor: AppColors.kGreyColor,
        backgroundColor: AppColors.kSkyLightDullColor,
        appBar: simpleAppBar(
          title: "Membership Info",
          haveBackIcon: true,
          onBackPressed: () {
            Get.back();
          },
        ),
        body: Obx(() {
          return !apiController.isLoadingMembershipDetails.value && membershipController.userMembershipDetails.value.id.isNotEmpty
              // ? authController.userData.value.giftCardMembership == "yes"
              ? MyFormPage(
                  pageTopPadding: Get.height * .09,
                  children: [
                    const MyText(
                      text: "Member Name:",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      paddingBottom: 10,
                      paddingLeft: 15,
                    ),
                    //+ member name
                    MyTextField(
                      hint: "Member Name",
                      isReadOnly: true,
                      controller: membershipController.memberNameController,
                    ),

                    const SizedBox(height: AppSizes.formsSizeBoxHeight),

                    const MyText(
                      text: "Member Card Number:",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      paddingBottom: 10,
                      paddingLeft: 15,
                    ),
                    //+ member card number
                    MyTextField(
                      hint: "Membership Card Number",
                      isReadOnly: true,
                      haveSuffix: true,
                      controller: membershipController.membershipCardController,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.copy_rounded,
                          color: AppColors.kBlackColor,
                        ),
                        onPressed: () async {
                          await membershipController.copyMembershipCard();
                        },
                      ),
                    ),

                    const SizedBox(height: AppSizes.formsSizeBoxHeight),

                    const MyText(
                      text: "Membership Category & Price:",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      paddingBottom: 10,
                      paddingLeft: 15,
                    ),
                    //+ Membership Category & Price
                    MyTextField(
                      hint: "Membership Category & Price",
                      isReadOnly: true,
                      controller: membershipController.membershipCategoryNPriceController,
                    ),

                    const SizedBox(height: AppSizes.formsSizeBoxHeight),

                    const MyText(
                      text: "Discount Percentage:",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      paddingBottom: 10,
                      paddingLeft: 15,
                    ),
                    //+ Discount percentage
                    MyTextField(
                      hint: "Discount Percentage",
                      isReadOnly: true,
                      controller: membershipController.memberDiscountPercentageController,
                    ),

                    const SizedBox(height: AppSizes.formsSizeBoxHeight),

                    const MyText(
                      text: "Membership Date:",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      paddingBottom: 10,
                      paddingLeft: 15,
                    ),
                    //+ Membership date
                    MyTextField(
                      controller: membershipController.membershipDateController,
                      hint: "Birthday (MM/DD)",
                      isReadOnly: true,
                    ),

                    const SizedBox(height: AppSizes.formsSizeBoxHeight),
                    // const SizedBox(height: 5),
                  ],
                )
              : apiController.isLoadingMembershipDetails.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.kLogoBasedColor,
                      ),
                    )
                  : Container(
                      height: Get.height,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        // borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const MyText(
                            text: "You don't have a membership card. Please buy one.",
                            color: AppColors.kWhiteColor,
                            fontSize: 34,
                            align: TextAlign.center,
                          ),
                          const SizedBox(height: AppSizes.formsSizeBoxHeight),
                          MyButton(
                            text: "Buy Membership Card",
                            height: AppSizes.buttonHeight,
                            width: Get.width * .70,
                            padding: 10,
                            marginBottom: 30,
                            color: AppColors.kRedColor,
                            textColor: AppColors.kWhiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            onPressed: () {
                              Get.to(
                                () => const MembershipCardsInfoPage(),
                                transition: Transition.rightToLeftWithFade,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                          ),
                        ],
                      ),
                    );
        }),
      ),
    );
  }
}
