import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../aws/aws.dart';
import '../logger.dart';

extension GetLoader on BuildContext {
  LoaderBloc<ReqType, ResType> loader<ReqType, ResType>() =>
      BlocProvider.of(this);
}

typedef LoaderConsumer<ReqType, ResType>
    = BlocConsumer<LoaderBloc<ReqType, ResType>, LoaderState<ResType>>;

sealed class LoaderState<ResType> extends Equatable {
  const LoaderState();
}

final class LoaderInitialState<ResType> extends LoaderState<ResType> {
  const LoaderInitialState() : super();

  @override
  List<Object?> get props => [];
}

sealed class LoaderLoadingState<ResType> extends LoaderState<ResType> {
  final CancelableOperation<ResType> operation;

  const LoaderLoadingState(this.operation) : super();

  @override
  List<Object?> get props => [operation];
}

final class LoaderInitialLoadingState<ResType>
    extends LoaderLoadingState<ResType> {
  const LoaderInitialLoadingState(super.operation) : super();
}

final class LoaderRefreshingState<ResType> extends LoaderLoadingState<ResType> {
  final ResType data;

  const LoaderRefreshingState(this.data, super.operation) : super();

  @override
  List<Object?> get props => [super.props, data];
}

final class LoaderLoadedState<ResType> extends LoaderState<ResType> {
  final ResType data;

  const LoaderLoadedState(this.data) : super();

  @override
  List<Object?> get props => [data];
}

sealed class LoaderEvent<ReqType, ResType> extends Equatable {
  const LoaderEvent();
}

final class LoaderLoadEvent<ReqType, ResType>
    extends LoaderEvent<ReqType, ResType> {
  final ReqType requestData;

  const LoaderLoadEvent(this.requestData) : super();

  @override
  List<Object?> get props => [requestData];
}

final class LoaderLoadedEvent<ReqType, ResType>
    extends LoaderEvent<ReqType, ResType> {
  final ResType data;

  const LoaderLoadedEvent(this.data) : super();

  @override
  List<Object?> get props => [data];
}

final class LoaderSetEvent<ReqType, ResType>
    extends LoaderEvent<ReqType, ResType> {
  final ResType data;

  const LoaderSetEvent(this.data) : super();

  @override
  List<Object?> get props => [data];
}

final class LoaderCancelEvent<ReqType, ResType>
    extends LoaderEvent<ReqType, ResType> {
  const LoaderCancelEvent() : super();

  @override
  List<Object?> get props => [];
}

final class LoaderBloc<ReqType, ResType>
    extends Bloc<LoaderEvent<ReqType, ResType>, LoaderState<ResType>> {
  LoaderBloc({
    required Future<ResType> Function(ReqType) load,
    ResType? initialData,
    ({ReqType req})? loadOnStart,
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

extension GetSessionLoader on BuildContext {
  SessionBloc get sessionLoader => BlocProvider.of(this);
}

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
  const AuthLost() : super();

  @override
  List<Object?> get props => [];
}

final class AuthLoaderBloc<ReqType, ResType> extends LoaderBloc<
    ({ReqType data, BuildContext context}), AuthResOrLost<ResType>> {
  AuthLoaderBloc({
    required Future<ResType> Function(ReqType, Session) load,
  }) : super(
          load: (req) async {
            final sessionLoader = req.context.sessionLoader;

            Future<AuthResOrLost<ResType>> handleResponse(
              RefreshSessionResponse response,
            ) async {
              switch (response) {
                case RefreshSessionSuccess(newSession: final newSession):
                  if (newSession.cognitoSession.isValid()) {
                    return AuthRes(await load(req.data, newSession));
                  } else {
                    sessionLoader.add(LoaderLoadEvent(newSession));
                    final response = await sessionLoader.stream.firstWhere(
                            (state) => state
                                is LoaderLoadedState<RefreshSessionResponse>,
                            orElse: () => LoaderLoadedState(
                                RefreshSessionUnknownResponse(message: null)))
                        as LoaderLoadedState<RefreshSessionResponse>;
                    return await handleResponse(response.data);
                  }
                case RefreshSessionFailureResponse():
                  return AuthLost();
              }
            }

            switch (sessionLoader.state) {
              case LoaderLoadedState(data: final response):
                return await handleResponse(response);
              case LoaderLoadingState(operation: final operation):
                final response = await operation
                    .then(
                      (response) => response,
                      onCancel: () => null,
                    )
                    .value;
                if (response != null) {
                  return await handleResponse(response);
                }
              default:
            }
            return AuthLost();
          },
        );
}
