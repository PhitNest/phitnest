import 'package:async/async.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/constants.dart';
import '../styled_indicator.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

void _handleNavBarStateChanged(BuildContext context, NavBarState state) {}

class NavBar extends StatelessWidget {
  static double get kHeight => 66.h;
  final Widget Function(BuildContext context, NavBarState state) builder;

  const NavBar({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => NavBarBloc(),
        child: BlocConsumer<NavBarBloc, NavBarState>(
          listener: _handleNavBarStateChanged,
          builder: (context, state) {
            final reversed = state is NavBarReversedState;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                builder(context, state),
                Container(
                  height: NavBar.kHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: reversed ? Colors.black : Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8.5,
                        spreadRadius: 0.0,
                        color: Colors.black,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 18.h),
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 12.w),
                            child: NavBarLogo(state: state),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NavBarPageButton(
                              text: 'NEWS',
                              selected: state.page == NavBarPage.news,
                              reversed: reversed,
                              onPressed: () => context.navBarBloc.add(
                                  const NavBarPressPageEvent(NavBarPage.news)),
                            ),
                            NavBarPageButton(
                              text: 'EXPLORE',
                              selected: state.page == NavBarPage.explore,
                              reversed: reversed,
                              onPressed: () => context.navBarBloc.add(
                                  const NavBarPressPageEvent(
                                      NavBarPage.explore)),
                            ),
                            60.horizontalSpace,
                            StyledIndicator(
                              offset: const Size(8, 8),
                              count: 0,
                              child: NavBarPageButton(
                                text: 'CHAT',
                                selected: state.page == NavBarPage.chat,
                                reversed: reversed,
                                onPressed: () => context.navBarBloc.add(
                                    const NavBarPressPageEvent(
                                        NavBarPage.chat)),
                              ),
                            ),
                            NavBarPageButton(
                              text: 'OPTIONS',
                              selected: state.page == NavBarPage.options,
                              reversed: reversed,
                              onPressed: () => context.navBarBloc.add(
                                  const NavBarPressPageEvent(
                                      NavBarPage.options)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}
