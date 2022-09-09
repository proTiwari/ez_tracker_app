import 'package:ez_tracker_app/resources/strings_manager.dart';
import 'package:ez_tracker_app/uis/widgets/app_text_field.dart';
import 'package:ez_tracker_app/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({
    Key? key,
    required this.onSaved,
    this.focusNode,
    this.nextFocus,
    this.initialVal,
    required this.isPasswordNotMatching,
    this.onChanged,
  }) : super(key: key);

  final Function(String?)? onSaved;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String? initialVal;
  final bool isPasswordNotMatching;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      hintText: AppStrings.kConfirmPassword,
      focusNode: focusNode,
      keyboardType: TextInputType.visiblePassword,
      nextFocus: nextFocus,
      onSaved: onSaved,
      initialValue: initialVal,
      isPassword: true,
      onChanged: onChanged,
      validator: (String? value) {
        return ValidationUtils.validateConfirmPassword(
          value,
          isPasswordNotMatching: isPasswordNotMatching,
        );
      },
    );
  }
}
