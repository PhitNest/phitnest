const int kMaxFirstNameLength = 24;

String? validateFirstName(String name) {
  if (name.isEmpty) {
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
