part of login_page;

class _ErrorState extends _ILoginState {
  final Completer<void> dismiss;
  final Failure failure;

  /// This state indicates that there was an error during login. The error is stored in
  /// [failure] and it is shown on a [StyledErrorBanner] that is dismissed when [dismiss]
  /// is completed via `dismiss.complete()`.
  const _ErrorState({
    required super.autovalidateMode,
    required super.invalidCredentials,
    required this.dismiss,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, dismiss, failure];
}
