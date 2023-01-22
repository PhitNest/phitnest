import 'login_state.dart';

class ConfirmUserState extends LoginState {
  final String email;

  const ConfirmUserState({required this.email}) : super();

  @override
  List<Object?> get props => [email];
}
