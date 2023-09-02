import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../aws/aws.dart';
import '../../logger.dart';
part 'event.dart';
part 'state.dart';

final class LoadOnStart<T> extends Equatable {
  final T req;

  const LoadOnStart(this.req) : super();

  @override
  List<Object?> get props => [req];
}

typedef LoaderConsumer<ReqType, ResType>
    = BlocConsumer<LoaderBloc<ReqType, ResType>, LoaderState<ResType>>;

final class LoaderBloc<ReqType, ResType>
    extends Bloc<LoaderEvent<ReqType, ResType>, LoaderState<ResType>> {
  LoaderBloc({
    required Future<ResType> Function(ReqType) load,
    ResType? initialData,
    LoadOnStart<ReqType>? loadOnStart,
  }) : super(initialData != null
            ? loadOnStart != null
                ? LoaderRefreshingState(initialData,
                    CancelableOperation.fromFuture(load(loadOnStart.req)))
                : LoaderLoadedState(initialData)
            : loadOnStart != null
                ? LoaderInitialLoadingState(
                    CancelableOperation.fromFuture(load(loadOnStart.req)))
                : LoaderInitialState()) {
    switch (state) {
      case LoaderLoadingState(operation: final operation) ||
            LoaderRefreshingState(operation: final operation):
        operation.then((response) => add(LoaderLoadedEvent(response)));
      case LoaderLoadedState() || LoaderInitialState():
    }
    on<LoaderLoadEvent<ReqType, ResType>>(
      (event, emit) {
        CancelableOperation<ResType> operation() =>
            CancelableOperation.fromFuture(load(event.requestData))
              ..then((response) => add(LoaderLoadedEvent(response)));
        switch (state) {
          case LoaderLoadingState():
            badState(state, event);
          case LoaderInitialState():
            emit(LoaderInitialLoadingState(operation()));
          case LoaderLoadedState(data: final data):
            emit(LoaderRefreshingState(data, operation()));
        }
      },
    );

    on<LoaderLoadedEvent<ReqType, ResType>>(
      (event, emit) {
        switch (state) {
          case LoaderLoadingState():
            emit(LoaderLoadedState(event.data));
          case LoaderLoadedState() || LoaderInitialState():
            badState(state, event);
        }
      },
    );

    on<LoaderSetEvent<ReqType, ResType>>(
      (event, emit) async {
        switch (state) {
          case LoaderLoadingState(operation: final operation) ||
                LoaderRefreshingState(operation: final operation):
            await operation.cancel();
          case LoaderLoadedState() || LoaderInitialState():
        }
        emit(LoaderLoadedState(event.data));
      },
    );

    on<LoaderCancelEvent<ReqType, ResType>>(
      (event, emit) async {
        switch (state) {
          case LoaderRefreshingState(
              operation: final operation,
              data: final data
            ):
            await operation.cancel();
            emit(LoaderLoadedState(data));
          case LoaderLoadingState(operation: final operation):
            await operation.cancel();
            emit(LoaderInitialState());
          case LoaderLoadedState() || LoaderInitialState():
        }
      },
    );
  }

  @override
  Future<void> close() async {
    switch (state) {
      case LoaderLoadingState(operation: final operation):
        await operation.cancel();
      case LoaderLoadedState() || LoaderInitialState():
    }
    return super.close();
  }
}

typedef SessionBloc = LoaderBloc<Session, RefreshSessionResponse>;

sealed class AuthResOrLost<ResType> extends Equatable {
  const AuthResOrLost() : super();
}

final class AuthRes<ResType> extends AuthResOrLost<ResType> {
  final ResType data;

  const AuthRes(this.data) : super();

  @override
  List<Object?> get props => [data];
}

final class AuthLost<ResType> extends AuthResOrLost<ResType> {
  final String message;

  const AuthLost(this.message) : super();

  @override
  List<Object?> get props => [message];
}

typedef AuthLoaderConsumer<ReqType, ResType> = BlocConsumer<
    AuthLoaderBloc<ReqType, ResType>, LoaderState<AuthResOrLost<ResType>>>;

final class AuthReq<T> extends Equatable {
  final T data;
  final SessionBloc sessionLoader;

  const AuthReq(this.data, this.sessionLoader) : super();

  @override
  List<Object?> get props => [data, sessionLoader];
}

Future<AuthResOrLost<T>> handleRefreshSessionResponse<T>(
        RefreshSessionResponse refreshSessionResponse,
        Future<T> Function(Session session) load) async =>
    switch (refreshSessionResponse) {
      RefreshSessionSuccess(newSession: final newSession) =>
        AuthRes(await load(newSession)),
      RefreshSessionFailureResponse(message: final message) =>
        AuthLost(message),
    };

final class AuthLoaderBloc<ReqType, ResType>
    extends LoaderBloc<AuthReq<ReqType>, AuthResOrLost<ResType>> {
  AuthLoaderBloc({
    required Future<ResType> Function(ReqType, Session) load,
    AuthReq<ReqType>? loadOnStart,
    super.initialData,
  }) : super(
          loadOnStart: loadOnStart != null ? LoadOnStart(loadOnStart) : null,
          load: (req) async {
            switch (req.sessionLoader.state) {
              case LoaderLoadedState(data: final response):
                switch (response) {
                  case RefreshSessionSuccess(newSession: final newSession):
                    if (newSession.cognitoSession.isValid()) {
                      return await handleRefreshSessionResponse(
                          response, (session) => load(req.data, session));
                    } else {
                      final nextResponse = req.sessionLoader.stream
                              .firstWhere((event) => switch (event) {
                                    LoaderLoadedState() => true,
                                    _ => false,
                                  })
                          as Future<LoaderLoadedState<RefreshSessionResponse>>;
                      req.sessionLoader.add(LoaderLoadEvent(newSession));
                      return await handleRefreshSessionResponse(
                          (await nextResponse).data,
                          (session) => load(req.data, session));
                    }
                  default:
                }
              case LoaderLoadingState(operation: final operation):
                final response = await operation.valueOrCancellation();
                if (response == null) {
                  return AuthLost('Operation canceled');
                }
                return await handleRefreshSessionResponse(
                    response, (session) => load(req.data, session));
              default:
            }
            final response = await getPreviousSession();
            req.sessionLoader.add(LoaderSetEvent(response));
            switch (response) {
              case RefreshSessionSuccess(newSession: final newSession):
                if (newSession.cognitoSession.isValid()) {
                  return await handleRefreshSessionResponse(
                      response, (session) => load(req.data, session));
                }
              default:
            }
            return AuthLost('Could not restore session');
          },
        );
}
