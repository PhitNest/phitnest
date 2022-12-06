import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/ui/widgets/back_arrow_button.dart';

import '../../../entities/entities.dart';
import '../../theme.dart';
import '../view.dart';
import 'widgets/add_button.dart';

class FriendsView extends ScreenView {
  final TextEditingController searchController;
  final List<PublicUserEntity> friends;
  final List<PublicUserEntity> requests;
  final VoidCallback removeFriend;
  final VoidCallback addFriend;
  final VoidCallback ignoreRequest;

  FriendsView({
    required this.searchController,
    required this.friends,
    required this.requests,
    required this.addFriend,
    required this.ignoreRequest,
    required this.removeFriend,
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
                    TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: theme.textTheme.labelMedium,
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
                        hintStyle: theme.textTheme.labelMedium!
                            .copyWith(color: Color(0xFF999999)),
                      ),
                    ),
                    24.verticalSpace,
                    Text(
                      'Requests',
                      style: theme.textTheme.headlineMedium,
                    ),
                    24.verticalSpace,
                    ...requests.map(
                      (req) => Padding(
                        padding: EdgeInsets.only(
                          bottom: 24.h,
                        ),
                        child: Row(
                          children: [
                            Text(
                              req.fullName,
                              style: theme.textTheme.headlineMedium!.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: addFriend,
                              child: AddButton(),
                            ),
                            12.horizontalSpace,
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.transparent,
                              ),
                              child: Text(
                                'IGNORE',
                                style: theme.textTheme.bodySmall!
                                    .copyWith(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    24.verticalSpace,
                    Text(
                      'Friends',
                      style: theme.textTheme.headlineMedium,
                    ),
                    12.verticalSpace,
                    ...friends.map(
                      (friend) => Padding(
                        padding: EdgeInsets.only(
                          bottom: 12.h,
                        ),
                        child: Row(
                          children: [
                            Text(
                              friend.fullName,
                              style: theme.textTheme.headlineMedium!.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: removeFriend,
                              child: Text(
                                'REMOVE',
                                style: theme.textTheme.bodySmall!
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
