import 'dart:core';

/// The Type enum
///
/// The domain type is either None, Alphabetic, Numeric or AlphaNumeric
enum SubdomainType { none, alphabetic, numeric, alphaNumeric }

///The EmailValidator entry point
///
/// To use the EmailValidator class, call EmailValidator.methodName
final class EmailValidator {
  // An atomic index which is reused during iterations in different methods
  static int _index = 0;

  // A string character set containing all special characters
  static const String _atomCharacters = "!#\$%&'*+-/=?^_`{|}~";

  // Sets default domainType to null on initialization
  static SubdomainType _domainType = SubdomainType.none;

  // Returns true if the first letter in string c has a 16-bit UTF-16 code unit
  // greater than or equal to 48 and less than or equal to 57
  // otherwise return false
  static bool _isDigit(String c) =>
      c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;

  // Returns true if the first letter in string c has a 16-bit UTF-16 code unit
  // greater than or equal to 65 and less than or equal to 90 (capital letters)
  // or greater than or equal to 97 and less than or equal to 122 (lowercase
  // letters) otherwise return false
  static bool _isLetter(String c) =>
      (c.codeUnitAt(0) >= 65 && c.codeUnitAt(0) <= 90) ||
      (c.codeUnitAt(0) >= 97 && c.codeUnitAt(0) <= 122);

  // Returns true if calling isLetter or isDigit with the same string returns
  // true. Only returns false if both isLetter and isDigit return false.
  static bool _isLetterOrDigit(String c) => _isLetter(c) || _isDigit(c);

  // Returns value of true if the first letter in the string c
  // isnt a number or letter or special character otherwise
  // return the result of _isLetterOrDigit or _atomCharacters.contains(c)
  // which only returns false if both _isLetterOrDigit and
  // _atomCharacters.contains(c) returns false
  static bool _isAtom(String c) =>
      c.codeUnitAt(0) >= 128 ||
      _isLetterOrDigit(c) ||
      _atomCharacters.contains(c);

  // First checks whether the first letter in string c is a letter, number or
  // special character
  // If calling isLetter returns true or c is '-',
  // domainType is set to Alphabetic and the function returns true
  // If calling isDigit returns true
  // domainType is set to Numeric and the function returns true
  // Otherwise the function returns false
  //
  // If the first if statement for string c being a letter, number or special
  // character fails domainType is set to Alphabetic and the function returns
  // true
  static bool _isDomain(String c) {
    if (c.codeUnitAt(0) < 128) {
      if (_isLetter(c) || c == '-') {
        _domainType = SubdomainType.alphabetic;
        return true;
      }

      if (_isDigit(c)) {
        _domainType = SubdomainType.numeric;
        return true;
      }

      return false;
    }

    _domainType = SubdomainType.alphabetic;
    return true;
  }

  // Returns true if domainType is not None
  // Otherwise returns false
  static bool _isDomainStart(String c) {
    if (c.codeUnitAt(0) < 128) {
      if (_isLetter(c)) {
        _domainType = SubdomainType.alphabetic;
        return true;
      }

      if (_isDigit(c)) {
        _domainType = SubdomainType.numeric;
        return true;
      }

      _domainType = SubdomainType.none;

      return false;
    }

    _domainType = SubdomainType.alphabetic;
    return true;
  }

  static bool _skipAtom(String text) {
    final startIndex = _index;

    while (_index < text.length && _isAtom(text[_index])) {
      _index++;
    }

    return _index > startIndex;
  }

  // Skips checking of subdomain and returns false if domainType is None
  // Otherwise returns true
  static bool _skipSubDomain(String text) {
    final startIndex = _index;

    if (!_isDomainStart(text[_index])) {
      return false;
    }

    _index++;

    while (_index < text.length && _isDomain(text[_index])) {
      _index++;
    }

    return (_index - startIndex) < 64 && text[_index - 1] != '-';
  }

  // Skips checking of domain if domainType is numeric and returns false
  // Otherwise, return true
  static bool _skipDomain(String text) {
    if (!_skipSubDomain(text)) {
      return false;
    }

    if (_index < text.length && text[_index] == '.') {
      do {
        _index++;

        if (_index == text.length) {
          return false;
        }

        if (!_skipSubDomain(text)) {
          return false;
        }
      } while (_index < text.length && text[_index] == '.');
    } else {
      return false;
    }

    // Note: by allowing AlphaNumeric,
    // we get away with not having to support punycode.
    if (_domainType == SubdomainType.numeric) {
      return false;
    }

    return true;
  }

  // Function skips over quoted text where if quoted text is in the string
  // the function returns true
  // otherwise the function returns false
  static bool _skipQuoted(String text) {
    var escaped = false;

    // skip over leading '"'
    _index++;

    while (_index < text.length) {
      if (text[_index] == '\\') {
        escaped = !escaped;
      } else if (!escaped) {
        if (text[_index] == '"') {
          break;
        }
      } else {
        escaped = false;
      }

      _index++;
    }

    if (_index >= text.length || text[_index] != '"') {
      return false;
    }

    _index++;

    return true;
  }

  static bool _skipIPv4Literal(String text) {
    var groups = 0;

    while (_index < text.length && groups < 4) {
      final startIndex = _index;
      var value = 0;

      while (_index < text.length &&
          text[_index].codeUnitAt(0) >= 48 &&
          text[_index].codeUnitAt(0) <= 57) {
        value = (value * 10) + (text[_index].codeUnitAt(0) - 48);
        _index++;
      }

      if (_index == startIndex || _index - startIndex > 3 || value > 255) {
        return false;
      }

      groups++;

      if (groups < 4 && _index < text.length && text[_index] == '.') {
        _index++;
      }
    }

    return groups == 4;
  }

  // Returns true if the first letter of the string is
  // a,b,c,d,e,f,A,B,C,D,E,F,1,2,3,4,5,6,7,8,9,0
  // otherwise, the function returns false
  static bool _isHexDigit(String str) {
    final c = str.codeUnitAt(0);
    return (c >= 65 && c <= 70) ||
        (c >= 97 && c <= 102) ||
        (c >= 48 && c <= 57);
  }

  // This needs to handle the following forms:
  //
  // IPv6-addr = IPv6-full / IPv6-comp / IPv6v4-full / IPv6v4-comp
  // IPv6-hex  = 1*4HEXDIG
  // IPv6-full = IPv6-hex 7(":" IPv6-hex)
  // IPv6-comp = [IPv6-hex *5(":" IPv6-hex)] "::" [IPv6-hex *5(":" IPv6-hex)]
  //             ; The "::" represents at least 2 16-bit groups of zeros
  //             ; No more than 6 groups in addition to the "::" may be
  //             ; present
  // IPv6v4-full = IPv6-hex 5(":" IPv6-hex) ":" IPv4-address-literal
  // IPv6v4-comp = [IPv6-hex *3(":" IPv6-hex)] "::"
  //               [IPv6-hex *3(":" IPv6-hex) ":"] IPv4-address-literal
  //             ; The "::" represents at least 2 16-bit groups of zeros
  //             ; No more than 4 groups in addition to the "::" and
  //             ; IPv4-address-literal may be present
  static bool _skipIPv6Literal(String text) {
    var compact = false;
    var colons = 0;

    while (_index < text.length) {
      var startIndex = _index;

      while (_index < text.length && _isHexDigit(text[_index])) {
        _index++;
      }

      if (_index >= text.length) {
        break;
      }

      if (_index > startIndex && colons > 2 && text[_index] == '.') {
        // IPv6v4
        _index = startIndex;

        if (!_skipIPv4Literal(text)) {
          return false;
        }

        return compact ? colons < 6 : colons == 6;
      }

      var count = _index - startIndex;
      if (count > 4) {
        return false;
      }

      if (text[_index] != ':') {
        break;
      }

      startIndex = _index;
      while (_index < text.length && text[_index] == ':') {
        _index++;
      }

      count = _index - startIndex;
      if (count > 2) {
        return false;
      }

      if (count == 2) {
        if (compact) {
          return false;
        }

        compact = true;
        colons += 2;
      } else {
        colons++;
      }
    }

    if (colons < 2) {
      return false;
    }

    return compact ? colons < 7 : colons == 7;
  }

  static const kInvalidEmailMessage = 'Invalid email address.';

  /// Validate the specified email address.
  ///
  /// the validator will use the newer International Email standards for
  /// validating the email address.
  static String? validateEmail(
    dynamic email,
  ) {
    _index = 0;

    if (email is! String || email.isEmpty || email.length >= 255) {
      return 'You must enter an email address.';
    }

    // Local-part = Dot-string / Quoted-string
    //       ; MAY be case-sensitive
    //
    // Dot-string = Atom *("." Atom)
    //
    // Quoted-string = DQUOTE *qcontent DQUOTE
    if (email[_index] == '"') {
      if (!_skipQuoted(email) || _index >= email.length) {
        return 'Invalid email address.';
      }
    } else {
      if (!_skipAtom(email) || _index >= email.length) {
        return kInvalidEmailMessage;
      }

      while (email[_index] == '.') {
        _index++;

        if (_index >= email.length) {
          return kInvalidEmailMessage;
        }

        if (!_skipAtom(email)) {
          return kInvalidEmailMessage;
        }

        if (_index >= email.length) {
          return kInvalidEmailMessage;
        }
      }
    }

    if (_index + 1 >= email.length || _index > 64 || email[_index++] != '@') {
      return kInvalidEmailMessage;
    }

    if (email[_index] != '[') {
      // domain
      if (!_skipDomain(email)) {
        return kInvalidEmailMessage;
      }

      return _index == email.length ? null : kInvalidEmailMessage;
    }

    // address literal
    _index++;

    // we need at least 8 more characters
    if (_index + 8 >= email.length) {
      return kInvalidEmailMessage;
    }

    final ipv6 = email.substring(_index - 1).toLowerCase();

    if (ipv6.contains('ipv6:')) {
      _index += 'IPv6:'.length;
      if (!_skipIPv6Literal(email)) {
        return kInvalidEmailMessage;
      }
    } else {
      if (!_skipIPv4Literal(email)) {
        return kInvalidEmailMessage;
      }
    }

    if (_index >= email.length || email[_index++] != ']') {
      return kInvalidEmailMessage;
    }

    return _index == email.length ? null : kInvalidEmailMessage;
  }
}
