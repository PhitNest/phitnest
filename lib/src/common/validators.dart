/// Length for the first name and email address
const int kMaxFirstNameLength = 24;
const int kMaxEmailLength = 64;

const int kMinPasswordLength = 8;

/// Shows which characters are allowed in the first name and email address
const String kNameRegex = r"/^[a-z ,.'-]+$/i";
const String kEmailRegex =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

/// Checks to see if the entered first name is valid
String? validateFirstName(String? name) {
  if (name == null || name.isEmpty) {
    return 'You must enter a name.';
  }

  if (name.length > kMaxFirstNameLength) {
    return 'Must be less than $kMaxFirstNameLength characters.';
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
  if (email == null || email.isEmpty || !RegExp(kEmailRegex).hasMatch(email)) {
    return 'You must enter a valid email.';
  }

  if (email.length > kMaxEmailLength) {
    return 'Must be less than $kMaxEmailLength characters.';
  }

  return null;
}
