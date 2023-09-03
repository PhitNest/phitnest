part of 'home.dart';

sealed class HomeState extends Equatable {
  const HomeState() : super();
}

final class HomeLoadingState extends HomeState {
  const HomeLoadingState() : super();

  @override
  List<Object?> get props => [];
}

final class HomeLoadedState extends HomeState {
  final List<UserExplore> exploreUsers;

  const HomeLoadedState(this.exploreUsers) : super();

  @override
  List<Object?> get props => [exploreUsers];
}

sealed class HomeEvent extends Equatable {
  const HomeEvent() : super();
}

final class HomeLoadedEvent extends HomeEvent {
  final List<UserExplore> exploreUsers;

  const HomeLoadedEvent(this.exploreUsers) : super();

  @override
  List<Object?> get props => [exploreUsers];
}

final class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final pageController = PageController();

  HomeBloc() : super(const HomeLoadingState()) {
    on<HomeLoadedEvent>(
      (event, emit) {
        emit(HomeLoadedState(event.exploreUsers));
      },
    );
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}

typedef ExploreBloc = AuthLoaderBloc<void, HttpResponse<List<UserExplore>>>;
typedef ExploreConsumer
    = AuthLoaderConsumer<void, HttpResponse<List<UserExplore>>>;

typedef SendFriendRequestBloc = AuthLoaderBloc<String, HttpResponse<void>>;
typedef SendFriendRequestConsumer
    = AuthLoaderConsumer<String, HttpResponse<void>>;

typedef UserBloc = AuthLoaderBloc<void, HttpResponse<GetUserResponse>>;
typedef UserConsumer = AuthLoaderConsumer<void, HttpResponse<GetUserResponse>>;

extension on BuildContext {
  UserBloc get userBloc => authLoader();
  ExploreBloc get exploreBloc => authLoader();
  SendFriendRequestBloc get sendFriendRequestBloc => authLoader();
  HomeBloc get homeBloc => BlocProvider.of(this);
}
