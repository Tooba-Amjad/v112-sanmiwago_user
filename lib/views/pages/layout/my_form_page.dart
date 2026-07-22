import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/utils/custom_scroll_behavior.dart';
import 'package:sanmiwago_user/views/widgets/fields_container.dart';

class MyFormPage extends StatelessWidget {
  const MyFormPage({
    super.key,
    required this.pageTopPadding,
    this.pageBottomPadding,
    required this.children,
    this.showBottomPadding = true,
    this.showTopPadding = true,
    this.sc,
  });

  final double pageTopPadding;
  final double? pageBottomPadding;
  final List<Widget> children;
  final bool showBottomPadding;
  final bool showTopPadding;
  final ScrollController? sc;

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: SingleChildScrollView(
          controller: sc,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showTopPadding) SizedBox(height: pageTopPadding),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  //+ back container
                  Positioned(
                    top: -8,
                    right: 0,
                    left: 0,
                    child: Container(
                      // color: AppColors.kSeoulColor,
                      decoration: BoxDecoration(
                        color: AppColors.kSeoulColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),

                  //+ back container
                  Positioned(
                    top: -3,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.kTertiaryColor2,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 100,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 13,
                      ),
                    ),
                  ),

                  //+ main card
                  Card(
                    elevation: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: FieldsContainer(
                      children: children,
                    ),
                  ),
                ],
              ),
              if (showBottomPadding) SizedBox(height: pageBottomPadding ?? pageTopPadding),
            ],
          ),
        ),
      ),
    );
  }
}
