import '../../../../common/failure.dart';
import 'confirm_email_event.dart';

class ErrorEvent extends ConfirmEmailEvent {
  final Failure failure;

  const ErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}
