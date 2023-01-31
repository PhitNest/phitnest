import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/widgets.dart';

class AlbumsButton extends StatelessWidget {
  final ValueChanged<XFile> onUploadPicture;

  const AlbumsButton({
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
