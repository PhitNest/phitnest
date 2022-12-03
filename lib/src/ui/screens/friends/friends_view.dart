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
              ),
            ),
            24.verticalSpace,
            Text(
              'Requests',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            24.verticalSpace,
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 32.w,
                right: 32.w,
              ),
              itemCount: requests.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: Row(
                  children: [
                    Text(
                      requests[index].name,
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: addFriend,
                      child: AddButton(context),
                    ),
                    28.horizontalSpace,
                    TextButton(
                      onPressed: ignoreRequest,
                      child: Text(
                        'IGNORE',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Friends',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            24.verticalSpace,
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: 40.h,
                left: 32.w,
                right: 32.w,
              ),
              itemCount: friends.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: Row(
                  children: [
                    Text(
                      friends[index].name,
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
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
