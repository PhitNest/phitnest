import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import './reviewing_photo_state.dart';
import './reviewing_photo_view.dart';

class ReviewingPhotoProvider
    extends ScreenProvider<ReviewingPhotoState, ReviewingPhotoView> {
  final String name;

  const ReviewingPhotoProvider({
    required this.name,
  }) : super();

  @override
  ReviewingPhotoView build(BuildContext context, ReviewingPhotoState state) =>
      ReviewingPhotoView(
        name: name,
        onPressedFinish: () => Navigator.of(context).pushAndRemoveUntil(
          NoAnimationMaterialPageRoute(
            builder: (context) => const LoginProvider(),
          ),
          (_) => false,
        ),
      );

  @override
  ReviewingPhotoState buildState() => ReviewingPhotoState();
}
