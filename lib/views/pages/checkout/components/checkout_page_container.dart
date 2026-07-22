import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class CheckoutPageContainer extends StatelessWidget {
  const CheckoutPageContainer({
    super.key,
    this.isForm = false,
    this.formKey,
    this.height,
    this.width,
    required this.headerNumber,
    required this.headerText,
    required this.children,
  });

  final bool isForm;
  final GlobalKey<FormState>? formKey;
  final double? height;
  final double? width;
  final String headerNumber;
  final String headerText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      height: height,
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(0),
      ),
      child: Card(
        elevation: 20,
        // borderOnForeground: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const SizedBox(height: AppSizes.formsSizeBoxHeight),
            //+ header
            Container(
              color: AppColors.kSkyLightDullColor,
              child: Row(
                children: [
                  headerNumber.isNotEmpty
                      ? Container(
                          width: 22,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: AppColors.kLightGreyColor, width: 2),
                          ),
                          child: MyText(
                            text: headerNumber,
                            align: TextAlign.center,
                            fontSize: 12,
                          ),
                        )
                      : const SizedBox(
                          width: 10,
                        ),
                  MyText(
                    text: headerText,
                    paddingTop: 10,
                    paddingBottom: 10,
                  ),
                ],
              ),
            ),
          ]
              .followedBy(
                isForm
                    ? [
                        // + also pass me form keys
                        Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: children,
                            ),
                          ),
                        ),
                      ]
                    :
                children,
              )
              .toList(),
        ),
      ),
    );
  }
}
