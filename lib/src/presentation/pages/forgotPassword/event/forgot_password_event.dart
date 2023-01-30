import 'package:equatable/equatable.dart';

export 'cancel.dart';
export 'submit.dart';
export 'success.dart';
export 'error.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}
