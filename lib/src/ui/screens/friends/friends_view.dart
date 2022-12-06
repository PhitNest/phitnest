import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';
import '../view.dart';
import 'widgets/widgets.dart';

class FriendsView extends ScreenView {
  final TextEditingController searchController;
  final List<FriendCard> friends;
  final List<RequestCard> requests;
  final VoidCallback onEditSearch;

  FriendsView({
    required this.searchController,
    required this.friends,
    required this.requests,
    required this.onEditSearch,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: 1.sh,
            child: Column(
              children: [
                40.verticalSpace,
                BackArrowButton(),
                SearchBox(
                  hintText: 'Search',
                  controller: searchController,
                  keyboardType: TextInputType.name,
                  onChanged: (_) => onEditSearch(),
                ),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
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
                      ).createShader(bounds);
                    },
                    child: SingleChildScrollView(
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
                                    ...requests,
                                    24.verticalSpace,
                                  ]
                                : []),
                            Text(
                              'Friends',
                              style: theme.textTheme.headlineMedium,
                            ),
                            12.verticalSpace,
                            ...(friends.length > 0
                                ? friends
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
                StyledNavBar(
                  navigationEnabled: true,
                  pageIndex: 2,
                  onTapDownLogo: () => Navigator.pushAndRemoveUntil(
                    context,
                    NoAnimationMaterialPageRoute(
                      builder: (context) => const ExploreProvider(),
                    ),
                    (_) => false,
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
