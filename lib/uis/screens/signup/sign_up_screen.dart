import 'package:ez_tracker_app/helpers/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'widgets/sign_up_form_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DismissKeyboardOnTap(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: SignUpFormWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
