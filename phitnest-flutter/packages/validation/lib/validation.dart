String? validateFirstName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.length == 0) {
    return 'First name is Required';
  } else if (!regExp.hasMatch(value?.trim() ?? '')) {
    return 'Name must be a-z and A-Z';
  }
  return null;
}

String? validateLastName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (!regExp.hasMatch(value?.trim() ?? '')) {
    return 'Name must be a-z and A-Z';
  }
  return null;
}

String? validateDate(String? value) {
  if (value == null) {
    return 'Date cannot be null';
  }
  try {
    DateTime.parse(value);
    return null;
  } catch (e) {
    return e.toString();
  }
}

String? validateMobile(String? value) {
  String pattern =
      r'(^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.length == 0) {
    return 'Mobile is Required';
  } else if (!regExp.hasMatch(value?.trim() ?? '')) {
    return 'Invalid format';
  }
  return null;
}

String? validatePassword(String? value) {
  if ((value?.length ?? 0) < 6)
    return 'Password must be more than 5 character';
  else
    return null;
}

String? validateChatMessage(String? value) {
  if (value?.isNotEmpty ?? false) {
    return null;
  }

  return '';
}

String? validateEmail(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value?.trim() ?? ''))
    return 'Enter Valid Email';
  else
    return null;
}

String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (confirmPassword?.length == 0) {
    return 'Confirm password is required';
  } else if (password != confirmPassword) {
    return 'Password doesn\'t match';
  }
  return null;
}