import 'package:flutter/material.dart';
import '../provider.dart';
import './photo_accepted_state.dart';
import './photo_accepted_view.dart';

class PhotoAcceptedProvider
    extends ScreenProvider<PhotoAcceptState, PhotoAcceptedView> {
  const PhotoAcceptedProvider() : super();

  @override
  PhotoAcceptedView build(BuildContext context, PhotoAcceptState state) =>
      PhotoAcceptedView(
        onPressedStart: () {},
      );

  @override
  PhotoAcceptState buildState() => PhotoAcceptState();
}
