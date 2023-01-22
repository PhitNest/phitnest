import 'package:email_validator/email_validator.dart';

/// Length for the first name and email address
const int kMaxNameLength = 24;

const int kMinPasswordLength = 8;
const int kMaxPasswordLength = 256;

/// Checks to see if the entered name is valid
String? validateName(String? name) {
  if (name == null || name.isEmpty) {
    return 'You must enter a name.';
  }

  if (name.length > kMaxNameLength) {
    return 'Must be less than $kMaxNameLength characters.';
  }

  if (RegExp(r"/^[a-z ,.'-]+$/i").hasMatch(name)) {
    return 'Please enter a valid name.';
  }

  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'You must enter a password.';
  }

  if (password.length < kMinPasswordLength) {
    return 'Must be at least $kMinPasswordLength characters.';
  }

  if (password.length > kMaxPasswordLength) {
    return 'Must be less than $kMaxPasswordLength characters.';
  }

  if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
    return 'Must contain at least one lowercase letter.';
  }

  if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
    return 'Must contain at least one uppercase letter.';
  }

  if (!RegExp(r'(?=.*[0-9])').hasMatch(password)) {
    return 'Must contain at least one number.';
  }

  if (!RegExp(r'''(?=.*[\^$*.[\]{}()?"!@#%&/\\,><':;|_~`=+\- ])''')
      .hasMatch(password)) {
    return 'Must contain at least one special character.';
  }

  if (password.contains(' ')) {
    return 'Cannot contain spaces.';
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
