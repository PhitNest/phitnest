part of 'bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent() : super();
}

class HomeLoadedEvent extends HomeEvent {
  final HomeResponse? response;

  const HomeLoadedEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}

class HomeTabChangedEvent extends HomeEvent {
  final int index;

  const HomeTabChangedEvent({
    required this.index,
  }) : super();

  @override
  List<Object?> get props => [index];
}
