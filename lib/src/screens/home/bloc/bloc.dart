import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:phitnest_core/core.dart';

part 'event.dart';
part 'state.dart';

extension GetHomeBloc on BuildContext {
  HomeBloc get homeBloc => BlocProvider.of(this);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(Session session)
      : super(
          HomeLoadingProfilePictureState(
            loadingOperation: CancelableOperation.fromFuture(() async {
              final request = getProfilePicture(session);
              if (request != null) {
                if ((await http.get(request.uri, headers: request.headers))
                        .statusCode ==
                    200) {
                  return Image.network(
                    request.uri.toString(),
                    headers: request.headers,
                  );
                }
              }
              return null;
            }()),
          ),
        ) {
    if (state is HomeLoadingProfilePictureState) {
      (state as HomeLoadingProfilePictureState).loadingOperation.value.then(
            (profilePicture) => add(
              HomeLoadedProfilePictureEvent(
                profilePicture: profilePicture,
              ),
            ),
          );
    }

    on<HomeLoadedProfilePictureEvent>(
      (event, emit) => emit(
        HomeLoadedProfilePictureState(
          profilePicture: event.profilePicture,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    switch (state) {
      case HomeLoadingProfilePictureState(
          loadingOperation: final loadingOperation
        ):
        await loadingOperation.cancel();
      default:
    }
    return super.close();
  }
}
