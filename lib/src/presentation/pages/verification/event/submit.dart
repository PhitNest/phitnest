import '../../../../common/failure.dart';
import 'verification_event.dart';

class SubmitEvent extends VerificationEvent {
  final Future<Failure?> Function(String code) confirmation;

  const SubmitEvent({
    required this.confirmation,
  }) : super();

  @override
  List<Object> get props => [confirmation];
}
