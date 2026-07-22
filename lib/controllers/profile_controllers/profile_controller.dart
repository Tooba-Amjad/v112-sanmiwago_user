import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';

import '../../utils/helpers.dart';
import '../../utils/formatters/us_phone_number_formatter.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find<ProfileController>();

  final GlobalKey<FormState> updateProfileFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController referralIdController = TextEditingController();

  final TextEditingController referralLinkController = TextEditingController();
  final TextEditingController shoppingLinkController = TextEditingController();

  File? profileImage;
  RxString selectedProfileImagePath = "".obs;

  profileDataInitialization() {
    firstNameController.text = authController.userData.value.firstName;
    lastNameController.text = authController.userData.value.lastName;
    emailController.text = authController.userData.value.email;
    phoneController.text =
        formatUsPhoneNumber(removeDirectionalFormatting(authController.userData.value.phone)) ?? removeDirectionalFormatting(authController.userData.value.phone);
    referralIdController.text = authController.userData.value.referralCode;

    shoppingLinkController.text = "${authController.userData.value.shareLinkBaseurl}${authController.userData.value.referralCode}";
    referralLinkController.text = "${authController.userData.value.referralLinkBaseurl}${authController.userData.value.referralCode}";
  }

  updateProfileData() {
    // Compare normalized phone numbers for accurate comparison
    final normalizedControllerPhone = normalizeUsPhoneNumber(phoneController.text.trim()) ?? "";
    final normalizedUserDataPhone = normalizeUsPhoneNumber(authController.userData.value.phone.trim()) ?? "";

    if (firstNameController.text.trim() == authController.userData.value.firstName.trim() &&
        lastNameController.text.trim() == authController.userData.value.lastName.trim() &&
        normalizedControllerPhone == normalizedUserDataPhone) {
      showMsg(msg: "No changes have been made yet.");
    } else {
      apiController.updateProfile();
    }
  }

  copyReferralCode() async {
    await Clipboard.setData(ClipboardData(text: referralIdController.text.trim()));
    showMsg(msg: "Member Id / Referral Code Copied ", isSuccess: true);
  }

  copyReferralLink() async {
    await Clipboard.setData(ClipboardData(text: referralLinkController.text.trim()));
    showMsg(msg: "Referral Link Copied ", isSuccess: true);
  }

  copyShoppingLink() async {
    await Clipboard.setData(ClipboardData(text: shoppingLinkController.text.trim()));
    showMsg(msg: "Shopping Link Copied ", isSuccess: true);
  }

  Future<void> getProfileImageFromStorageAndUpdate({VoidCallback? onStart, VoidCallback? onSuccess}) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage = File(image.path);
      selectedProfileImagePath.value = image.path;
      await apiController.updateProfileImage(onSuccess: onSuccess, onStart: onStart);
    }
  }
}
