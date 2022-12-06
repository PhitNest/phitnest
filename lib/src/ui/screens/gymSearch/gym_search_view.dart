import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
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
            SearchBox(
              hintText: 'Search',
              controller: searchController,
              keyboardType: TextInputType.streetAddress,
              onChanged: (_) => onEditSearch(),
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
