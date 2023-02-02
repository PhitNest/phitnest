part of login_page;

abstract class _LoginState extends Equatable {
  final AutovalidateMode autovalidateMode;
  final Set<Tuple2<String, String>> invalidCredentials;

  const _LoginState({
    required this.autovalidateMode,
    required this.invalidCredentials,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode, invalidCredentials];
}
