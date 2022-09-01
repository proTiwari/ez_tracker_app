import 'package:flutter/material.dart';
import '../../../helpers/dismiss_keyboard.dart';
import 'widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DismissKeyboardOnTap(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: LoginFormWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
