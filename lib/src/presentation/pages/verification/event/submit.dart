import '../../../../common/failure.dart';
import '../../../../common/utils/utils.dart';
import '../../../../data/data_sources/backend/backend.dart';
import 'verification_event.dart';

class SubmitEvent extends VerificationEvent {
  final FEither<LoginResponse?, Failure> Function(String code) confirmation;

  const SubmitEvent({
    required this.confirmation,
  }) : super();

  @override
  List<Object> get props => [confirmation];
}
