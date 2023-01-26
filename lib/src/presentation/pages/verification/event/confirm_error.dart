import '../../../../common/failure.dart';
import 'verification_event.dart';

class ConfirmErrorEvent extends VerificationEvent {
  final Failure failure;

  ConfirmErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}
