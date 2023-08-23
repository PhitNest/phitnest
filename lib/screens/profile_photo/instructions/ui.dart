part of 'instructions.dart';

final class PhotoInstructionsScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const PhotoInstructionsScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  Future<CroppedFile?> photoChosen(
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

  Future<CroppedFile?> pickPhoto(BuildContext context) => photoChosen(
        context,
        () => ImagePicker().pickImage(source: ImageSource.gallery),
      );

  Future<CroppedFile?> takePhoto(BuildContext context) => photoChosen(
        context,
        () => ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
        ),
      );

  void goToConfirm(BuildContext context, CroppedFile photo) =>
      Navigator.of(context).push(
        CupertinoPageRoute<void>(
          builder: (context) => ConfirmPhotoScreen(
            photo: photo,
            apiInfo: apiInfo,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => ChoosePhotoBloc(
                    load: (photoChooser) => photoChooser(),
                  ),
                ),
              ],
              child: ChoosePhotoConsumer(
                listener: (context, takePhotoState) {
                  switch (takePhotoState) {
                    case LoaderLoadedState(data: final photo):
                      if (photo != null) {
                        goToConfirm(context, photo);
                      }
                    default:
                  }
                },
                builder: (context, choosePhotoState) => SingleChildScrollView(
                  child: Column(
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
                              .add(LoaderLoadEvent(() => takePhoto(context))),
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
                              .add(LoaderLoadEvent(() => pickPhoto(context))),
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
