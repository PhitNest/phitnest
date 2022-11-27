import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../nav_bar_view.dart';
import 'models/friend_model.dart';
import 'widgets/add_button.dart';

class FriendsView extends NavBarScreenView {
  final TextEditingController searchController;
  final List<FriendModel> friends;
  final List<FriendModel> requests;
  final Function() removeFriend;
  final Function() addFriend;
  final Function() ignoreRequest;

  FriendsView({
    required this.searchController,
    required this.friends,
    required this.requests,
    required this.addFriend,
    required this.ignoreRequest,
    required this.removeFriend,
  });

  @override
  int get navbarIndex => 2;

  @override
  Widget buildView(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            24.verticalSpace,
            SizedBox(
              width: 311.w,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.labelMedium,
                controller: searchController,
                keyboardType: TextInputType.streetAddress,
                onChanged: (_) => {},
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 16.w),
                  hintText: 'Search',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8)),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Color(0xFF999999)),
                ),
              ),
            ),
            24.verticalSpace,
            Text(
              'Requests',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            24.verticalSpace,
            SizedBox(
              height: 60.h * requests.length,
              width: 320.w,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Row(
                      children: [
                        Text(
                          requests[index].name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: addFriend,
                          child: AddButton(context),
                        ),
                        TextButton(
                          onPressed: ignoreRequest,
                          child: Text(
                            'IGNORE',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Text(
              'Friends',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            24.verticalSpace,
            SizedBox(
              height: 60.h * friends.length,
              width: 320.w,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Row(
                      children: [
                        Text(
                          friends[index].name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: removeFriend,
                          child: Text(
                            'REMOVE',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
}
