library profile_picture_page;

import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/theme.dart';
import '../../../common/utils/utils.dart';
import '../../../common/failure.dart';
import '../../widgets/widgets.dart';

part 'ui/profile_picture_page.dart';
part 'ui/widgets/albums_button.dart';
part 'ui/widgets/camera_loading.dart';
part 'ui/widgets/camera_active.dart';
part 'ui/widgets/captured_photo.dart';

part 'state/base.dart';
part 'state/initial.dart';
part 'state/camera_error.dart';
part 'state/camera_loading.dart';
part 'state/camera_loaded.dart';
part 'state/capture_loading.dart';
part 'state/capture_error.dart';
part 'state/capture_success.dart';
part 'state/upload_error.dart';
part 'state/uploading.dart';
part 'state/upload_success.dart';

part 'event/initialize_camera.dart';
part 'event/camera_error.dart';
part 'event/camera_loaded.dart';
part 'event/capture_error.dart';
part 'event/capture_success.dart';
part 'event/upload_error.dart';
part 'event/upload_success.dart';
part 'event/upload.dart';
part 'event/base.dart';
part 'event/capture.dart';
part 'event/retake_photo.dart';
part 'event/retry_initialize_camera.dart';

part 'bloc/profile_picture_bloc.dart';
part 'bloc/on_camera_error.dart';
part 'bloc/on_camera_loaded.dart';
part 'bloc/on_capture.dart';
part 'bloc/on_capture_error.dart';
part 'bloc/on_capture_success.dart';
part 'bloc/on_initialize_camera.dart';
part 'bloc/on_retake_photo.dart';
part 'bloc/on_upload.dart';
part 'bloc/on_upload_error.dart';
part 'bloc/on_upload_success.dart';
part 'bloc/on_retry_initialize_camera.dart';
