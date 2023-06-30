part of 'bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState() : super();
}

class HomeResponse extends Equatable {
  final List<UserExplore> explore;
  final Image profilePhoto;
  final List<Friendship> friends;

  const HomeResponse({
    required this.explore,
    required this.profilePhoto,
    required this.friends,
  }) : super();

  @override
  List<Object?> get props => [explore, profilePhoto, friends];
}

class HomeLoadingState extends HomeState {
  final CancelableOperation<HomeResponse?> loadingOperation;

  const HomeLoadingState({
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class HomeFailureState extends HomeState {
  const HomeFailureState() : super();

  @override
  List<Object?> get props => [];
}

class HomeLoadedState extends HomeState {
  final HomeResponse response;
  final int currPage;

  const HomeLoadedState({
    required this.response,
    required this.currPage,
  }) : super();

  @override
  List<Object?> get props => [response, currPage];
}

class HomeSendingFriendRequestState extends HomeState {
  final CancelableOperation<bool> sendingOperation;
  final HomeResponse response;
  final int currPage;

  const HomeSendingFriendRequestState({
    required this.sendingOperation,
    required this.response,
    required this.currPage,
  }) : super();

  @override
  List<Object?> get props => [sendingOperation, response, currPage];
}

class HomeSentFriendRequestState extends HomeState {
  final HomeResponse response;
  final int currPage;

  const HomeSentFriendRequestState({
    required this.response,
    required this.currPage,
  }) : super();

  @override
  List<Object?> get props => [response, currPage];
}

class HomeDeletingAccountState extends HomeState {
  final CancelableOperation<bool> deletingOperation;
  final HomeResponse response;

  const HomeDeletingAccountState({
    required this.deletingOperation,
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [deletingOperation, response];
}

class HomeDeletedAccountState extends HomeState {
  const HomeDeletedAccountState() : super();

  @override
  List<Object?> get props => [];
}
