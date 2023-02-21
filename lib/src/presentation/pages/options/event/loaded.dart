part of options_page;

class _LoadedUserEvent extends _IOptionsEvent {
  final GetUserResponse response;

  const _LoadedUserEvent({
    required this.response,
  }) : super();
}
