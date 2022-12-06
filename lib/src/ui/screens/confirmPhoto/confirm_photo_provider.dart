import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'confirm_photo_state.dart';
import 'confirm_photo_view.dart';

class ConfirmPhotoProvider
    extends ScreenProvider<ConfirmPhotoState, ConfirmPhotoView> {
  const ConfirmPhotoProvider() : super();

  @override
  ConfirmPhotoView build(BuildContext context, ConfirmPhotoState state) =>
      ConfirmPhotoView(
        onPressedConfirm: () => Navigator.of(context).pushAndRemoveUntil(
          NoAnimationMaterialPageRoute(
            builder: (context) => ReviewingPhotoProvider(
              name: '[name]',
            ),
          ),
          (_) => false,
        ),
        onPressedRetake: () {},
      );

  @override
  ConfirmPhotoState buildState() => ConfirmPhotoState();
}
