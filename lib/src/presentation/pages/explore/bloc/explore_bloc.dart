part of explore_page;

class _ExploreBloc extends Bloc<_ExploreEvent, _ExploreState> {
  final Future<Either<T, Failure>> Function<T>(
      Future<Either<T, Failure>> Function(String accessToken) f) withAuth;
  final Future<Failure?> Function(
      Future<Failure?> Function(String accessToken) f) withAuthVoid;

  _ExploreBloc({
    required this.withAuth,
    required this.withAuthVoid,
  }) : super(const _InitialState());
}
