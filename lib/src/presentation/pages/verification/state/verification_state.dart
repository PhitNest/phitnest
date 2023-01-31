import 'package:equatable/equatable.dart';

export 'initial.dart';
export 'confirming.dart';
export 'confirm_error.dart';
export 'confirm_success.dart';
export 'resend_error.dart';
export 'resending.dart';

abstract class VerificationState extends Equatable {
  const VerificationState() : super();

  @override
  List<Object> get props => [];
}
