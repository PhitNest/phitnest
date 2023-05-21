const kMinPasswordLength = 8;
const kMaxPasswordLength = 256;

String? validatePassword(dynamic password) {
  if (password is! String || password.isEmpty) {
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
