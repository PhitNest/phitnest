import 'package:flutter/material.dart';
import 'package:phitnest_mobile/src/ui/widgets/no_animation_page_route.dart';

import '../../../entities/entities.dart';
import '../../../use-cases/use_cases.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'friends_state.dart';
import 'friends_view.dart';

class FriendsProvider extends ScreenProvider<FriendsCubit, FriendsState> {
  final searchController = TextEditingController();
  final searchBoxKey = GlobalKey();

  FriendsProvider() : super();

  void onPressedBack(BuildContext context) => Navigator.pushAndRemoveUntil(
        context,
        NoAnimationMaterialPageRoute(
          builder: (context) => ConversationsProvider(),
        ),
        (_) => false,
      );

  @override
  Future<void> listener(
    BuildContext context,
    FriendsCubit cubit,
    FriendsState state,
  ) async {
    if (state is LoadingState) {
      Future.wait(
        [
          getFriendsUseCase.friends(),
          getFriendRequestsUseCase.getIncomingFriendRequests(),
          streamFriendRequestsUseCase.streamFriendRequests(),
        ],
      ).then(
        (responses) => responses[0].fold(
          (friends) => responses[1].fold(
            (requests) => responses[2].fold(
              (friendRequestSteam) => cubit.transitionToLoaded(
                friends: friends as List<FriendEntity>,
                requests: requests as List<PublicUserEntity>,
                searchQuery: '',
                friendRequestStream:
                    (friendRequestSteam as Stream<PublicUserEntity>).listen(
                  (friendRequest) => cubit.transitionToLoading(),
                ),
              ),
              (failure) => cubit.transitionToError(failure.message),
            ),
            (failure) => cubit.transitionToError(failure.message),
          ),
          (failure) => cubit.transitionToError(failure.message),
        ),
      );
    }
  }

  @override
  Widget builder(
    BuildContext context,
    FriendsCubit cubit,
    FriendsState state,
  ) {
    final onAddFriend = (PublicUserEntity user, int index) {
      cubit.removeRequest(index);
      cubit.addFriend(
        FriendEntity(
          id: user.id,
          cognitoId: user.cognitoId,
          firstName: user.firstName,
          lastName: user.lastName,
          gymId: user.gymId,
          since: DateTime.now(),
        ),
      );
      sendFriendRequestUseCase.sendFriendRequest(user.cognitoId).then(
        (failure) {
          if (failure != null) {
            cubit.transitionToError(failure.message);
          }
        },
      );
    };
    final onRemoveFriend = (FriendEntity friend, int index) {
      cubit.removeFriend(index);
      removeFriendUseCase.removeFriend(friend.cognitoId).then(
        (failure) {
          if (failure != null) {
            cubit.transitionToError(failure.message);
          } else {
            cubit.addRequest(friend);
          }
        },
      );
    };
    final onDenyFriend = (PublicUserEntity user, int index) {
      cubit.removeRequest(index);
      denyFriendRequestUseCase.denyFriendRequest(user.cognitoId).then(
        (failure) {
          if (failure != null) {
            cubit.transitionToError(failure.message);
          }
        },
      );
    };
    if (state is LoadingState) {
      return LoadingView(
        onPressedBack: () => onPressedBack(context),
      );
    } else if (state is ErrorState) {
      return ErrorView(
        message: state.message,
        onPressedBack: () => onPressedBack(context),
        onPressedRetry: () => cubit.transitionToLoading(),
      );
    } else if (state is NotTypingState) {
      return NotTypingView(
        onPressedBack: () => onPressedBack(context),
        searchBoxKey: searchBoxKey,
        friends: state.friends
            .where(
              (friend) => friend.fullName.toLowerCase().contains(
                    state.searchQuery.toLowerCase(),
                  ),
            )
            .toList(),
        requests: state.requests
            .where(
              (request) => request.fullName.toLowerCase().contains(
                    state.searchQuery.toLowerCase(),
                  ),
            )
            .toList(),
        searchController: searchController,
        onRemoveFriend: onRemoveFriend,
        onAddFriend: onAddFriend,
        onDenyFriend: onDenyFriend,
        onTapSearch: () => cubit.transitionToTyping(),
      );
    } else if (state is TypingState) {
      return TypingView(
        searchBoxKey: searchBoxKey,
        friends: state.friends
            .where(
              (friend) => friend.fullName.toLowerCase().contains(
                    state.searchQuery.toLowerCase(),
                  ),
            )
            .toList(),
        requests: state.requests
            .where(
              (request) => request.fullName.toLowerCase().contains(
                    state.searchQuery.toLowerCase(),
                  ),
            )
            .toList(),
        searchController: searchController,
        onRemoveFriend: onRemoveFriend,
        onAddFriend: onAddFriend,
        onDenyFriend: onDenyFriend,
        onEditSearch: () => cubit.setSearchQuery(searchController.text.trim()),
        onSubmitSearch: () => cubit.transitionStopTyping(),
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  FriendsCubit buildCubit() => FriendsCubit();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
