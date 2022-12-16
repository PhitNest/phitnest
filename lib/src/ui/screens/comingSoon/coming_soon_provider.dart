import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'coming_soon_state.dart';
import 'coming_soon_view.dart';


class ComingSoonProvider extends ScreenProvider<ComingSoonState, ComingSoonView> {
  const ComingSoonProvider({required this.pageIndex}) : super();

  final int pageIndex;
  @override
  ComingSoonView build(BuildContext context, ComingSoonState state) => ComingSoonView(pageIndex: pageIndex,
        onPressedLogo: () => Navigator.of(context).pushAndRemoveUntil(
          NoAnimationMaterialPageRoute(
            builder: (context) => const ExploreProvider(),
          ),
          (_) => false,
        ),
      );

  @override
  ComingSoonState buildState() => ComingSoonState();
}