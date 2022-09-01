import 'package:ez_tracker_app/resources/strings_manager.dart';
import 'package:ez_tracker_app/uis/widgets/app_text_field.dart';
import 'package:ez_tracker_app/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    Key? key,
    required this.onSaved,
    this.focusNode,
    this.nextFocus,
    this.initialVal,
  }) : super(key: key);

  final Function(String?)? onSaved;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String? initialVal;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      hintText: AppStrings.kEmail,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      nextFocus: nextFocus,
      onSaved: onSaved,
      initialValue: initialVal,
      validator: (String? value) {
        return ValidationUtils.validateEmail(value);
      },
    );
  }
}
