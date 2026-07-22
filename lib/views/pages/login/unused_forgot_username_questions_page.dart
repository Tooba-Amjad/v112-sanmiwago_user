// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sanmiwago_user/constants/app_colors.dart';
// import 'package:sanmiwago_user/constants/app_sizes.dart';
// import 'package:sanmiwago_user/constants/controller_instances.dart';
// import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
// import 'package:sanmiwago_user/views/widgets/my_button.dart';
// import 'package:sanmiwago_user/views/widgets/my_text.dart';
// import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
// import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';
//
// class ForgotUsernameQuestionsPage extends StatelessWidget {
//   const ForgotUsernameQuestionsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         authController.forgotUsernameEmailCont.clear();
//         authController.forgotUsernameAnswer1Controller.clear();
//         authController.forgotUsernameAnswer2Controller.clear();
//         return true;
//       },
//       child: Scaffold(
//         // backgroundColor: AppColors.kGreyColor,
//         backgroundColor: AppColors.kSkyLightDullColor,
//         appBar: simpleAppBar(
//           title: "Forgot Username Step 2",
//           haveBackIcon: true,
//           onBackPressed: () {
//             Get.back();
//             authController.forgotUsernameEmailCont.clear();
//             authController.forgotUsernameAnswer1Controller.clear();
//             authController.forgotUsernameAnswer2Controller.clear();
//           },
//         ),
//         body: Form(
//           key: authController.forgotUsernameStep2FormKey,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           child: MyFormPage(
//             pageTopPadding: Get.height * .25,
//             children: [
//               MyText(
//                 text: authController.forgotUsernameSecurityQuestion1.replaceAll("_", " ").capitalize,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 paddingBottom: 10,
//                 paddingLeft: 15,
//               ),
//               MyTextField(
//                 hint: "Security Question One Answer",
//                 controller: authController.forgotUsernameAnswer1Controller,
//                 validator: (String? value) {
//                   if (value?.isEmpty == true) {
//                     return "Security Question One Answer is required";
//                   }
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: AppSizes.formsSizeBoxHeight),
//               authController.forgotUsernameSecurityQuestion2.isNotEmpty
//                   ? MyText(
//                 text: authController.forgotUsernameSecurityQuestion2.replaceAll("_", " ").capitalize,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 paddingBottom: 10,
//                 paddingLeft: 15,
//               )
//                   : const SizedBox(),
//               authController.forgotUsernameSecurityQuestion2.isNotEmpty
//                   ? MyTextField(
//                 hint: "Security Question Two Answer",
//                 controller: authController.forgotUsernameAnswer2Controller,
//                 validator: (String? value) {
//                   if (value?.isEmpty == true) {
//                     return "Security Question Two Answer is required";
//                   }
//                   return null;
//                 },
//               )
//                   : const SizedBox(),
//               authController.forgotUsernameSecurityQuestion2.isNotEmpty
//                   ? const SizedBox(
//                 height: AppSizes.formsSizeBoxHeight,
//               )
//                   : const SizedBox(),
//
//               //+ Next button
//               Obx(() {
//                 return MyButton(
//                   text: "Next",
//                   width: Get.width - 30,
//                   padding: 10,
//                   marginBottom: 10,
//                   color: authController.loading.value ? AppColors.kButtonGreenColor : AppColors.kButtonRedColor,
//                   onPressed: () {
//                     authController.loading.value = true;
//                     authController.forgotUserNameStep2(context);
//                     // Future.delayed(const Duration(seconds: 1), () {
//                     //   authController.loading.value = false;
//                     // });
//                   },
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
