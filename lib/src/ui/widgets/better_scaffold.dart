import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets.dart';

/// This is a scaffold that shouldn't have overflow errors.
class BetterScaffold extends StatelessWidget {
  final bool darkMode;
  final bool useBackButton;
  final ScrollController? scrollController;
  final Widget body;
  final VoidCallback? onPressedBack;
  final ScrollPhysics? scrollPhysics;

  const BetterScaffold({
    required this.body,
    this.scrollController,
    this.onPressedBack,
    this.scrollPhysics,
    this.darkMode = true,
    this.useBackButton = false,
  }) : super();

  Widget _scrollView() => SingleChildScrollView(
        physics: scrollPhysics ??
            (scrollController != null
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics()),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: scrollController,
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: body,
        ),
      );

  Widget _buildBody() => useBackButton
      ? Column(children: [
          40.verticalSpace,
          BackArrowButton(
            onPressed: onPressedBack,
          ),
          Expanded(
            child: _scrollView(),
          )
        ])
      : _scrollView();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            darkMode ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        child: Scaffold(
          body: _buildBody(),
        ),
      );
}
