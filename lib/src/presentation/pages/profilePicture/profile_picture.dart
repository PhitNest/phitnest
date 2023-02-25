library profile_picture_page;

import 'dart:async';

import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../widgets/widgets.dart';

// ======= BLOC =======
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
part 'bloc/profile_picture_bloc.dart';

// ======= EVENT =======
part 'event/base.dart';
part 'event/camera_error.dart';
part 'event/camera_loaded.dart';
part 'event/capture.dart';
part 'event/capture_error.dart';
part 'event/capture_success.dart';
part 'event/initialize_camera.dart';
part 'event/retake_photo.dart';
part 'event/upload.dart';
part 'event/upload_error.dart';
part 'event/upload_success.dart';

// ======= STATE =======
part 'state/base.dart';
part 'state/camera_loaded.dart';
part 'state/camera_loading.dart';
part 'state/capture_loading.dart';
part 'state/capture_success.dart';
part 'state/initial.dart';
part 'state/upload_success.dart';
part 'state/uploading.dart';

// ======= UI =======
part 'ui/profile_picture_page.dart';
part 'ui/widgets/albums_button.dart';
part 'ui/widgets/camera_active.dart';
part 'ui/widgets/camera_loading.dart';
part 'ui/widgets/captured_photo.dart';
