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
          (image) {
            if (image != null) {
              onUploadPicture(image);
            }
          },
        ),
      );
}
