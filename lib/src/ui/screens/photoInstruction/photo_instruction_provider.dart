import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import './photo_instruction_state.dart';
import './photo_instruction_view.dart';

class PhotoInstructionProvider
    extends ScreenProvider<PhotoInstructionState, PhotoInstructionView> {
  const PhotoInstructionProvider() : super();

  @override
  PhotoInstructionView build(
          BuildContext context, PhotoInstructionState state) =>
      PhotoInstructionView(
        onPressedTakePhoto: () => Navigator.of(context).push(
          NoAnimationMaterialPageRoute(
            builder: (context) => ConfirmPhotoProvider(),
          ),
        ),
        onPressedUpload: () => Navigator.of(context).push(
          NoAnimationMaterialPageRoute(
            builder: (context) => ConfirmPhotoProvider(),
          ),
        ),
      );

  @override
  PhotoInstructionState buildState() => PhotoInstructionState();
}
