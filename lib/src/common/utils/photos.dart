part of utils;

const kProfilePictureAspectRatio = Size(375.0, 330.0);

Future<Failure?> uploadPhotoToS3(String uploadUrl, XFile photo) async => http
        .put(
      Uri.parse(uploadUrl),
      headers: {
        'Content-Type': 'image/*',
        'Accept': "*/*",
        'Content-Length': (await photo.length()).toString(),
        'Connection': 'keep-alive',
      },
      body: await photo.readAsBytes(),
    )
        .then(
      (res) {
        if (res.statusCode == kStatusOK) {
          prettyLogger.d("Successfully sent profile picture to S3");
          return null;
        } else {
          prettyLogger.e("Failed to send profile picture to S3");
          return Failure.fromJson(
            jsonDecode(res.body),
          );
        }
      },
    );

extension TakeProfilePicture on CameraController {
  Future<XFile> takeProfilePicture() => takePicture().then(
        (file) => file.centerCrop(),
      );
}

extension Crop on XFile {
  Future<XFile> centerCrop() async {
    final inBytes = await readAsBytes();
    final inImage = await decodeImageFromList(inBytes);
    final width = inImage.width;
    final height = inImage.height;
    final imageEditOptions = editor.ImageEditorOption();
    if (width / height > kProfilePictureAspectRatio.aspectRatio) {
      imageEditOptions.addOption(
        editor.ClipOption(
          width: height * kProfilePictureAspectRatio.aspectRatio,
          height: height,
          x: (width - height * kProfilePictureAspectRatio.aspectRatio) / 2,
        ),
      );
    } else {
      imageEditOptions.addOption(
        editor.ClipOption(
          width: width,
          height: width / kProfilePictureAspectRatio.aspectRatio,
          y: (height - width / kProfilePictureAspectRatio.aspectRatio) / 2,
        ),
      );
    }
    final outBytes = await editor.ImageEditor.editImage(
      image: inBytes,
      imageEditorOption: imageEditOptions,
    );
    if (outBytes == null) {
      throw CameraException(
        Failures.failedToCropImage.code,
        Failures.failedToCropImage.message,
      );
    }
    return XFile.fromData(
      outBytes,
      name: name,
      path: path,
      mimeType: mimeType,
    );
  }
}
