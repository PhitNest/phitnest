import 'package:dartz/dartz.dart';

import '../../../../common/failure.dart';
import '../../../../data/backend/backend.dart';
import 'verification_event.dart';

class SubmitEvent extends VerificationEvent {
  final Future<Either<LoginResponse?, Failure>> Function(String code)
      confirmation;

  const SubmitEvent({
    required this.confirmation,
  }) : super();

  @override
  List<Object> get props => [confirmation];
}
