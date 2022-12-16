import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/ui/widgets/bottom_nav_bar.dart';

import '../view.dart';

class ComingSoonView extends ScreenView {
  final VoidCallback onPressedLogo;
  final int pageIndex;

  const ComingSoonView({
    required this.onPressedLogo,
    required this.pageIndex,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Column(
            children: [
              200.verticalSpace,
                Text(
                  'This feature is coming in the next update!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge,
                ),
              Expanded(child: Container()),
              StyledNavBar(
                navigationEnabled: true,
                pageIndex: pageIndex,
                onTapDownLogo: onPressedLogo,
              ),
            ],
          ),
        ),
      );
}
