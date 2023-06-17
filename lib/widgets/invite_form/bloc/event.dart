part of 'bloc.dart';

sealed class InviteFormEvent extends Equatable {
  const InviteFormEvent() : super();
}

class InviteFormSubmitEvent extends InviteFormEvent {
  const InviteFormSubmitEvent() : super();

  @override
  List<Object?> get props => [];
}

class InviteFormResetEvent extends InviteFormEvent {
  const InviteFormResetEvent() : super();

  @override
  List<Object?> get props => [];
}

class InviteFormResponseEvent extends InviteFormEvent {
  final HttpResponse<void> response;

  const InviteFormResponseEvent(this.response) : super();

  @override
  List<Object?> get props => [response];
}
