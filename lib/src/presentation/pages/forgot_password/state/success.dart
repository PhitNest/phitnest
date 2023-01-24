import '../../../../common/failure.dart';
import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordSuccessState extends ForgotPasswordState {
  final Future<Failure?> response;

  const ForgotPasswordSuccessState({required this.response}) : super();

  @override
  List<Object?> get props => [response];
}
