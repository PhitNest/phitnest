import 'package:equatable/equatable.dart';

export 'submit.dart';
export 'confirm_error.dart';
export 'resend.dart';
export 'confirm_success.dart';
export 'resend_error.dart';
export 'reset.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent() : super();

  @override
  List<Object> get props => [];
}
