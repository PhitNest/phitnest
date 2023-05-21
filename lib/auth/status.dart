part of 'auth.dart';

Future<HttpResponse<Auth>> requestServerStatus() => request(
      route: '/status',
      method: HttpMethod.get,
      parser: (status) => Auth.fromJson(status),
    );

sealed class CognitoStatusState extends Equatable {
  const CognitoStatusState() : super();
}

sealed class CognitoStatusLoadingState extends CognitoStatusState {
  final CancelableOperation<HttpResponse<Auth>> loadingOperation;

  const CognitoStatusLoadingState({
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class CognitoStatusInitialState extends CognitoStatusLoadingState {
  const CognitoStatusInitialState({
    required super.loadingOperation,
  }) : super();
}

class CognitoStatusReloadingState extends CognitoStatusLoadingState {
  final Failure failure;

  const CognitoStatusReloadingState({
    required super.loadingOperation,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}

class CognitoStatusLoadedState extends CognitoStatusState {
  final Auth auth;

  const CognitoStatusLoadedState({
    required this.auth,
  }) : super();

  @override
  List<Object?> get props => [auth];
}

class CognitoStatusEvent extends Equatable {
  final HttpResponse<Auth> response;

  const CognitoStatusEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}

class CognitoStatusBloc extends Bloc<CognitoStatusEvent, CognitoStatusState> {
  CognitoStatusBloc()
      : super(
          CognitoStatusInitialState(
            loadingOperation:
                CancelableOperation.fromFuture(requestServerStatus()),
          ),
        ) {
    if (state is CognitoStatusLoadingState) {
      (state as CognitoStatusLoadingState).loadingOperation.then(
            (response) => add(
              CognitoStatusEvent(response: response),
            ),
          );
    }
    on<CognitoStatusEvent>(
      (event, emit) => switch (event) {
        CognitoStatusEvent(response: final response) => emit(
            switch (response) {
              HttpResponseOk(data: final auth) =>
                CognitoStatusLoadedState(auth: auth),
              HttpResponseFailure(failure: final failure) =>
                CognitoStatusReloadingState(
                  loadingOperation:
                      CancelableOperation.fromFuture(requestServerStatus())
                        ..then(
                          (response) => add(
                            CognitoStatusEvent(response: response),
                          ),
                        ),
                  failure: failure,
                ),
            },
          ),
      },
    );
  }
}
