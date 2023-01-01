import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../entities/entities.dart';
import '../../theme.dart';
import '../../widgets/widgets.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onPressedBack;
  final VoidCallback onPressedRetry;

  const ErrorView({
    required this.message,
    required this.onPressedRetry,
    required this.onPressedBack,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        useBackButton: true,
        onPressedBack: onPressedBack,
        body: Column(
          children: [
            200.verticalSpace,
            Text(
              message,
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            StyledButton(
              onPressed: onPressedRetry,
              child: Text('RETRY'),
            ),
          ],
        ),
      );
}

class LoadingView extends StatelessWidget {
  final VoidCallback onPressedBack;

  const LoadingView({
    required this.onPressedBack,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        useBackButton: true,
        onPressedBack: onPressedBack,
        body: Column(
          children: [
            120.verticalSpace,
            CircularProgressIndicator(),
          ],
        ),
      );
}

class NotTypingView extends _BaseWidget {
  final VoidCallback onPressedBack;

  const NotTypingView({
    required super.searchController,
    required super.friends,
    required super.requests,
    required super.onRemoveFriend,
    required super.onAddFriend,
    required super.onDenyFriend,
    required super.onTapSearch,
    required super.searchBoxKey,
    required this.onPressedBack,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        useBackButton: true,
        onPressedBack: onPressedBack,
        body: super.build(context),
      );
}

class TypingView extends _BaseWidget {
  const TypingView({
    required super.searchController,
    required super.friends,
    required super.requests,
    required super.onRemoveFriend,
    required super.onAddFriend,
    required super.onDenyFriend,
    required super.onEditSearch,
    required super.onSubmitSearch,
    required super.searchBoxKey,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
      body: Padding(
          padding: EdgeInsets.only(top: 40.h), child: super.build(context)));
}

class _BaseWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback? onEditSearch;
  final List<FriendEntity> friends;
  final List<PublicUserEntity> requests;
  final void Function(FriendEntity friend, int index) onRemoveFriend;
  final void Function(PublicUserEntity user, int index) onAddFriend;
  final void Function(PublicUserEntity user, int index) onDenyFriend;
  final VoidCallback? onSubmitSearch;
  final VoidCallback? onTapSearch;
  final GlobalKey searchBoxKey;

  const _BaseWidget({
    required this.searchController,
    required this.friends,
    required this.requests,
    required this.onRemoveFriend,
    required this.onAddFriend,
    required this.onDenyFriend,
    required this.searchBoxKey,
    this.onEditSearch,
    this.onSubmitSearch,
    this.onTapSearch,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SearchBox(
            textFieldKey: searchBoxKey,
            hintText: 'Search',
            controller: searchController,
            keyboardType: TextInputType.name,
            onChanged: onEditSearch != null ? (_) => onEditSearch!() : null,
            onSubmitted:
                onSubmitSearch != null ? (_) => onSubmitSearch!() : null,
            onTap: onTapSearch != null ? () => onTapSearch!() : null,
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white,
                  Colors.white,
                  Colors.white.withOpacity(0.05)
                ],
                stops: [0, 0.03, 0.95, 1],
                tileMode: TileMode.mirror,
              ).createShader(bounds),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 0.05.sw,
                    right: 0.05.sw,
                    top: 16.h,
                  ),
                  width: 0.9.sw,
                  child: Column(
                    children: [
                      ...(requests.length > 0
                          ? [
                              Text(
                                'Requests',
                                style: theme.textTheme.headlineMedium,
                              ),
                              24.verticalSpace,
                              ...(requests.asMap().entries.map(
                                    (pair) => _RequestCard(
                                      user: pair.value,
                                      onAdd: () => onAddFriend(
                                        pair.value,
                                        pair.key,
                                      ),
                                      onIgnore: () => onDenyFriend(
                                        pair.value,
                                        pair.key,
                                      ),
                                    ),
                                  )),
                              24.verticalSpace,
                            ]
                          : []),
                      Text(
                        'Friends',
                        style: theme.textTheme.headlineMedium,
                      ),
                      12.verticalSpace,
                      ...(friends.length > 0
                          ? friends.asMap().entries.map(
                                (pair) => _FriendCard(
                                  name: pair.value.fullName,
                                  onRemove: () => onRemoveFriend(
                                    pair.value,
                                    pair.key,
                                  ),
                                ),
                              )
                          : [
                              Text(
                                searchController.text.length > 0
                                    ? "No results for: \"${searchController.text}\""
                                    : "You have not made any friends yet",
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium,
                              ),
                            ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

class _RequestCard extends StatelessWidget {
  final PublicUserEntity user;
  final VoidCallback onAdd;
  final VoidCallback onIgnore;

  const _RequestCard({
    Key? key,
    required this.user,
    required this.onAdd,
    required this.onIgnore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: 24.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                user.fullName,
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            StyledButton(
              interiorPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              onPressed: onAdd,
              backgroundColor: Color(0xFFFFE3E3),
              child: Text(
                'ADD',
                style: theme.textTheme.bodySmall!.copyWith(color: Colors.black),
              ),
            ),
            12.horizontalSpace,
            StyledButton(
              interiorPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              onPressed: onIgnore,
              backgroundColor: Colors.transparent,
              child: Text(
                'IGNORE',
                style: theme.textTheme.bodySmall!.copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      );
}

class _FriendCard extends StatelessWidget {
  final String name;
  final VoidCallback onRemove;

  const _FriendCard({
    Key? key,
    required this.name,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: 24.h,
        ),
        child: Row(
          children: [
            Text(
              name,
              style: theme.textTheme.headlineMedium!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            StyledButton(
              interiorPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              onPressed: onRemove,
              backgroundColor: Colors.transparent,
              child: Text(
                'REMOVE',
                style: theme.textTheme.bodySmall!.copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      );
}
