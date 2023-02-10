part of profile_picture_page;

class _AlbumsButton extends StatelessWidget {
  final ValueChanged<XFile> onUploadPicture;

  const _AlbumsButton({
    required this.onUploadPicture,
  }) : super();

  @override
  Widget build(BuildContext context) => StyledUnderlinedTextButton(
        text: 'ALBUMS',
        onPressed: () =>
            ImagePicker().pickImage(source: ImageSource.gallery).then(
          (image) async {
            if (image != null) {
              final cropped = await ImageCropper()
                  .cropImage(
                sourcePath: image.path,
                aspectRatio: CropAspectRatio(
                  ratioX: kProfilePictureAspectRatio.width,
                  ratioY: kProfilePictureAspectRatio.height,
                ),
              )
                  .then(
                (img) async {
                  if (img != null) {
                    return XFile.fromData(await img.readAsBytes());
                  } else {
                    return null;
                  }
                },
              );
              if (cropped != null) {
                onUploadPicture(cropped);
              }
            }
          },
        ),
      );
}
