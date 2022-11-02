import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/ui/screens/explore/explore_provider.dart';
import 'package:provider/provider.dart';

import '../common/widgets.dart';
import 'state.dart';
import 'view.dart';

/// The base class for all screens on the app. The type parameters, [T] and [K],
/// should be of type [ScreenState] and [ScreenView] respectively. When you
/// create a new child of [ScreenProvider], you should create a new child of [ScreenState]
/// and [ScreenView] as well.
abstract class ScreenProvider<T extends ScreenState, K extends ScreenView>
    extends StatefulWidget {
  const ScreenProvider() : super();

  /// What to do when the logo button on the nav bar is pressed
  onTapDownLogo(BuildContext context, T state) => Navigator.pushAndRemoveUntil(
      context,
      NoAnimationMaterialPageRoute(builder: (context) => ExploreProvider()),
      (_) => false);

  /// What to do when the logo button on the nav bar is released
  onTapUpLogo(BuildContext context, T state) {}

  /// This should create and return an instance of [T]. This will be called once
  /// when the screen is first built.
  T buildState();

  /// Runs when the screen is navigated to
  init(BuildContext context, T state) async {}

  /// This is the actual UI of the screen that is shown when [init] returns.
  /// This should return a new instance of [K] and you will provide all of
  /// the dynamic content and callbacks through the const constructor here.
  K build(BuildContext context, T state);

  /// This runs when the screen is disposed of (popped from the navigator stack).
  dispose(BuildContext context, T state) {}

  @override
  State<StatefulWidget> createState() => _WidgetProviderState();
}

/// Implementation of our [ScreenProvider] class
class _WidgetProviderState<T extends ScreenState, K extends ScreenView>
    extends State<ScreenProvider<T, K>> {
  /// This is the current state of the screen
  late final T state;

  /// This is the height of the app bar
  /// The app bar contains the backbutton and optional text
  double get appBarHeight => 60.h;

  /// This determines whether the app bar should be shown based on the view
  bool showAppBar(K view, BuildContext context) =>
      view.appBarText != null || Navigator.canPop(context);

  /// Builds the state with [ScreenProvider.buildState] and calls [ScreenProvider.init]
  /// After [ScreenProvider.init] is finished, the view is built with [ScreenProvider.build]
  @override
  initState() {
    super.initState();
    this.state = widget.buildState();
    widget.init(context, state).then((_) => state.initialized = true);
  }

  /// This is called whenever [ScreenState.rebuildView] is called
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
      value: state,
      builder: (context, _) => Consumer<T>(builder: (context, value, child) {
            K view = widget.build(context, state);
            return Scaffold(
              // Shows app bar if the view has app bar text or the back button should be shown
              appBar: showAppBar(view, context)
                  ? AppBar(
                      systemOverlayStyle: SystemUiOverlayStyle.dark,
                      toolbarHeight: appBarHeight,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      title: Text(view.appBarText ?? "",
                          style: Theme.of(context).textTheme.headlineMedium),
                      leadingWidth: 64,
                      leading: Navigator.of(context).canPop()
                          ? Container(
                              padding: EdgeInsets.only(left: 8.w),
                              alignment: AlignmentDirectional.bottomCenter,
                              height: double.infinity,
                              child: BackArrowButton())
                          : null,
                    )
                  : null,
              // The screen will be scrollable when the keyboard is open
              body: KeyboardVisibilityBuilder(
                builder: (context, visible) => SingleChildScrollView(
                    physics: visible && !view.disableKeyboardScroll
                        ? null
                        : NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 1.sw,
                          minHeight: 1.sh -
                              (showAppBar(view, context)
                                  ? appBarHeight * 1.5
                                  : 0) -
                              (view.navbarIndex != null
                                  ? StyledNavBar.kHeight
                                  : 0),
                        ),
                        child: IntrinsicHeight(
                          child: view,
                        ))),
              ),
              // The view determines whether the nav bar is shown and the current index of the nav bar
              bottomNavigationBar: view.navbarIndex != null
                  ? StyledNavBar(
                      navigationEnabled: view.navigationEnabled,
                      pageIndex: view.navbarIndex!,
                      onTapDownLogo: (_) =>
                          widget.onTapDownLogo(context, state),
                      onTapUpLogo: (_) => widget.onTapUpLogo(context, state),
                    )
                  : null,
            );
          }));

  /// Called when we leave the screen
  @override
  void dispose() {
    super.dispose();
    state.dispose();
    widget.dispose(context, state);
  }
}
