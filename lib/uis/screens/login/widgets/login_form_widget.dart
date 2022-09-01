import 'package:ez_tracker_app/models/login/login_req_model.dart';
import 'package:ez_tracker_app/providers/account_provider.dart';
import 'package:ez_tracker_app/resources/assets_manager.dart';
import 'package:ez_tracker_app/uis/widgets/text_fields/email_field.dart';
import 'package:ez_tracker_app/uis/widgets/text_fields/password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../resources/color_manager.dart';
import '../../../../resources/font_manager.dart';
import '../../../../resources/routes_manager.dart';
import '../../../../resources/strings_manager.dart';
import '../../../../resources/styles_manager.dart';
import '../../../../resources/values_manager.dart';
import '../../../widgets/app_rectangle_button.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({Key? key}) : super(key: key);

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginReqModel _loginReqModel = LoginReqModel();

  Future<void> onSubmit() async {
    final AccountProvider authProvider =
        Provider.of<AccountProvider>(context, listen: false);
    _formKey.currentState!.save();
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      FocusScope.of(context).unfocus();
      final bool isSuccess = await authProvider.loginWithEmailAndPassword(
        reqModel: _loginReqModel,
      );
      if (isSuccess) {
        _formKey.currentState?.reset();
        AppRoutes.popUntil(context, name: AppRoutes.homeRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return AbsorbPointer(
      absorbing: false, //authProvider.isLoading,
      child: Column(
        children: [
          // SizedBox(height: AppHeight.h10),
          Image.asset(
            ImageAssets.appLogo,
            fit: BoxFit.contain,
            width: AppWidth.w50Percent,
          ),
          SizedBox(height: AppHeight.h20),
          Text(
            AppStrings.kWelcomeToEzTrack,
            style: getMediumStyle(
              color: Theme.of(context).primaryColor,
              fontSize: FontSize.s25,
            ),
          ),
          SizedBox(height: AppHeight.h10),
          _buildSignInFormContainer(),
          _buildSignInButton(),
          SizedBox(height: AppHeight.h10),
          _buildDontHaveAnAccountContainer(),
          SizedBox(height: AppHeight.h20),
        ],
      ),
    );
  }

  Widget _buildDontHaveAnAccountContainer() {
    return Container(
      padding: EdgeInsets.only(bottom: AppPadding.p30),
      child: RichText(
        text: TextSpan(
          text: AppStrings.kDontHaveAnAccount,
          style: getSemiBoldStyle(
            fontSize: FontSize.s14,
            color: ColorManager.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: AppStrings.kSpace + AppStrings.kSignUp,
              style: getSemiBoldStyle(
                fontSize: FontSize.s14,
                color: Theme.of(context).primaryColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushNamed(AppRoutes.signupRoute);
                },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
      ),
      child: AppRectangleButton(
        textStyle: getBoldStyle(
          fontSize: FontSize.s16,
          color: ColorManager.black,
        ),
        isLoading: false,
        title: AppStrings.kSignIn,
        onPressed: onSubmit,
      ),
    );
  }

  Widget _buildSignInFormContainer() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
        vertical: AppPadding.p10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                EmailField(
                  onSaved: (String? value) {
                    _loginReqModel =
                        _loginReqModel.copyWith(email: value?.trim());
                  },
                ),
                PasswordField(
                  onSaved: (String? value) {
                    _loginReqModel =
                        _loginReqModel.copyWith(password: value?.trim());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
