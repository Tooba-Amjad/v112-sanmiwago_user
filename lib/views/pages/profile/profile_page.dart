import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_images.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

import '../../../utils/formatters/us_phone_number_formatter.dart';
import '../../../utils/snack_bar.dart';
import '../../../utils/validators/us_phone_number_validator.dart';
import '../../widgets/my_dialog.dart';

class MyProfilePage extends StatefulWidget {
  final BuildContext preContext;

  const MyProfilePage({super.key, required this.preContext});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  void initState() {
    super.initState();

    profileController.profileDataInitialization();
  }

  @override
  Widget build(BuildContext context) {
    log("authController.userData.value.photo: ${authController.userData.value.photo}");
    return Scaffold(
      appBar: simpleAppBar(
        title: "My Profile",
        haveBackIcon: true,
      ),
      body: Form(
        key: profileController.updateProfileFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: MyFormPage(
          pageTopPadding: Get.height * 0.07,
          children: [
            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  await profileController.getProfileImageFromStorageAndUpdate(
                    onStart: () {
                      showScaffoldMsg(context: widget.preContext, msg: "Uploading image.....", isSuccess: true);
                    },
                    onSuccess: () {
                      showScaffoldMsg(context: widget.preContext, msg: "Image updated successfully.", isSuccess: true);
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.kLogoBasedColor,
                  // backgroundImage: const AssetImage(AppImages.userIcon),
                  child: authController.userData.value.photo.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Obx(() {
                            return Image.network(
                              authController.userData.value.photo,
                              height: 95,
                              width: 95,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return MyImageLoadingBuilder(
                                  height: 40,
                                  width: 40,
                                  color: AppColors.kWhiteColor,
                                  loadingProgress: loadingProgress,
                                );
                              },
                              errorBuilder: (context, url, error) => MyImageErrorBuilder(
                                height: 40,
                                width: 40,
                                widget: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    AppImages.userIcon,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                              fit: BoxFit.fill,
                            );
                          }),
                        )
                      : Image.asset(
                          AppImages.userIcon,
                          height: 40,
                          width: 40,
                        ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ first name
            const MyText(
              text: "First Name",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              paddingLeft: 15,
              paddingTop: 0,
              paddingBottom: 5,
            ),
            MyTextField(
              hint: "",
              controller: profileController.firstNameController,
              keyboardType: TextInputType.name,
              autoFillHints: const [AutofillHints.name],
              validator: (String? value) {
                if ((value?.isEmpty ?? true) == true) {
                  return "First Name is required";
                }
                return null;
              },
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ last name
            const MyText(
              text: "Last Name",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              paddingLeft: 15,
              paddingTop: 0,
              paddingBottom: 5,
            ),
            MyTextField(
              hint: "Last Name",
              controller: profileController.lastNameController,
              keyboardType: TextInputType.name,
              autoFillHints: const [AutofillHints.name],
              validator: (String? value) {
                if ((value?.isEmpty ?? true) == true) {
                  return "Last Name is required";
                }
                return null;
              },
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ email
            const MyText(
              text: "Email",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              paddingLeft: 15,
              paddingTop: 0,
              paddingBottom: 5,
            ),
            MyTextField(
              hint: "Email",
              isReadOnly: true,
              controller: profileController.emailController,
              // keyboardType: TextInputType.emailAddress,
              // autoFillHints: const [AutofillHints.email],
              validator: (String? value) {
                if (value?.isEmpty == true) {
                  return "Email is required";
                } else if (!GetUtils.isEmail(value?.trim() ?? "")) {
                  return "Please enter a valid email address";
                }
                return null;
              },
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ phone
            const MyText(
              text: "Phone No",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              paddingLeft: 15,
              paddingTop: 0,
              paddingBottom: 5,
            ),
            MyTextField(
              hint: "Phone No",
              controller: profileController.phoneController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autoFillHints: const [
                AutofillHints.telephoneNumber,
                AutofillHints.telephoneNumberDevice,
                AutofillHints.telephoneNumberLocal,
                AutofillHints.telephoneNumberNational,
              ],

              inputFormatters: [
                LengthLimitingTextInputFormatter(14),
                FilteringTextInputFormatter.digitsOnly,
                UsNumberTextInputFormatter(),
              ],
              validator: (String? val) {
                String value = val ?? "";
                final usPhoneValidity = validateUsPhoneNumber(value);
                authController.isNumValid.value = (usPhoneValidity == null);

                return usPhoneValidity;

                // if (value.isEmpty == true) {
                //   return "Phone No is required";
                // } else if (!value.isNumericOnly) {
                //   return 'Please enter a valid digit only phone number';
                // } else if (value.trim().length != 10) {
                //   return 'Please enter your 10 digit phone number';
                // }
                // // else if (!GetUtils.isPhoneNumber(value?.trim() ?? "")) {
                // //   return "Please enter a valid email address";
                // // }
                // return null;
              },
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ Member Id
            const MyText(
              text: "Member Id",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              paddingLeft: 15,
              paddingTop: 0,
              paddingBottom: 5,
            ),
            MyTextField(
              isReadOnly: true,
              hint: "Member Id",
              controller: profileController.referralIdController,
              haveSuffix: true,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.copy_rounded,
                  color: AppColors.kGreyColor,
                ),
                onPressed: () async {
                  // authController.loading.value = true;
                  await profileController.copyReferralCode();
                  // authController.loading.value = false;
                },
              ),
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ update button
            Center(
              child: SizedBox(
                width: Get.width * .40,
                child: Obx(() {
                  return MyButton(
                    text: "Update",
                    // icon: Icons.arrow_back_ios_rounded,
                    // padding: 0,
                    // marginBottom: 10,
                    color: apiController.isUpdatingProfile.value ? AppColors.kGreenColor : AppColors.kRedColor,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      profileController.updateProfileData();
                    },
                  );
                }),
              ),
            ),

            //+ => COMMENTED BY ALLAN On 27 October 2024
            //+ => UN-COMMENTED On 19-Jan-2025
            //+ start referring text
            const Center(
              child: MyText(
                text: "Start referring to your friends",
                align: TextAlign.center,
                fontSize: 28,
                paddingTop: 20,
                paddingBottom: 20,
                paddingLeft: 20,
                paddingRight: 20,
              ),
            ),

            //+ referral link field
            MyTextField(
              hint: "Referral link",
              isReadOnly: true,
              maxLines: 2,
              controller: profileController.referralLinkController,
              validator: (String? value) {
                return null;
              },
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ copy link button
            Center(
              child: SizedBox(
                width: Get.width * .40,
                // height: 45,
                child: MyButton(
                  text: "Copy Link",
                  fontSize: 16,
                  // padding: 0,
                  // marginBottom: 10,
                  color: AppColors.kRedColor,
                  onPressed: () {
                    profileController.copyReferralLink();
                  },
                ),
              ),
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            dividerCommon(),

            //+ OR
            const Center(
              child: MyText(
                text: "OR",
                align: TextAlign.center,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                paddingTop: 30,
                paddingBottom: 0,
                paddingLeft: 20,
                paddingRight: 20,
              ),
            ),

            //+ scan qr text
            const Center(
              child: MyText(
                text: "Scan QR Code For Referral Link",
                align: TextAlign.center,
                fontSize: 18,
                paddingTop: 20,
                paddingBottom: 20,
                paddingLeft: 20,
                paddingRight: 20,
              ),
            ),

            //+ here comes the QR.
            Center(
              child: QrImageView(
                data: profileController.referralLinkController.text.trim(),
                version: QrVersions.auto,
                size: 100.0,
              ),
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            dividerCommon(height: 5, thickness: 10, color: AppColors.kBlackColor),

            /*//! ------------------------ SHOPPING LINK SECTION ---------------------------*/

            //+ shopping link text
            const Center(
              child: MyText(
                text: "Shopping Share Link",
                align: TextAlign.center,
                fontSize: 28,
                paddingTop: 20,
                paddingBottom: 20,
                paddingLeft: 20,
                paddingRight: 20,
              ),
            ),

            //+ shopping link field
            MyTextField(
              hint: "Shopping link",
              isReadOnly: true,
              maxLines: 2,
              controller: profileController.shoppingLinkController,
              validator: (String? value) {
                return null;
              },
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ copy link button
            Center(
              child: SizedBox(
                width: Get.width * .40,
                child: MyButton(
                  text: "Copy Link",
                  fontSize: 16,
                  // padding: 0,
                  // marginBottom: 10,
                  color: AppColors.kRedColor,
                  onPressed: () {
                    profileController.copyShoppingLink();
                  },
                ),
              ),
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),

            dividerCommon(),

            //+ OR
            const Center(
              child: MyText(
                text: "OR",
                align: TextAlign.center,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                paddingTop: 30,
                paddingBottom: 0,
                paddingLeft: 20,
                paddingRight: 20,
              ),
            ),

            //+ scan qr text
            const Center(
              child: MyText(
                text: "Scan QR Code For Item Share Link",
                align: TextAlign.center,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                paddingTop: 20,
                paddingBottom: 20,
                paddingLeft: 20,
                paddingRight: 20,
              ),
            ),

            //+ here comes the QR.
            Center(
              child: QrImageView(
                data: profileController.shoppingLinkController.text.trim(),
                version: QrVersions.auto,
                size: 100.0,
              ),
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),
          ],
        ),
      ),
      bottomNavigationBar: MyButton(
        color: AppColors.kRedColor,
        textColor: AppColors.kWhiteColor,
        height: 60,
        marginTop: 5,
        marginBottom: 5,
        marginRight: 5,
        marginLeft: 5,
        text: "Delete Account",
        onPressed: () {
          showMyAnimatedDialog(
            context: context,
            child: MyConfirmDialog(
              msg: "Are you sure you want to delete all your data from our servers?",
              yesOnPressed: () async {
                // Navigator.of(context).pop();
                showCircularLoading();
                try {
                  await apiController.deleteUserAccount();
                  // dismissLoading();
                } catch (e) {
                  dismissLoading();
                  showMsg(msg: "Your data couldn't be deleted for some unknown reason. Please try again in some time.");
                  log("error in deleting user account: $e");
                }
              },
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: AppColors.kWhiteColor,
            ),
            MyText(
              text: "Delete Account",
              maxLines: 1,
              align: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              color: AppColors.kWhiteColor,
              fontWeight: AppSizes.buttonFontWeight,
              fontSize: AppSizes.buttonFontSize,
              paddingLeft: 5,
            ),
          ],
        ),
      ),
    );
  }
}
