class ValidationMSG {
  // Name
  static const String kNameIsEmpty = 'Please enter your name.';
  static const String kNameLengthValidation =
      // ignore: lines_longer_than_80_chars
      'Please enter name at least 3 characters and not more than 15 characters.';

  // Email
  static const String kEmailIsEmpty = 'Please enter your email address.';
  static const String kInvalidEmail = 'Please enter valid email address.';

  // Password
  static const String kPasswordIsEmpty = 'Password is required.';
  static const String kPasswordLengthValidation =
      'Please enter password at least 6 characters.';
  static const String kPasswordNotMatching = 'Passwords are not matching.';
  static const String kConfirmPasswordIsEmpty = 'Confirm password is required.';
}

class ValidationUtils {
  static String? validateEmail(String? value) {
    const String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    final RegExp regExp = RegExp(pattern);
    final String email = value?.trim() ?? '';
    if (email.isEmpty) {
      return ValidationMSG.kEmailIsEmpty;
    } else if (!regExp.hasMatch(email)) {
      return ValidationMSG.kInvalidEmail;
    }
    return null;
  }

  static String? validateName(String? value) {
    final String name = value?.trim() ?? '';
    if (name.isEmpty) {
      return ValidationMSG.kNameIsEmpty;
    } else if (name.length < 3 || name.length > 15) {
      return ValidationMSG.kNameLengthValidation;
    }
    return null;
  }

  static String? validatePassword(
    String? value, {
    bool isPasswordNotMatching = false,
  }) {
    final String password = value?.trim() ?? '';
    if (password.isEmpty) {
      return ValidationMSG.kPasswordIsEmpty;
    } else if (password.length < 6) {
      return ValidationMSG.kPasswordLengthValidation;
    } else if (isPasswordNotMatching) {
      return ValidationMSG.kPasswordNotMatching;
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value, {
    bool isPasswordNotMatching = false,
  }) {
    final String password = value?.trim() ?? '';
    if (isPasswordNotMatching) {
      return ValidationMSG.kPasswordNotMatching;
    } else if (password.isEmpty) {
      return ValidationMSG.kConfirmPasswordIsEmpty;
    }
    return null;
  }
}
