part of 'bloc.dart';

sealed class InviteFormState extends Equatable {
  const InviteFormState() : super();
}

class InviteFormInitialState extends InviteFormState {
  const InviteFormInitialState() : super();

  @override
  List<Object?> get props => [];
}

class InviteFormLoadingState extends InviteFormState {
  final CancelableOperation<HttpResponse<void>> loadingOperation;

  const InviteFormLoadingState(this.loadingOperation) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class InviteFormFailureState extends InviteFormState {
  final Failure failure;

  const InviteFormFailureState(this.failure) : super();

  @override
  List<Object?> get props => [failure];
}

class InviteFormSuccessState extends InviteFormState {
  const InviteFormSuccessState() : super();

  @override
  List<Object?> get props => [];
}
