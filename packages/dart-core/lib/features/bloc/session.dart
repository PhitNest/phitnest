import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../aws/aws.dart';
import 'loader/loader.dart';
import 'parallel_loader/parallel_loader.dart';

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

final class AuthReq<T> extends Equatable {
  final T data;
  final SessionBloc sessionLoader;

  const AuthReq(this.data, this.sessionLoader) : super();

  @override
  List<Object?> get props => [data, sessionLoader];
}

Future<AuthResOrLost<T>> _handleRefreshSessionResponse<T>(
        RefreshSessionResponse refreshSessionResponse,
        Future<T> Function(Session session) load) async =>
    switch (refreshSessionResponse) {
      RefreshSessionSuccess(newSession: final newSession) =>
        AuthRes(await load(newSession)),
      RefreshSessionFailureResponse(message: final message) =>
        AuthLost(message),
    };

Future<AuthResOrLost<ResType>> handleRequest<ReqType, ResType>(
  Future<ResType> Function(ReqType, Session) load,
  AuthReq<ReqType> req,
) async {
  switch (req.sessionLoader.state) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case RefreshSessionSuccess(newSession: final newSession):
          if (newSession.cognitoSession.isValid()) {
            return await _handleRefreshSessionResponse(
                response, (session) => load(req.data, session));
          } else {
            final nextResponse =
                req.sessionLoader.stream.firstWhere((event) => switch (event) {
                      LoaderLoadedState() => true,
                      _ => false,
                    }) as Future<LoaderLoadedState<RefreshSessionResponse>>;
            req.sessionLoader.add(LoaderLoadEvent(newSession));
            return await _handleRefreshSessionResponse(
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
      return await _handleRefreshSessionResponse(
          response, (session) => load(req.data, session));
    default:
  }
  final response = await getPreviousSession();
  req.sessionLoader.add(LoaderSetEvent(response));
  switch (response) {
    case RefreshSessionSuccess(newSession: final newSession):
      if (newSession.cognitoSession.isValid()) {
        return await _handleRefreshSessionResponse(
            response, (session) => load(req.data, session));
      }
    default:
  }
  return AuthLost('Could not restore session');
}

typedef SessionBloc = LoaderBloc<Session, RefreshSessionResponse>;

typedef AuthLoaderConsumer<ReqType, ResType> = BlocConsumer<
    AuthLoaderBloc<ReqType, ResType>, LoaderState<AuthResOrLost<ResType>>>;

final class AuthLoaderBloc<ReqType, ResType>
    extends LoaderBloc<AuthReq<ReqType>, AuthResOrLost<ResType>> {
  AuthLoaderBloc({
    required Future<ResType> Function(ReqType, Session) load,
    AuthReq<ReqType>? loadOnStart,
    super.initialData,
  }) : super(
          loadOnStart: loadOnStart != null ? LoadOnStart(loadOnStart) : null,
          load: (req) => handleRequest(load, req),
        );
}

typedef AuthParallelLoaderConsumer<ReqType, ResType> = BlocConsumer<
    AuthParallelLoaderBloc<ReqType, ResType>,
    ParallelLoaderState<AuthReq<ReqType>, AuthResOrLost<ResType>>>;

final class AuthParallelLoaderBloc<ReqType, ResType>
    extends ParallelLoaderBloc<AuthReq<ReqType>, AuthResOrLost<ResType>> {
  AuthParallelLoaderBloc({
    required Future<ResType> Function(ReqType, Session) load,
  }) : super(load: (req) => handleRequest(load, req));
}
