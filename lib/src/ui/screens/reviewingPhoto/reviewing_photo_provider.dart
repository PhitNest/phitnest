import 'package:flutter/material.dart';
import '../provider.dart';
import './reviewing_photo_state.dart';
import './reviewing_photo_view.dart';

class ReviewingPhotoProvider
    extends ScreenProvider<ReviewingPhotoState, ReviewingPhotoView> {
  @override
  ReviewingPhotoView build(BuildContext context, ReviewingPhotoState state) =>
      ReviewingPhotoView();

  @override
  ReviewingPhotoState buildState() => ReviewingPhotoState();
}
