import 'package:flutter/material.dart';
import '../screen_provider.dart';
import './photo_accepted_state.dart';
import './photo_accepted_view.dart';

class PhotoAcceptedProvider
    extends ScreenProvider<PhotoAcceptedCubit, PhotoAcceptedState> {
  const PhotoAcceptedProvider() : super();

  @override
  Widget builder(
    BuildContext context,
    PhotoAcceptedCubit cubit,
    PhotoAcceptedState state,
  ) =>
      PhotoAcceptedView(
        onPressedStart: () {},
      );

  @override
  PhotoAcceptedCubit buildCubit() => PhotoAcceptedCubit();
}
