import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';
import 'gymCard/gym_card.dart';

class GymSearchView extends ScreenView {
  final Function() onPressedConfirm;
  final String errorMessage;
  final TextEditingController searchController;
  final List<GymCard> cards;
  final Function() onEditSearch;

  const GymSearchView({
    required this.onPressedConfirm,
    required this.errorMessage,
    required this.searchController,
    required this.onEditSearch,
    required this.cards,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Column(children: [
        53.verticalSpace,
        Container(
            alignment: Alignment.centerLeft,
            width: 1.sw,
            margin: EdgeInsets.only(left: 16.w),
            child: BackArrowButton()),
        15.verticalSpace,
        SizedBox(
            width: 343.w,
            height: 32.h,
            child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.labelMedium,
                controller: searchController,
                keyboardType: TextInputType.streetAddress,
                onEditingComplete: onEditSearch,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 8.w),
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
                ))),
        20.verticalSpace,
        SizedBox(
            height: 390.h,
            child: SingleChildScrollView(child: Column(children: cards))),
        Expanded(child: Container()),
        StyledButton(
          child: Text('CONFIRM'),
          onPressed: onPressedConfirm,
        ),
        56.verticalSpace,
      ]));
}
