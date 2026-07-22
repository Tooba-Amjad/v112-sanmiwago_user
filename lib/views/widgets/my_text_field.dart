import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/app_styles.dart';

class MyTextField extends StatelessWidget {
  final Function()? onTap;
  final String? label, hint;
  final bool? isObSecure, haveLabel, isReadOnly, havePrefix, haveSuffix, isExpands, autofocus;
  final bool disableErrorText;
  final ValueChanged<String>? onChanged;
  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autoValidateMode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final double? marginBottom;
  final int? maxLines;
  final int? maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<String> autoFillHints;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? initialValue;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;

  const MyTextField({
    super.key,
    this.onTap,
    this.label,
    this.hint,
    this.validator,
    this.disableErrorText = false,
    this.isObSecure = false,
    this.haveLabel = true,
    this.isReadOnly = false,
    this.haveSuffix = false,
    this.havePrefix = false,
    this.isExpands = false,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.marginBottom = 15.0,
    this.maxLines = 1,
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
    this.initialValue,
    this.autoFillHints = const [],
    this.inputFormatters,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.textInputAction,
    this.focusNode,
    this.autofocus,
    this.autoValidateMode,
    this.textAlign,
    this.padding,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSizes.fieldsPadding),
      child: TextFormField(
        contextMenuBuilder: (context, editableTextState) {
          final List<ContextMenuButtonItem> buttonItems =
              editableTextState.contextMenuButtonItems;
          // buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
          //   return buttonItem.type == ContextMenuButtonType.cut;
          // });
          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems: buttonItems,
          );
        },
        maxLength: maxLength,
        onTap: onTap,
        autovalidateMode: autoValidateMode,
        textAlignVertical: TextAlignVertical.center,
        textAlign: textAlign ?? TextAlign.start,
        readOnly: isReadOnly!,
        focusNode: focusNode,
        initialValue: initialValue,
        maxLines: maxLines ?? 1,
        obscureText: isObSecure!,
        expands: isExpands ?? false,
        obscuringCharacter: '•',
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: keyboardType,
        cursorWidth: 1.0,
        autofillHints: autoFillHints,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction ?? TextInputAction.next,
        autofocus: autofocus ?? false,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: haveSuffix!
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    suffixIcon!,
                  ],
                )
              : null,
          hintText: hint,

          hintStyle: const TextStyle(color: Colors.black54, fontSize: 15),
          errorStyle: disableErrorText ? const TextStyle(color: Colors.red, fontSize: 0) : null,
          errorMaxLines: 4,
          contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 15, vertical: (maxLines ?? 1) > 1 ? 10 : 10),
          filled: (isReadOnly ?? false) ? true : false,
          fillColor: AppColors.kSkyLightColor,
          border: CustomInputDecoration.fixBorder,
          enabledBorder: CustomInputDecoration.fixBorder,
          focusedBorder: CustomInputDecoration.fixBorder,
          errorBorder: CustomInputDecoration.errorBorder,
          focusedErrorBorder: CustomInputDecoration.errorBorder,
          // focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 2.0)),
        ),
      ),
    );
  }
}
