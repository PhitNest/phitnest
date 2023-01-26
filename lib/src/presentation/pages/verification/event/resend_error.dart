import '../../../../common/failure.dart';
import 'verification_event.dart';

class ResendErrorEvent extends VerificationEvent {
  final Failure failure;

  ResendErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}
