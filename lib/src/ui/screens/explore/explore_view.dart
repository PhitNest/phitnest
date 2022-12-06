import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';
import 'widgets/widgets.dart';

class ExploreView extends ScreenView {
  final bool holding;
  final int countdown;
  final VoidCallback onLogoTap;
  final VoidCallback onLogoRelease;
  final List<ExploreCard> cards;
  final void Function(int pageIndex) onChangePage;

  ExploreView({
    required this.holding,
    required this.countdown,
    required this.onLogoTap,
    required this.onLogoRelease,
    required this.cards,
    required this.onChangePage,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: Column(
            children: [
              ...(cards.length > 0
                  ? [
                      Flexible(
                        child: PageView.builder(
                          onPageChanged: onChangePage,
                          itemBuilder: (context, index) =>
                              cards[index % cards.length],
                        ),
                      ),
                      Text(
                        'Press and hold logo to send friend request',
                        style: theme.textTheme.bodySmall,
                      ),
                      20.verticalSpace,
                    ]
                  : [
                      200.verticalSpace,
                      Text(
                        "More friends\nare on the way.",
                        style: theme.textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      40.verticalSpace,
                      Text(
                        "The nest is still growing! Please\ncheck again later.",
                        style: theme.textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      ),
                      Expanded(child: Container()),
                    ]),
              StyledNavBar(
                navigationEnabled: true,
                pageIndex: 1,
                colorful: cards.length > 0,
                onTapDownLogo: onLogoTap,
                onTapUpLogo: onLogoRelease,
                animateLogo: !holding && cards.length > 0,
              )
            ],
          ),
        ),
      );
}
