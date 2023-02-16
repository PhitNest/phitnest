part of login_page;

abstract class _ILoginState extends Equatable {
  final AutovalidateMode autovalidateMode;

  /// These are credentials that we received [Failures.invalidPassword] from the backend for.
  final Set<Tuple2<String, String>> invalidCredentials;

  /// The base class for all login states.
  const _ILoginState({
    required this.autovalidateMode,
    required this.invalidCredentials,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode, invalidCredentials];
}
