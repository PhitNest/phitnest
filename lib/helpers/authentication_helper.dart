import 'package:easy_localization/easy_localization.dart';

String? validateName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.length == 0) {
    return 'Name is Required'.tr();
  } else if (!regExp.hasMatch(value ?? '')) {
    return 'Name must be a-z and A-Z'.tr();
  }
  return null;
}

String? validateMobile(String? value) {
  String pattern = r'(^\+?[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.length == 0) {
    return 'Mobile is Required'.tr();
  } else if (!regExp.hasMatch(value ?? '')) {
    return 'Mobile Number must be digits'.tr();
  }
  return null;
}

String? validatePassword(String? value) {
  if ((value?.length ?? 0) < 6)
    return 'Password must be more than 5 character'.tr();
  else
    return null;
}

String? validateEmail(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value ?? ''))
    return 'Enter Valid Email'.tr();
  else
    return null;
}

String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (password != confirmPassword) {
    return 'Password doesn\'t match'.tr();
  } else if (confirmPassword?.length == 0) {
    return 'Confirm password is required'.tr();
  } else {
    return null;
  }
}
