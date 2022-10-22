import 'package:flutter/material.dart';
import '../provider.dart';
import './photo_instruction_state.dart';
import './photo_instruction_view.dart';

class PhotoInstructionProvider
    extends ScreenProvider<PhotoInstructionState, PhotoInstructionView> {
  @override
  PhotoInstructionView build(
          BuildContext context, PhotoInstructionState state) =>
      PhotoInstructionView();

  @override
  PhotoInstructionState buildState() => PhotoInstructionState();
}
