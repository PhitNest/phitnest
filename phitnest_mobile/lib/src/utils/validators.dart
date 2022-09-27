const int kMaxFirstNameLength = 24;
const int kMaxEmailLength = 64;

String? validateFirstName(String? name) {
  if (name == null || name.isEmpty) {
    return 'You must enter a name.';
  }

  if (name.length > kMaxFirstNameLength) {
    return 'Please enter a name shorter than $kMaxFirstNameLength characters.';
  }

  if (RegExp(r"/^[a-z ,.'-]+$/i").hasMatch(name)) {
    return 'Please enter a valid name.';
  }

  return null;
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'You must enter a valid email.';
  }

  if (email.length > kMaxEmailLength) {
    return 'Please enter an email shorter than $kMaxEmailLength characters.';
  }

  if (RegExp(
          r"^[\w!#$%&'*+/=?`{|}~^-]+(?:\.[\w!#$%&'*+/=?`{|}~^-]+)*@↵(?:[A-Z0-9-]+\.)+[A-Z]{2,6}$")
      .hasMatch(email)) {
    return 'Please enter a valid email address.';
  }

  return null;
}
