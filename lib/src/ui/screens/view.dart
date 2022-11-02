import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/widgets.dart';
import 'state.dart';
import 'provider.dart';

/// Holds the UI elements of a screen. All variables should be defined in the
/// [ScreenState] class associated with the [ScreenProvider] this class corresponds to.
/// This class can accept those elements as constructor arguments when
/// instantiated in [ScreenProvider]. This class should be immutable (all variables
/// should be marked final).
///
/// When the variables in your [ScreenState] change, those changes will not be
/// reflected in this class until [ScreenState.rebuildView] is called, at which
/// time [build] will be called.
abstract class ScreenView extends StatelessWidget {
  const ScreenView() : super();

  /// This will display in the AppBar
  String? get appBarText => null;

  /// Whether or not the screen can scroll when overflowed
  bool get scrollEnabled => false;

  /// This is the height of the app bar
  /// The app bar contains the backbutton and optional text
  double get appBarHeight => 60.h;

  /// The current navbar page index. Set to null to hide nav bar.
  int? get navbarIndex => null;

  /// Controls whether navigation from the nav bar is enabled
  bool get navigationEnabled => true;

  /// Back button displayed in top left corner
  Widget get backButton => Container(
      padding: EdgeInsets.only(left: 8.w),
      alignment: AlignmentDirectional.bottomCenter,
      height: double.infinity,
      child: BackArrowButton());

  /// Controls whether the system overlay is light or dark
  bool get systemOverlayDark => true;
}
