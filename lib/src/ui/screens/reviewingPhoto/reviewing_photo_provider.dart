import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'reviewing_photo_state.dart';
import 'reviewing_photo_view.dart';

class ReviewingPhotoProvider
    extends ScreenProvider<ReviewingPhotoCubit, ReviewingPhotoState> {
  final String name;

  const ReviewingPhotoProvider({required this.name}) : super();

  @override
  ReviewingPhotoCubit buildCubit() => ReviewingPhotoCubit();

  @override
  Widget builder(
    BuildContext context,
    ReviewingPhotoCubit cubit,
    ReviewingPhotoState state,
  ) =>
      ReviewingPhotoView(
        name: name,
        onPressedFinish: () => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => LoginProvider(),
          ),
          (_) => false,
        ),
      );
}
