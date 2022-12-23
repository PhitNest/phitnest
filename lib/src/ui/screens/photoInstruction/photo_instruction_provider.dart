import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import './photo_instruction_state.dart';
import './photo_instruction_view.dart';

class PhotoInstructionProvider
    extends ScreenProvider<PhotoInstructionCubit, PhotoInstructionState> {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const PhotoInstructionProvider({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  }) : super();

  @override
  PhotoInstructionCubit buildCubit() => PhotoInstructionCubit();

  @override
  Widget builder(
    BuildContext context,
    PhotoInstructionCubit cubit,
    PhotoInstructionState state,
  ) =>
      PhotoInstructionView(
        onPressedTakePhoto: () => Navigator.of(context)
          ..pop()
          ..push(
            NoAnimationMaterialPageRoute(
              builder: (context) => ConfirmPhotoProvider(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
              ),
            ),
          ),
        onPressedUpload: () => Navigator.of(context)
          ..pop()
          ..push(
            NoAnimationMaterialPageRoute(
              builder: (context) => ConfirmPhotoProvider(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
              ),
            ),
          ),
      );
}
