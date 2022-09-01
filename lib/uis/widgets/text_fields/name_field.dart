import 'package:ez_tracker_app/resources/strings_manager.dart';
import 'package:ez_tracker_app/uis/widgets/app_text_field.dart';
import 'package:ez_tracker_app/utils/validation_utils.dart';
import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  const NameField({
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
      hintText: AppStrings.kName,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(
      //     RegExp(r'^[A-Za-z\s]{1,}[\.]{0,1}[A-Za-z\s]{0,}$'),
      //     replacementString: updatedString,
      //   ),
      // ],
      focusNode: focusNode,
      nextFocus: nextFocus,
      onSaved: onSaved,
      initialValue: initialVal,

      validator: (String? value) {
        return ValidationUtils.validateName(value);
      },
    );
  }
}
