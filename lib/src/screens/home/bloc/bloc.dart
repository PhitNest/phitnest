import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:phitnest_core/core.dart';

part 'event.dart';
part 'state.dart';

class Friend extends Equatable {
  final String id;
  final String firstName;
  final String lastName;

  const Friend({
    required this.id,
    required this.firstName,
    required this.lastName,
  }) : super();

  @override
  List<Object?> get props => [id, firstName, lastName];
}

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
  final String senderId;
  final String text;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  }) : super();

  @override
  List<Object?> get props => [id, senderId, text, createdAt];
}

class Friendship extends Equatable {
  final Friend other;
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

Future<List<Friendship>?> _friends(Session session) async =>
    switch (await request(
      route: '/friendship',
      method: HttpMethod.get,
      authorization: session.session.idToken.getJwtToken(),
      parser: (json) => switch (json) {
        List() => (json)
            .map(
              (entry) => switch (entry) {
                ({
                  'id': final String id,
                  'userTuple': final dynamic userTuple,
                  'createdAt': final int createdAt,
                  'recentMessage': final dynamic recentMessage
                }) =>
                  switch (userTuple) {
                    List() => Friendship(
                        createdAt:
                            DateTime.fromMillisecondsSinceEpoch(createdAt),
                        id: id,
                        recentMessage: switch (recentMessage) {
                          ({
                            'id': final String id,
                            'text': final String text,
                            'senderId': final String senderId,
                            'createdAt': final int createdAt
                          }) =>
                            Message(
                              id: id,
                              senderId: senderId,
                              text: text,
                              createdAt: DateTime.fromMillisecondsSinceEpoch(
                                  createdAt),
                            ),
                          _ => null,
                        },
                        other: (userTuple)
                            .map(
                              (user) => switch (user) {
                                ({
                                  'accountDetails': final dynamic
                                      accountDetails,
                                  'firstName': final String firstName,
                                  'lastName': final String lastName
                                }) =>
                                  Friend(
                                    id: switch (accountDetails) {
                                      ({'id': final String id}) => id,
                                      _ => throw const Failure(
                                          'InvalidResponse',
                                          'Invalid response from server.'),
                                    },
                                    firstName: firstName,
                                    lastName: lastName,
                                  ),
                                _ => throw const Failure('InvalidResponse',
                                    'Invalid response from server.'),
                              },
                            )
                            .where((element) =>
                                element.id !=
                                session.session.accessToken.getSub()!)
                            .first,
                      ),
                    _ => throw const Failure(
                        'InvalidResponse', 'Invalid response from server.'),
                  },
                _ => throw const Failure(
                    'InvalidResponse', 'Invalid response from server.'),
              },
            )
            .toList(),
        _ => throw const Failure(
            'InvalidResponse', 'Invalid response from server.'),
      },
    )) {
      HttpResponseOk(data: final data) => data,
      HttpResponseFailure() => null,
    };

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
  final pageController = PageController();

  HomeBloc(Session session)
      : super(
          HomeLoadingState(
              loadingOperation: CancelableOperation.fromFuture(() async {
            final pfpReq = getProfilePicture(
                session, session.session.accessToken.getSub()!);
            if (pfpReq != null) {
              final profilePhoto = await http
                  .get(pfpReq.uri, headers: pfpReq.headers)
                  .then((res) => res.statusCode == 200
                      ? Image.memory(res.bodyBytes)
                      : null);
              if (profilePhoto != null) {
                final explore = await _explore(session);
                final friends = await _friends(session);
                if (friends != null && explore != null) {
                  return HomeResponse(
                    explore: explore,
                    profilePhoto: profilePhoto,
                    friends: friends,
                  );
                }
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

    on<HomeDeleteAccountEvent>(
      (event, emit) => switch (state) {
        HomeLoadedState(response: final response) => emit(
            HomeDeletingAccountState(
                response: response,
                deletingOperation: CancelableOperation.fromFuture(request(
                        method: HttpMethod.delete,
                        route: '/user',
                        parser: (_) {},
                        authorization: session.session.idToken.getJwtToken())
                    .then((res) => switch (res) {
                          HttpResponseOk() => true,
                          HttpResponseFailure() => false,
                        }))
                  ..then((deleted) =>
                      add(HomeDeleteAccountResponseEvent(deleted: deleted)))),
          ),
        _ => throw StateException(state, event),
      },
    );

    on<HomeDeleteAccountResponseEvent>(
      (event, emit) {
        if (event.deleted) {
          emit(
            const HomeDeletedAccountState(),
          );
        } else {
          emit(
            HomeLoadedState(
              response: (state as HomeDeletingAccountState).response,
              currPage: 2,
            ),
          );
        }
      },
    );

    on<HomeSendFriendRequestEvent>((event, emit) {
      if (state is HomeLoadedState) {
        final response = (state as HomeLoadedState).response;
        emit(
          HomeSendingFriendRequestState(
            response: response,
            currPage: 1,
            sendingOperation: CancelableOperation.fromFuture(
              request(
                method: HttpMethod.post,
                route: '/friendship',
                parser: (_) {},
                authorization: session.session.idToken.getJwtToken(),
                data: {
                  'receiverId':
                      response.explore[event.index % response.explore.length],
                },
              ).then(
                (res) => switch (res) {
                  HttpResponseOk() => true,
                  HttpResponseFailure() => false,
                },
              ),
            )..then((res) => add(HomeSendFriendRequestResponseEvent(
                index: res ? event.index : -1))),
          ),
        );
      }
    });

    on<HomeSendFriendRequestResponseEvent>(
      (event, emit) {
        if (event.index == -1) {
          emit(
            HomeLoadedState(
              response: (state as HomeSendingFriendRequestState).response,
              currPage: (state as HomeSendingFriendRequestState).currPage,
            ),
          );
        } else {
          final response = (state as HomeSendingFriendRequestState).response;
          var newExplore = response.explore;
          newExplore.removeAt(event.index);
          final newResponse = HomeResponse(
            explore: newExplore,
            friends: response.friends,
            profilePhoto: response.profilePhoto,
          );
          emit(
            HomeSentFriendRequestState(
              response: newResponse,
              currPage: (state as HomeSendingFriendRequestState).currPage,
            ),
          );
        }
      },
    );
  }

  @override
  Future<void> close() async {
    switch (state) {
      case HomeLoadingState(loadingOperation: final loadingOperation):
        await loadingOperation.cancel();
      case HomeSendingFriendRequestState(
          sendingOperation: final sendingOperation
        ):
        await sendingOperation.cancel();
      case HomeDeletingAccountState(deletingOperation: final deletingOperation):
        await deletingOperation.cancel();
      default:
    }
    pageController.dispose();
    return super.close();
  }
}
