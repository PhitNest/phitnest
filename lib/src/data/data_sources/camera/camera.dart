import 'package:camera/camera.dart';

import '../../../common/utils/utils.dart';

Future<XFile> takeProfilePicture(CameraController cameraController) =>
    cameraController.takePicture().then(
          (file) => file.centerCrop(1 / cameraController.value.aspectRatio),
        );
