import 'package:ez_tracker_app/models/signup/singup_req_model.dart';
import 'package:ez_tracker_app/providers/account_provider.dart';
import 'package:ez_tracker_app/resources/assets_manager.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:ez_tracker_app/resources/routes_manager.dart';
import 'package:ez_tracker_app/resources/strings_manager.dart';
import 'package:ez_tracker_app/resources/styles_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:ez_tracker_app/uis/widgets/text_fields/confirm_password_field.dart';
import 'package:ez_tracker_app/uis/widgets/text_fields/email_field.dart';
import 'package:ez_tracker_app/uis/widgets/text_fields/name_field.dart';
import 'package:ez_tracker_app/uis/widgets/text_fields/password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/app_rectangle_button.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpReqModel _signUpReqModel = SignUpReqModel();

  Future<void> onSubmit() async {
    final AccountProvider authProvider =
        Provider.of<AccountProvider>(context, listen: false);
    _formKey.currentState!.save();
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      FocusScope.of(context).unfocus();
      final bool isSuccess = await authProvider.signUpWithEmailAndPassword(
          reqModel: _signUpReqModel);
      if (isSuccess) {
        _formKey.currentState?.reset();
        Navigator.of(context).pushReplacementNamed(AppRoutes.loginRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return AbsorbPointer(
      absorbing: false, //authProvider.isLoading,
      child: Column(
        children: [
          SizedBox(height: AppHeight.h10),
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
          _buildSignUpForm(),
          _buildSignUpButton(),
          SizedBox(height: AppHeight.h10),
          _buildAlreadyHaveAccountContainer(),
          // _buildPrivacyAndTermsContainer(),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
        vertical: AppPadding.p20,
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
                NameField(
                  onSaved: (String? value) {
                    _signUpReqModel = _signUpReqModel.copyWith(
                      name: value?.trim(),
                    );
                  },
                ),
                EmailField(
                  onSaved: (String? value) {
                    _signUpReqModel = _signUpReqModel.copyWith(
                      email: value?.trim(),
                    );
                  },
                ),
                PasswordField(
                  isPasswordNotMatching: _signUpReqModel.confirmPassword !=
                      _signUpReqModel.password,
                  onChanged: (String? value) {
                    _signUpReqModel = _signUpReqModel.copyWith(
                      password: value?.trim(),
                    );
                    setState(() {});
                  },
                  onSaved: (String? value) {},
                ),
                ConfirmPasswordField(
                  isPasswordNotMatching: _signUpReqModel.confirmPassword !=
                      _signUpReqModel.password,
                  onChanged: (String? value) {
                    _signUpReqModel = _signUpReqModel.copyWith(
                      confirmPassword: value?.trim(),
                    );
                    setState(() {});
                  },
                  onSaved: (String? value) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildPrivacyAndTermsContainer() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(
  //       horizontal: AppPadding.p20,
  //       vertical: AppPadding.p10,
  //     ),
  //     child: RichText(
  //       text: TextSpan(
  //         style: getSemiBoldStyle(
  //           fontSize: FontSize.s14,
  //           color: ColorManager.black,
  //         ),
  //         children: <TextSpan>[
  //           const TextSpan(
  //             text: AppStrings.kBySigningUp + AppStrings.kSpace,
  //           ),
  //           TextSpan(
  //             text: AppStrings.kTermsOfUse,
  //             style: getSemiBoldStyle(
  //               fontSize: FontSize.s14,
  //               color: Theme.of(context).primaryColor,
  //             ),
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = () {
  //                 UtilityHelper.showToast(message: AppStrings.kTermsOfUse);
  //               },
  //           ),
  //           const TextSpan(
  //             text: AppStrings.kSpace + AppStrings.kAnd + AppStrings.kSpace,
  //           ),
  //           TextSpan(
  //             text: AppStrings.kPrivacyPolicy,
  //             style: getSemiBoldStyle(
  //               fontSize: FontSize.s14,
  //               color: Theme.of(context).primaryColor,
  //             ),
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = () {
  //                 UtilityHelper.showToast(message: AppStrings.kPrivacyPolicy);
  //               },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAlreadyHaveAccountContainer() {
    return RichText(
      text: TextSpan(
        text: AppStrings.kAlreadyHaveAnAccount,
        style: getSemiBoldStyle(
          fontSize: FontSize.s14,
          color: ColorManager.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: AppStrings.kSpace + AppStrings.kSignIn,
            style: getSemiBoldStyle(
              fontSize: FontSize.s14,
              color: Theme.of(context).primaryColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pop();
              },
          )
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
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
        title: AppStrings.kSignUp,
        onPressed: onSubmit,
      ),
    );
  }
}
