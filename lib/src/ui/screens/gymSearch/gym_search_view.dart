import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';
import 'widgets/gym_card.dart';

class GymSearchView extends ScreenView {
  final Function() onPressedConfirm;
  final String errorMessage;
  final TextEditingController searchController;
  final List<GymCard> cards;
  final Function() onEditSearch;
  final bool keyboardVisible;

  const GymSearchView({
    required this.onPressedConfirm,
    required this.errorMessage,
    required this.searchController,
    required this.onEditSearch,
    required this.keyboardVisible,
    required this.cards,
  }) : super();

  @override
  double get appBarHeight => keyboardVisible ? 20.h : super.appBarHeight;

  @override
  Widget get backButton => keyboardVisible ? Container() : super.backButton;

  @override
  Widget buildView(BuildContext context) => Column(children: [
        15.verticalSpace,
        SizedBox(
            width: 343.w,
            height: 32.h,
            child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.labelMedium,
                controller: searchController,
                keyboardType: TextInputType.streetAddress,
                onChanged: (_) => onEditSearch(),
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
                ))),
        12.verticalSpace,
        Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView(children: cards))),
        keyboardVisible ? 285.verticalSpace : 10.verticalSpace,
        Visibility(
            visible: !keyboardVisible,
            child: Padding(
                padding: EdgeInsets.only(bottom: 80.h),
                child: StyledButton(
                  child: Text('CONFIRM'),
                  onPressed: onPressedConfirm,
                )))
      ]);
}
