import 'package:equatable/equatable.dart';

export 'error.dart';
export 'submit.dart';
export 'success.dart';
export 'resend_code.dart';

abstract class ConfirmEmailEvent extends Equatable {
  const ConfirmEmailEvent() : super();

  @override
  List<Object> get props => [];
}
