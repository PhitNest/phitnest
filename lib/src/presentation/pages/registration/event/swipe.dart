import 'registration_event.dart';

class SwipeEvent extends RegistrationEvent {
  final int pageIndex;

  const SwipeEvent(this.pageIndex) : super();

  @override
  List<Object> get props => [pageIndex];
}
