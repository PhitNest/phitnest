import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/ui.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../confirm/confirm.dart';

part 'bloc.dart';

Future<CroppedFile?> _photoChosen(
  BuildContext context,
  Future<XFile?> Function() getImage,
) =>
    getImage().then(
      (image) async {
        if (image != null) {
          return await ImageCropper().cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(
              ratioX: kProfilePictureAspectRatio.width,
              ratioY: kProfilePictureAspectRatio.height,
            ),
          );
        }
        return null;
      },
    ).catchError(
      (dynamic e) {
        error(e.toString());
        return null;
      },
    );

Future<CroppedFile?> _pickPhoto(BuildContext context) => _photoChosen(
      context,
      () => ImagePicker().pickImage(source: ImageSource.gallery),
    );

Future<CroppedFile?> _takePhoto(BuildContext context) => _photoChosen(
      context,
      () => ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      ),
    );

final class PhotoInstructionsPage extends StatelessWidget {
  const PhotoInstructionsPage({super.key}) : super();

  void goToConfirm(BuildContext context, CroppedFile photo) =>
      Navigator.of(context).push(
        CupertinoPageRoute<void>(
          builder: (_) => ConfirmPhotoPage(photo: photo),
        ),
      );

  void handleStateChanged(
    BuildContext context,
    LoaderState<CroppedFile?> loaderState,
  ) {
    switch (loaderState) {
      case LoaderLoadedState(data: final photo):
        if (photo != null) {
          goToConfirm(context, photo);
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: SingleChildScrollView(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        ChoosePhotoBloc(load: (photoChooser) => photoChooser()),
                  ),
                ],
                child: ChoosePhotoConsumer(
                  listener: handleStateChanged,
                  builder: (context, choosePhotoState) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First, let\'s put a face to your name.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      32.verticalSpace,
                      Text(
                        'Add a photo of yourself\n**from the SHOULDERS UP**\n\n'
                        'Just enough for gym buddies to recognize you! Like '
                        'this...',
                        style: theme.textTheme.bodyMedium,
                      ),
                      28.verticalSpace,
                      Center(
                        child: Image.asset(
                          'assets/images/selfie.png',
                          width: 200.w,
                        ),
                      ),
                      32.verticalSpace,
                      Center(
                        child: ElevatedButton(
                          onPressed: () => context.choosePhotoBloc
                              .add(LoaderLoadEvent(() => _takePhoto(context))),
                          child: Text(
                            'TAKE PHOTO',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                      12.verticalSpace,
                      Center(
                        child: StyledOutlineButton(
                          onPress: () => context.choosePhotoBloc
                              .add(LoaderLoadEvent(() => _pickPhoto(context))),
                          text: 'UPLOAD PHOTO',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
