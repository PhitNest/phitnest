part of home_page;

class _OptionsLoadedUserEvent extends _IOptionsEvent {
  final GetUserResponse response;

  const _OptionsLoadedUserEvent({
    required this.response,
  }) : super();
}
