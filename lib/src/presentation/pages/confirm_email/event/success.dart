import '../../../../domain/entities/entities.dart';
import 'confirm_email_event.dart';

class SuccessEvent extends ConfirmEmailEvent {
  final UserEntity user;

  const SuccessEvent(this.user) : super();

  @override
  List<Object> get props => [user];
}
