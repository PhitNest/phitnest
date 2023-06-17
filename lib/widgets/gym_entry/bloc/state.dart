part of 'bloc.dart';

sealed class GymEntryFormState extends Equatable {
  const GymEntryFormState() : super();
}

class GymEntryFormInitialState extends GymEntryFormState {
  const GymEntryFormInitialState() : super();

  @override
  List<Object?> get props => [];
}

class GymEntryFormLoadingState extends GymEntryFormState {
  final CancelableOperation<HttpResponse<GymEntryFormSuccess>> loadingOperation;

  const GymEntryFormLoadingState(this.loadingOperation) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class GymEntryFormFailureState extends GymEntryFormState {
  final Failure failure;

  const GymEntryFormFailureState(this.failure) : super();

  @override
  List<Object?> get props => [failure];
}

class GymEntryFormSuccessState extends GymEntryFormState {
  final GymEntryFormSuccess response;

  const GymEntryFormSuccessState(this.response) : super();

  @override
  List<Object?> get props => [];
}
