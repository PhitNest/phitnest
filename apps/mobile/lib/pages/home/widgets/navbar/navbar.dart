import 'package:async/async.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../../../../constants/constants.dart';
import '../../../../entities/entities.dart';
import '../../home.dart';
import '../styled_indicator.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

class NavBarConsumer extends StatelessWidget {
  static double get kHeight => 66.h;
  final Widget Function(BuildContext context, NavBarState state) builder;
  final PageController pageController;

  const NavBarConsumer({
    super.key,
    required this.builder,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) => BlocConsumer<NavBarBloc, NavBarState>(
        listener: (context, navBarState) => _handleNavBarStateChanged(
          context,
          pageController,
          navBarState,
        ),
        builder: (context, state) {
          final reversed = state is NavBarReversedState;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: builder(context, state)),
              Container(
                height: NavBarConsumer.kHeight,
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
                                const NavBarPressPageEvent(NavBarPage.explore)),
                          ),
                          60.horizontalSpace,
                          StyledIndicator(
                            offset: const Size(8, 8),
                            count: state.numAlerts,
                            child: NavBarPageButton(
                              text: 'CHAT',
                              selected: state.page == NavBarPage.chat,
                              reversed: reversed,
                              onPressed: () => context.navBarBloc.add(
                                  const NavBarPressPageEvent(NavBarPage.chat)),
                            ),
                          ),
                          NavBarPageButton(
                            text: 'OPTIONS',
                            selected: state.page == NavBarPage.options,
                            reversed: reversed,
                            onPressed: () => context.navBarBloc.add(
                                const NavBarPressPageEvent(NavBarPage.options)),
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
      );
}
