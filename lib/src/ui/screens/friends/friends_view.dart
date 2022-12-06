import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
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
          child: Column(
            children: [
              40.verticalSpace,
              BackArrowButton(),
              12.verticalSpace,
              Container(
                width: 0.9.sw,
                child: Column(
                  children: [
                    SearchBox(
                      hintText: 'Search',
                      controller: searchController,
                      keyboardType: TextInputType.name,
                      onChanged: (_) => onEditSearch(),
                    ),
                    24.verticalSpace,
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
            ],
          ),
        ),
      );
}
