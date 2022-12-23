import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../use-cases/use_cases.dart';
import '../screen_provider.dart';
import 'friends_state.dart';
import 'friends_view.dart';

class FriendsProvider extends ScreenProvider<FriendsCubit, FriendsState> {
  final searchController = TextEditingController();
  final searchBoxKey = GlobalKey();

  FriendsProvider() : super();

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
          getFriendRequestsUseCase.getFriendRequests(),
        ],
      ).then(
        (responses) => responses[0].fold(
          (friends) => responses[1].fold(
            (requests) => cubit.transitionToLoaded(
              friends: friends as List<FriendEntity>,
              requests: requests,
              searchQuery: '',
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
    };
    final onRemoveFriend =
        (FriendEntity friend, int index) => cubit.removeFriend(index);
    final onDenyFriend =
        (PublicUserEntity user, int index) => cubit.removeRequest(index);
    if (state is LoadingState) {
      return LoadingView();
    } else if (state is ErrorState) {
      return ErrorView(
        message: state.message,
        onPressedRetry: () => cubit.transitionToLoading(),
      );
    } else if (state is LoadedState) {
      return LoadedView(
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
        onSubmitSearch: () => cubit.transitionTypingToLoaded(),
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
