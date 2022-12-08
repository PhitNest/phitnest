import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';
import 'widgets/widgets.dart';

class GymSearchView extends ScreenView {
  final VoidCallback onPressedConfirm;
  final String? errorMessage;
  final TextEditingController searchController;
  final List<GymCard>? cards;
  final VoidCallback onEditSearch;
  final bool showConfirmButton;
  final VoidCallback onTapSearch;
  final FocusNode searchFocus;
  final VoidCallback onPressRetry;

  const GymSearchView({
    required this.onPressedConfirm,
    required this.errorMessage,
    required this.searchController,
    required this.onEditSearch,
    required this.cards,
    required this.showConfirmButton,
    required this.onTapSearch,
    required this.searchFocus,
    required this.onPressRetry,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SizedBox(
            height: 1.sh,
            child: Column(
              children: [
                40.verticalSpace,
                BackArrowButton(),
                Visibility(
                  visible: cards == null,
                  child: 200.verticalSpace,
                ),
                Visibility(
                  visible: errorMessage != null,
                  child: Column(
                    children: [
                      Text(
                        errorMessage ?? '',
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: Colors.red,
                        ),
                      ),
                      30.verticalSpace,
                      StyledButton(
                        child: Text('RETRY'),
                        onPressed: onPressRetry,
                      )
                    ],
                  ),
                ),
                cards != null
                    ? Expanded(
                        child: Column(
                          children: [
                            SearchBox(
                              onTap: onTapSearch,
                              hintText: 'Search',
                              focusNode: searchFocus,
                              controller: searchController,
                              keyboardType: TextInputType.streetAddress,
                              onChanged: (_) => onEditSearch(),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) =>
                                      LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.05),
                                      Colors.white,
                                      Colors.white,
                                      Colors.white.withOpacity(0.05)
                                    ],
                                    stops: [0, 0.02, 0.95, 1],
                                    tileMode: TileMode.mirror,
                                  ).createShader(bounds),
                                  child: ListView.builder(
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    itemCount: cards!.length,
                                    itemBuilder: (context, index) =>
                                        cards![index],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showConfirmButton,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: 40.h, top: 8.h),
                                child: StyledButton(
                                  child: Text('CONFIRM'),
                                  onPressed: onPressedConfirm,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Visibility(
                  visible: cards == null && errorMessage == null,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      );
}
