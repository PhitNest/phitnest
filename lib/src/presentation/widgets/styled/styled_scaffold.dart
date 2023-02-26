import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';

class StyledScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? leadingAppBarWidget;
  final String? appBarTitle;
  final bool safeArea;
  final bool lightMode;
  final bool showAppBar;
  final List<Widget>? actions;

  const StyledScaffold({
    Key? key,
    required this.body,
    this.bottomNavigationBar,
    this.leadingAppBarWidget,
    this.appBarTitle,
    this.actions,
    this.safeArea = true,
    this.lightMode = false,
    this.showAppBar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            lightMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: showAppBar
              ? AppBar(
                  leading: leadingAppBarWidget,
                  title: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      appBarTitle ?? '',
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                  elevation: 0.0,
                  centerTitle: true,
                  actions: actions,
                  toolbarHeight: 48.h,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                )
              : null,
          body: safeArea ? SafeArea(child: body) : body,
          bottomNavigationBar: bottomNavigationBar,
        ),
      );
}
