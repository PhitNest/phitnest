part of friends_page;

class FriendsPage extends StatelessWidget {
  final HomeBloc homeBloc;

  const FriendsPage({
    Key? key,
    required this.homeBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: homeBloc),
          BlocProvider<_FriendsBloc>(
            create: (context) => _FriendsBloc(
              authMethods: context.authMethods,
            ),
          ),
        ],
        child: BlocConsumer<HomeBloc, IHomeState>(
          buildWhen: true.always,
          listenWhen: true.always,
          listener: (context, state) {},
          builder: (context, homeState) =>
              BlocConsumer<_FriendsBloc, _IFriendsState>(
            buildWhen: true.always,
            listenWhen: true.always,
            listener: (context, state) {},
            builder: (context, state) {
              final filteredRequests =
                  Cache.friendship.friendsAndRequests?.requests.where(
                (request) => request.fromUser.fullName.toLowerCase().contains(
                      context.bloc.searchController.text.toLowerCase(),
                    ),
              );
              return StyledScaffold(
                body: SizedBox(
                  height: 1.sh - MediaQuery.of(context).padding.top,
                  child: Column(
                    children: [
                      StyledBackButton(),
                      Expanded(
                        child: CustomScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          slivers: [
                            SliverAppBar(
                              leading: Container(),
                              elevation: 0,
                              leadingWidth: 0,
                              backgroundColor: Colors.grey[50],
                              floating: true,
                              snap: true,
                              primary: false,
                              toolbarHeight: 50.h,
                              centerTitle: true,
                              title: Container(
                                padding: EdgeInsets.only(
                                  top: 26.h,
                                  left: 8.w,
                                  right: 8.w,
                                ),
                                child: StyledTextField(
                                  hint: 'Search',
                                  maxLines: 1,
                                  height: 70.h,
                                  errorMaxLines: 0,
                                  textInputAction: TextInputAction.search,
                                  keyboardType: TextInputType.name,
                                  width: 328.w,
                                  controller: context.bloc.searchController,
                                ),
                              ),
                            ),
                            (filteredRequests?.length ?? 1) > 0
                                ? SliverAppBar(
                                    leading: Container(),
                                    elevation: 0,
                                    leadingWidth: 0,
                                    backgroundColor: Colors.grey[50],
                                    centerTitle: true,
                                    pinned: false,
                                    title: Text(
                                      'Friend Requests',
                                      style: theme.textTheme.headlineMedium,
                                    ),
                                  )
                                : SliverToBoxAdapter(
                                    child: SizedBox.shrink(),
                                  ),
                            SliverList(
                              delegate: SliverChildListDelegate(
                                filteredRequests?.map(
                                      (request) {
                                        state as _ILoadedState;
                                        return _FriendRequestCard(
                                          user: request.fromUser,
                                          loading: state.denyingRequests
                                                  .containsKey(
                                                      request.fromUser.id) ||
                                              state.sendingRequests.containsKey(
                                                  request.fromUser.id),
                                          onAdd: () => context.bloc.add(
                                            _AddFriendEvent(request.fromUser),
                                          ),
                                          onIgnore: () => context.bloc.add(
                                            _DenyRequestEvent(request.fromUser),
                                          ),
                                        );
                                      },
                                    ).toList() ??
                                    [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(48.r),
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                    ],
                              ),
                            ),
                            SliverAppBar(
                              leading: Container(),
                              elevation: 0,
                              leadingWidth: 0,
                              backgroundColor: Colors.grey[50],
                              centerTitle: true,
                              pinned: true,
                              title: Text(
                                'Your Friends',
                                style: theme.textTheme.headlineMedium,
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate(
                                Cache.friendship.friendsAndRequests?.friendships
                                        .where(
                                          (friendship) => friendship
                                              .notMe(Cache.user.user!.cognitoId)
                                              .fullName
                                              .toLowerCase()
                                              .contains(
                                                context
                                                    .bloc.searchController.text
                                                    .toLowerCase(),
                                              ),
                                        )
                                        .map(
                                          (friendship) => _FriendCard(
                                            name: friendship
                                                .notMe(
                                                    Cache.user.user!.cognitoId)
                                                .fullName,
                                            loading: (state as _ILoadedState)
                                                .removingFriends
                                                .containsKey(friendship
                                                  ..notMe(Cache
                                                          .user.user!.cognitoId)
                                                      .id),
                                            onRemove: () => context.bloc.add(
                                              _RemoveFriendEvent(
                                                friendship.notMe(
                                                    Cache.user.user!.cognitoId),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList() ??
                                    [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(48.r),
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                    ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
}