part of options_page;

class _SignOutErrorEvent extends _OptionsEvent {
  final Failure failure;

  const _SignOutErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}
