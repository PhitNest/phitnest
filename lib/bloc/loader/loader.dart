import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../aws/aws.dart';
import '../../logger.dart';

part 'event.dart';
part 'state.dart';

extension GetLoader on BuildContext {
  LoaderBloc<ReqType, ResType> loader<ReqType, ResType>() =>
      BlocProvider.of(this);

  AuthLoaderBloc<ReqType, ResType> authLoader<ReqType, ResType>() =>
      BlocProvider.of(this);
}

typedef LoaderConsumer<ReqType, ResType>
    = BlocConsumer<LoaderBloc<ReqType, ResType>, LoaderState<ResType>>;

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

typedef _Loaded = LoaderLoadedState<RefreshSessionResponse>;

typedef AuthLoaderConsumer<ReqType, ResType> = BlocConsumer<
    AuthLoaderBloc<ReqType, ResType>, LoaderState<AuthResOrLost<ResType>>>;

final class AuthLoaderBloc<ReqType, ResType> extends LoaderBloc<
    ({ReqType data, SessionBloc sessionLoader}), AuthResOrLost<ResType>> {
  AuthLoaderBloc({
    required super.initialData,
    required super.loadOnStart,
    required Future<ResType> Function(ReqType, Session) load,
  }) : super(
          load: (req) async {
            Future<AuthResOrLost<ResType>> handleResponse(
              RefreshSessionResponse response,
            ) async {
              switch (response) {
                case RefreshSessionSuccess(newSession: final newSession):
                  if (newSession.cognitoSession.isValid()) {
                    return AuthRes(await load(req.data, newSession));
                  } else {
                    req.sessionLoader.add(LoaderLoadEvent(newSession));
                    final response = await req.sessionLoader.stream.firstWhere(
                            (state) => state is _Loaded,
                            orElse: () => LoaderLoadedState(
                                RefreshSessionUnknownResponse(message: null)))
                        as _Loaded;
                    return await handleResponse(response.data);
                  }
                case RefreshSessionFailureResponse():
                  return AuthLost();
              }
            }

            switch (req.sessionLoader.state) {
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
            return const AuthLost();
          },
        );
}
