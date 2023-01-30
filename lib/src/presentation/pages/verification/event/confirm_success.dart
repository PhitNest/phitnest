import '../../../../data/data_sources/backend/backend.dart';
import 'verification_event.dart';

class ConfirmSuccessEvent extends VerificationEvent {
  final LoginResponse? response;

  const ConfirmSuccessEvent(this.response) : super();

  @override
  List<Object> get props => [];
}
