part of 'bloc.dart';

sealed class GymEntryFormEvent extends Equatable {
  const GymEntryFormEvent() : super();
}

class GymEntryFormSubmitEvent extends GymEntryFormEvent {
  const GymEntryFormSubmitEvent() : super();

  @override
  List<Object?> get props => [];
}

class GymEntryFormResetEvent extends GymEntryFormEvent {
  const GymEntryFormResetEvent() : super();

  @override
  List<Object?> get props => [];
}

class GymEntryFormResponseEvent extends GymEntryFormEvent {
  final HttpResponse<GymEntryFormSuccess> response;

  const GymEntryFormResponseEvent(this.response) : super();

  @override
  List<Object?> get props => [response];
}
