import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/styled_app_bar.dart';
import '../widgets/widgets.dart';
import 'state.dart';
import 'provider.dart';

export 'nav_bar_view.dart';

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

  /// Builds the UI of the screen
  Widget buildView(BuildContext context);

  /// Constructs the scaffold with the app bar and navbar
  @nonVirtual
  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = Scaffold(
        appBar: appBar(context),
        body: SingleChildScrollView(
            physics: scrollEnabled ? null : NeverScrollableScrollPhysics(),
            child: SizedBox(
                height: 1.sh - (showAppBar(context) ? appBarHeight : 0),
                width: 1.sw,
                child: buildView(context))));
    return showAppBar(context)
        ? scaffold
        : AnnotatedRegion<SystemUiOverlayStyle>(
            value: systemOverlayDark
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            child: scaffold);
  }

  /// This will display in the AppBar
  String? get appBarText => null;

  /// Whether or not the screen can scroll when overflowed
  bool get scrollEnabled => false;

  /// This is the height of the app bar
  /// The app bar contains the backbutton and optional text
  double get appBarHeight => 60.h;

  /// Control whether or not the app bar is shown
  bool showAppBar(BuildContext context) =>
      appBarText != null || Navigator.canPop(context);

  /// Builds the app bar
  @nonVirtual
  StyledAppBar? appBar(BuildContext context) => showAppBar(context)
      ? StyledAppBar(
          context: context,
          systemOverlayDark: systemOverlayDark,
          height: appBarHeight,
          text: appBarText,
          backButton: backButton,
        )
      : null;

  /// Back button displayed in top left corner
  Widget get backButton => Container(
      padding: EdgeInsets.only(left: 8.w),
      alignment: AlignmentDirectional.bottomCenter,
      height: double.infinity,
      child: BackArrowButton());

  /// Controls whether the system overlay is light or dark
  bool get systemOverlayDark => true;
}
