import 'package:flutter/material.dart';

import '../provider.dart';
import 'confirm_photo_state.dart';
import 'confirm_photo_view.dart';

class ConfirmPhotoProvider
    extends ScreenProvider<ConfirmPhotoState, ConfirmPhotoView> {
  @override
  ConfirmPhotoView build(BuildContext context, ConfirmPhotoState state) =>
      ConfirmPhotoView();

  @override
  ConfirmPhotoState buildState() => ConfirmPhotoState();
}
