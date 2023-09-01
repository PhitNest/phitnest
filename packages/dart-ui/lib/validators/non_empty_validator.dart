String? validateNonEmpty(dynamic value) {
  if (value == null || (value is String && value.isEmpty)) {
    return 'Please enter some text';
  }
  return null;
}
