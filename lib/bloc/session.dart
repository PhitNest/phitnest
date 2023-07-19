import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cognito/cognito.dart';
import 'loader.dart';

typedef SessionBloc = LoaderBloc<Session, RefreshSessionResponse>;

extension GetSessionLoader on BuildContext {
  SessionBloc get sessionLoader => BlocProvider.of(this);
}

extension GetSession on SessionBloc {
  Future<Session?> get session async {
    Future<Session?> handleResponse(RefreshSessionResponse response) async {
      switch (response) {
        case RefreshSessionSuccess(newSession: final newSession):
          if (newSession.cognitoSession.isValid()) {
            return newSession;
          } else {
            add(LoaderLoadEvent(newSession));
            final response =
                await stream.firstWhere(
                        (state) =>
                            state is LoaderLoadedState<RefreshSessionResponse>,
                        orElse: () => LoaderLoadedState(
                            RefreshSessionUnknownResponse(message: null)))
                    as LoaderLoadedState<RefreshSessionResponse>;
            return await handleResponse(response.data);
          }
        case RefreshSessionFailureResponse():
          return null;
      }
    }

    switch (state) {
      case LoaderLoadedState(data: final response):
        return await handleResponse(response);
      case LoaderLoadingState(operation: final operation):
        final response = await operation
            .then(
              (response) => response,
              onCancel: () => null,
            )
            .value;
        return response != null ? await handleResponse(response) : null;
      case LoaderInitialState():
        return null;
    }
  }
}
