import 'package:email_validator/email_validator.dart';

/// Length for the first name and email address
const int kMaxNameLength = 24;

const int kMinPasswordLength = 8;

/// Shows which characters are allowed in the first name and email address
const String kNameRegex = r"/^[a-z ,.'-]+$/i";

/// Checks to see if the entered name is valid
String? validateName(String? name) {
  if (name == null || name.isEmpty) {
    return 'You must enter a name.';
  }

  if (name.length > kMaxNameLength) {
    return 'Must be less than $kMaxNameLength characters.';
  }

  if (RegExp(kNameRegex).hasMatch(name)) {
    return 'Please enter a valid name.';
  }

  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'You must enter a password.';
  }

  if (password.length < kMinPasswordLength) {
    return 'Must be greater than $kMinPasswordLength characters.';
  }

  return null;
}

/// Checks to see if the entered email address is valid
String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'You must enter a valid email.';
  }

  if (!EmailValidator.validate(email.trim())) {
    return 'You must enter a valid email.';
  }

  return null;
}
