import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class RecoveredGiftCardData extends StatelessWidget {
  const RecoveredGiftCardData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RxBool showMessage = true.obs;
    return Form(
      child: MyFormPage(
        pageTopPadding: Get.height * 0.12,
        children: [
          Obx(() {
            return showMessage.value
                ? Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RichText(
                                  maxLines: 10,
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "Success!\n",
                                    style: TextStyle(
                                      color: Colors.green[800],
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "GiftCard recovered successfully",
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              /* + close button + */
                              InkWell(
                                onTap: () {
                                  showMessage.value = false;
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 0, right: 10),
                                  child: Icon(
                                    Icons.close,
                                    size: 22,
                                    color: AppColors.kGreyColor,
                                    // weight: 1000,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),
                  )
                : const SizedBox();
          }),

          const SizedBox(height: AppSizes.formsSizeBoxHeight),

          /* + Gift Card No row + */
          Row(
            children: [
              const MyText(
                text: "GiftCard No: ",
                align: TextAlign.center,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                paddingTop: 10,
                paddingBottom: 10,
                paddingLeft: 15,
                // paddingRight: 15,
              ),
              Expanded(
                child: MyText(
                  text: giftCardController.recoveredGiftCardNo,
                  align: TextAlign.left,
                  color: AppColors.kGreyColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  paddingTop: 10,
                  paddingBottom: 10,
                  paddingLeft: 5,
                ),
              ),
            ],
          ),

          /* + Gift Card Pin row + */
          Row(
            children: [
              const MyText(
                text: "GiftCard Pin: ",
                align: TextAlign.left,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                paddingTop: 10,
                paddingBottom: 10,
                paddingLeft: 15,
                // paddingRight: 15,
              ),
              MyText(
                text: giftCardController.recoveredPin,
                align: TextAlign.left,
                color: AppColors.kGreyColor,
                fontWeight: FontWeight.w500,
                fontSize: 20,
                paddingTop: 10,
                paddingBottom: 10,
                paddingLeft: 5,
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const MyText(
                text: "GiftCard QR: ",
                align: TextAlign.left,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                paddingTop: 20,
                paddingBottom: 10,
                paddingLeft: 15,
                // paddingRight: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: QrImageView(
                    data: giftCardController.recoveredGiftCardNo,
                    version: QrVersions.auto,
                    size: 180.0,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.formsSizeBoxHeight),
        ],
      ),
    );
  }
}
