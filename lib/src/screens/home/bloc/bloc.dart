import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:phitnest_core/core.dart';

part 'event.dart';
part 'state.dart';

class UserExplore extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final Image profilePicture;

  const UserExplore({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  }) : super();

  @override
  List<Object?> get props => [id, firstName, lastName, profilePicture];
}

class Message extends Equatable {
  final String id;
  final UserExplore sender;
  final String text;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.sender,
    required this.text,
    required this.createdAt,
  }) : super();

  @override
  List<Object?> get props => [id, sender, text, createdAt];
}

class Friendship extends Equatable {
  final UserExplore other;
  final DateTime createdAt;
  final String id;
  final Message? recentMessage;

  const Friendship({
    required this.other,
    required this.createdAt,
    required this.id,
    required this.recentMessage,
  }) : super();

  @override
  List<Object?> get props => [other, createdAt, id, recentMessage];
}

// Future<List<Friendship>?> _friends(Session session) async =>
//     request(route: '/friendship');

Future<List<UserExplore>?> _explore(Session session) async => request(
      route: '/explore',
      method: HttpMethod.get,
      authorization: session.session.idToken.getJwtToken(),
      parser: (json) => switch (json) {
        List() => (json)
            .map(
              (entry) => switch (entry) {
                ({
                  'accountDetails': final dynamic accountDetails,
                  'firstName': final String firstName,
                  'lastName': final String lastName
                }) =>
                  (
                    id: switch (accountDetails) {
                      ({'id': final String id}) => id,
                      _ => throw const Failure(
                          'InvalidResponse', 'Invalid response from server.'),
                    },
                    firstName: firstName,
                    lastName: lastName,
                  ),
                _ => throw const Failure(
                    'InvalidResponse', 'Invalid response from server.'),
              },
            )
            .toList(),
        _ => throw const Failure(
            'InvalidResponse', 'Invalid response from server.'),
      },
    ).then(
      (res) async => switch (res) {
        HttpResponseOk(data: final data) => Future.wait(
            data.map(
              (entry) async {
                final pfpReq = getProfilePicture(
                  session,
                  entry.id,
                );
                if (pfpReq != null) {
                  return UserExplore(
                    id: entry.id,
                    firstName: entry.firstName,
                    lastName: entry.lastName,
                    profilePicture: Image.memory(
                      (await http.get(
                        pfpReq.uri,
                        headers: pfpReq.headers,
                      ))
                          .bodyBytes,
                    ),
                  );
                }
                return null;
              },
            ),
          ).then(
            (users) => users
                .where((element) =>
                    element != null &&
                    element.id != session.session.accessToken.getSub())
                .cast<UserExplore>()
                .toList(),
          ),
        HttpResponseFailure() => null,
      },
    );

extension GetHomeBloc on BuildContext {
  HomeBloc get homeBloc => BlocProvider.of(this);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(Session session)
      : super(
          HomeLoadingState(
              loadingOperation: CancelableOperation.fromFuture(() async {
            final explore = await _explore(session);
            final pfpReq = getProfilePicture(
                session, session.session.accessToken.getSub()!);
            if (pfpReq != null) {
              final profilePhoto = await http
                  .get(pfpReq.uri, headers: pfpReq.headers)
                  .then((res) => Image.memory(res.bodyBytes));
              if (explore != null) {
                return HomeResponse(
                    explore: explore, profilePhoto: profilePhoto);
              }
            }
            throw const Failure('InvalidResponse',
                'Invalid response from server. Please try again later.');
          }())),
        ) {
    if (state is HomeLoadingState) {
      (state as HomeLoadingState).loadingOperation.value.then(
            (res) => add(
              HomeLoadedEvent(
                response: res,
              ),
            ),
          );
    }

    on<HomeLoadedEvent>(
      (event, emit) => emit(
        event.response != null
            ? HomeLoadedState(
                response: event.response!,
                currPage: 0,
              )
            : const HomeFailureState(),
      ),
    );

    on<HomeTabChangedEvent>((event, emit) => switch (state) {
          HomeLoadedState(response: final response) => emit(
              HomeLoadedState(
                response: response,
                currPage: event.index,
              ),
            ),
          _ => throw StateException(state, event),
        });
  }

  @override
  Future<void> close() async {
    switch (state) {
      case HomeLoadingState(loadingOperation: final loadingOperation):
        await loadingOperation.cancel();
      default:
    }
    return super.close();
  }
}
