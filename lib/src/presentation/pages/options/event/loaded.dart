part of options_page;

class _LoadedUserEvent extends _OptionsEvent {
  final GetUserResponse response;

  const _LoadedUserEvent({
    required this.response,
  }) : super();

  @override
  List<Object> get props => [response];
}
