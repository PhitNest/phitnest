import '../../../../common/failure.dart';
import 'verification_event.dart';

class ResendEvent extends VerificationEvent {
  final Future<Failure?> Function() resend;

  ResendEvent(this.resend) : super();

  @override
  List<Object> get props => [resend];
}
