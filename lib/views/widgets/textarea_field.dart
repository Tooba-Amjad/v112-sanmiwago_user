import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_styles.dart';

class TextareaField extends StatelessWidget {
  const TextareaField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          enabledBorder: CustomInputDecoration.fixBorder,
          focusedBorder: CustomInputDecoration.fixBorder,
          errorBorder: CustomInputDecoration.errorBorder,
          focusedErrorBorder: CustomInputDecoration.errorBorder,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 18),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}