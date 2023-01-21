import 'registration_event.dart';

/// This event is emitted when the users swipes to another page
class SwipeEvent extends RegistrationEvent {
  final int pageIndex;

  const SwipeEvent(this.pageIndex) : super();

  @override
  List<Object> get props => [pageIndex];
}
