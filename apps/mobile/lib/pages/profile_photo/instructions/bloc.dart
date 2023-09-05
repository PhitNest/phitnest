part of 'instructions.dart';

typedef ChoosePhotoBloc
    = LoaderBloc<Future<CroppedFile?> Function(), CroppedFile?>;
typedef ChoosePhotoConsumer
    = LoaderConsumer<Future<CroppedFile?> Function(), CroppedFile?>;

extension on BuildContext {
  ChoosePhotoBloc get choosePhotoBloc => loader();
}

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

void _goToConfirm(BuildContext context, CroppedFile photo) =>
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (_) => ConfirmPhotoPage(photo: photo),
      ),
    );

void _handleStateChanged(
  BuildContext context,
  LoaderState<CroppedFile?> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final photo):
      if (photo != null) {
        _goToConfirm(context, photo);
      }
    default:
  }
}
