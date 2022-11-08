import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/widgets.dart';
import 'screens.dart';
import 'view.dart';

abstract class NavBarScreenView extends ScreenView {
  const NavBarScreenView() : super();

  /// Defines whether or not the user is currently holding the logo
  bool get currentlyHoldingLogo => false;

  /// The current navbar page index. Set to null to hide nav bar.
  int get navbarIndex;

  /// Controls whether navigation from the nav bar is enabled
  bool get navigationEnabled => true;

  /// Controls what to do when the logo button on the nav bar is released
  onTapUpLogo(BuildContext context) {}

  /// Controls what to do when the logo button on the nav bar is tapped
  onTapDownLogo(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      NoAnimationMaterialPageRoute(builder: (context) => ExploreProvider()),
      (_) => false);

  /// Defines the nav bar
  StyledNavBar navBar(BuildContext context) => StyledNavBar(
      logoHeld: currentlyHoldingLogo,
      navigationEnabled: navigationEnabled,
      pageIndex: navbarIndex,
      onTapDownLogo: () => onTapDownLogo(context),
      onTapUpLogo: () => onTapUpLogo(context));

  @override
  // ignore: invalid_override_of_non_virtual_member
  Widget build(BuildContext context) => Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
          physics: scrollEnabled ? null : NeverScrollableScrollPhysics(),
          child: SizedBox(
              height: 1.sh -
                  (showAppBar(context) ? appBarHeight : 0) -
                  StyledNavBar.kHeight,
              width: 1.sw,
              child: buildView(context))),
      bottomNavigationBar: navBar(context));
}
