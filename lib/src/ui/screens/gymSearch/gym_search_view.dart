import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/widgets.dart';
import '../view.dart';
import 'widgets/gym_card.dart';

class GymSearchView extends ScreenView {
  final VoidCallback onPressedConfirm;
  final String errorMessage;
  final TextEditingController searchController;
  final List<GymCard> cards;
  final VoidCallback onEditSearch;
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
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
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
                  hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Color(0xFF999999),
                      ),
                ),
              ),
            ),
            12.verticalSpace,
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                      stops: [0, 0.02, 0.9, 1],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds);
                  },
                  child: ListView(children: cards),
                ),
              ),
            ),
            keyboardVisible ? 285.verticalSpace : 10.verticalSpace,
            Visibility(
              visible: !keyboardVisible,
              child: Padding(
                padding: EdgeInsets.only(bottom: 80.h),
                child: StyledButton(
                  child: Text('CONFIRM'),
                  onPressed: onPressedConfirm,
                ),
              ),
            ),
          ],
        ),
      );
}
