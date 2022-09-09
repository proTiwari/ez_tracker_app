import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:ez_tracker_app/resources/styles_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    this.isEnabled = true,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.controller,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.maxLine = 1,
    this.focusNode,
    this.nextFocus,
    this.suffixIcon,
    this.prefixIcon,
    this.suffixIconSelector,
    this.onSaved,
    this.hintText,
    this.onTap,
    this.maxLength,
    this.onChanged,
    this.suffix,
    this.initialValue,
    this.suffixIconColor,
    this.enableInteractiveSelection = true,
    this.inputFormatters,
    this.errorStyle,
  }) : super(key: key);

  final bool isEnabled;
  final TextEditingController? controller;
  final bool isPasswordVisible;
  final bool isPassword;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final int maxLine;
  final Function()? suffixIconSelector;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final String? hintText;
  final Function()? onTap;
  final int? maxLength;
  final Widget? suffix;
  final String? initialValue;
  final Color? suffixIconColor;
  final bool enableInteractiveSelection;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? errorStyle;

  bool get _isObsecure {
    if (isPassword) {
      return !isPasswordVisible;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: AppHeight.h22,
      ),
      child: TextFormField(
        readOnly: !isEnabled,
        inputFormatters: inputFormatters,
        enableInteractiveSelection: enableInteractiveSelection,
        style: getSemiBoldStyle(
          fontSize: FontSize.s14,
          color: ColorManager.black,
        ),
        initialValue: initialValue,
        onTap: onTap,
        controller: controller,
        obscureText: _isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        maxLines: maxLine,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
        textInputAction: textInputAction,
        focusNode: focusNode,
        maxLength: maxLength,
        onChanged: onChanged,
        onFieldSubmitted: (String arg) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          hintText: hintText,
          errorStyle: errorStyle,
          suffix: isPassword
              ? GestureDetector(
                  onTap: suffixIconSelector,
                  child: Icon(
                    suffixIcon,
                    size: AppSize.s18,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : suffixIcon != null
                  ? Icon(
                      suffixIcon,
                      size: AppSize.s18,
                      color: suffixIconColor,
                    )
                  : null,
          suffixIcon: suffix != null
              ? SizedBox(
                  width: AppWidth.w120,
                  child: suffix,
                )
              : null,
        ),
      ),
    );
  }
}
