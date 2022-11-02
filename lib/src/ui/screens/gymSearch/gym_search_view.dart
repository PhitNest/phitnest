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
  final FocusNode keyboardFocus;

  @override
  bool get disableKeyboardScroll => true;

  const GymSearchView({
    required this.onPressedConfirm,
    required this.errorMessage,
    required this.keyboardFocus,
    required this.searchController,
    required this.onEditSearch,
    required this.cards,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(children: [
        15.verticalSpace,
        SizedBox(
            width: 343.w,
            height: 32.h,
            child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.labelMedium,
                controller: searchController,
                focusNode: keyboardFocus,
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
        15.verticalSpace,
        Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView(children: cards))),
        10.verticalSpace,
        Visibility(
            visible: !keyboardFocus.hasFocus,
            child: Padding(
                padding: EdgeInsets.only(bottom: 44.h),
                child: StyledButton(
                  child: Text('CONFIRM'),
                  onPressed: onPressedConfirm,
                )))
      ]);
}
