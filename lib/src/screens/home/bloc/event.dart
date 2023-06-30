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

class HomeSendFriendRequestEvent extends HomeEvent {
  final int index;

  const HomeSendFriendRequestEvent({
    required this.index,
  }) : super();

  @override
  List<Object?> get props => [index];
}

class HomeSendFriendRequestResponseEvent extends HomeEvent {
  final int index;

  const HomeSendFriendRequestResponseEvent({
    required this.index,
  }) : super();

  @override
  List<Object?> get props => [index];
}

class HomeDeleteAccountEvent extends HomeEvent {
  const HomeDeleteAccountEvent() : super();

  @override
  List<Object?> get props => [];
}

class HomeDeleteAccountResponseEvent extends HomeEvent {
  final bool deleted;

  const HomeDeleteAccountResponseEvent({
    required this.deleted,
  }) : super();

  @override
  List<Object?> get props => [deleted];
}
