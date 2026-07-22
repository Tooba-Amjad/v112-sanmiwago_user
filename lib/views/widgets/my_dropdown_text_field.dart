import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/app_styles.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MyDropDownTextField extends StatelessWidget {
  final Function(String?)? validator;
  final Function(String?)? onChange;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final List<String>? listItem;

  final bool isForEdit;

  const MyDropDownTextField({
    Key? key,
    this.validator,
    this.onChange,
    this.initialValue,
    this.listItem,
    this.hintText,
    this.isForEdit = false,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.fieldsPadding),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(6),
      //   border: Border.all(
      //     width: 1.0,
      //     color: AppColors.kBorderColor,
      //   ),
      // ),
      child: DropdownButtonFormField<String>(
        decoration: isForEdit == true
            ? InputDecoration(
                contentPadding: CustomInputDecoration.padding,
                enabledBorder: CustomInputDecoration.fixBorder,
                focusedBorder: CustomInputDecoration.fixBorder,
                hintStyle: CustomInputDecoration.fixStyle,
                labelStyle: CustomInputDecoration.fixLabelStyle,
                focusedErrorBorder: CustomInputDecoration.errorBorder,
                errorBorder: CustomInputDecoration.errorBorder,
                labelText: labelText ?? "",
              )
            : const InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
        validator: (val) => validator != null ? validator!(val ?? "") : null,
        hint: MyText(
          text: hintText ?? "",
          style: isForEdit == true ? null : DropDownDeco.dropDownSignUpText,
        ),
        dropdownColor: isForEdit == true ? AppColors.kPrimaryColor : AppColors.kPrimaryColor,
        icon: Icon(
          FontAwesomeIcons.angleDown,
          color: isForEdit == true ? AppColors.kBlackColor : AppColors.kSecondaryColor,
          size: 22,
        ),
        iconSize: isForEdit == true ? 25 : 40,
        style: isForEdit == true ? null : DropDownDeco.dropDownSignUpSelectedText,
        isExpanded: true,
        value: initialValue,
        onChanged: (value) => onChange!(value),
        items: listItem?.map((rlItem) {
          return DropdownMenuItem(
            value: rlItem,
            child: MyText(text: rlItem),
          );
        }).toList(),
      ),
    );
  }
}
