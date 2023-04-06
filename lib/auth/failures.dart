import '../failure.dart';

class ConfirmationRequired extends Failure {
  const ConfirmationRequired() : super("Confirmation required.");
}

class UserExists extends Failure {
  const UserExists() : super("User already exists.");
}

class InvalidEmailPassword extends Failure {
  const InvalidEmailPassword() : super("Invalid email/password.");
}

class InvalidPassword extends Failure {
  final String? issue;

  const InvalidPassword(this.issue) : super("Invalid password.");
}

class InvalidEmail extends Failure {
  final String? issue;

  const InvalidEmail(this.issue) : super("Invalid email.");
}
