part of explore_page;

class _ExploreBloc extends Bloc<_ExploreEvent, _ExploreState> {
  final Future<Either<T, Failure>> Function<T>(
      Future<Either<T, Failure>> Function(String accessToken) f) withAuth;
  final Future<Failure?> Function(
      Future<Failure?> Function(String accessToken) f) withAuthVoid;
  final Stream<PressType> logoPressStream;
  final UserExploreResponse? initialData;
  final String gymId;

  _ExploreBloc({
    required this.withAuth,
    required this.withAuthVoid,
    required this.logoPressStream,
    required this.initialData,
    required this.gymId,
  }) : super(const _InitialState()) {
    on<_ReleaseEvent>(onRelease);
    on<_PressDownEvent>(onPressDown);
    on<_IncrementCountdownEvent>(onIncrementCountdown);
    on<_LoadEvent>(onLoad);
    on<_LoadWithInitialEvent>(onLoadWithInitial);
    on<_LoadingErrorEvent>(onLoadingError);
    on<_LoadedEvent>(onLoaded);
    if (state is _InitialState) {
      if (initialData != null) {
        add(_LoadWithInitialEvent(initialData!));
      } else {
        add(const _LoadEvent());
      }
    }
  }

  @override
  Future<void> close() async {
    if (state is _HoldingState) {
      final _HoldingState state = this.state as _HoldingState;
      await state.incrementCountdown.cancel();
    }
    if (state is _LoadingState) {
      final _LoadingState state = this.state as _LoadingState;
      await state.explore.cancel();
    }
    if (state is _ReloadingState) {
      final _ReloadingState state = this.state as _ReloadingState;
      await state.explore.cancel();
    }
    super.close();
  }
}
