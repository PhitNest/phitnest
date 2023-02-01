library use_cases;

import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/backend/backend.dart';
import '../entities/entities.dart';

part 'location_and_gyms.dart';
part 'upload_photo_unauthorized.dart';

abstract class UseCases {
  static const getNearbyGyms = _getNearbyGyms;
  static const uploadPhotoUnauthorized = _uploadPhotoUnauthorized;
}
