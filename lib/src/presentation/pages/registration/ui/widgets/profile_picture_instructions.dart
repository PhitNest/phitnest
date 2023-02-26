part of registration_page;

class _ProfilePictureInstructions extends StatelessWidget {
  final VoidCallback onPressedTakePhoto;
  final ValueChanged<XFile> onPressedUploadFromAlbums;

  const _ProfilePictureInstructions({
    Key? key,
    required this.onPressedTakePhoto,
    required this.onPressedUploadFromAlbums,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: 1.sh - MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                double.infinity.horizontalSpace,
                56.verticalSpace,
                Text(
                  "Let's put a face\nto your name",
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                30.verticalSpace,
                Text(
                  "Add a photo of yourself\n**from the SHOULDERS UP**\n\nJust enough for your gym buddies\nto recognize you!",
                  style: theme.textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                12.verticalSpace,
                Container(
                  width: 160.h,
                  child: Image.asset(
                    Assets.profilePictureMeme.path,
                    fit: BoxFit.contain,
                  ),
                ),
                30.verticalSpace,
                StyledButton(
                  onPressed: onPressedTakePhoto,
                  text: 'TAKE PHOTO',
                ),
                Spacer(),
                StyledUnderlinedTextButton(
                  onPressed: () =>
                      ImagePicker().pickImage(source: ImageSource.gallery).then(
                    (image) async {
                      if (image != null) {
                        onPressedUploadFromAlbums(
                          await ImageCropper()
                              .cropImage(
                                sourcePath: image.path,
                              )
                              .then(
                                (img) => img!.readAsBytes(),
                              )
                              .then(
                                (bytes) => XFile.fromData(bytes),
                              ),
                        );
                      }
                    },
                  ),
                  text: 'UPLOAD FROM ALBUMS',
                ),
                62.verticalSpace,
              ],
            ),
          ),
        ),
      );
}
