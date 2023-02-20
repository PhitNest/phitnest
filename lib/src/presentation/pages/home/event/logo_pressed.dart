part of home_page;

class _LogoPressedEvent extends _IHomeEvent {
  final PressType press;

  const _LogoPressedEvent(this.press) : super();

  @override
  List<Object> get props => [press];
}
