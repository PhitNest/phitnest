import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/util.dart';

part 'event.dart';
part 'state.dart';

extension GetPhotoInstructionsBloc on BuildContext {
  PhotoInstructionsBloc get photoInstructionsBloc => BlocProvider.of(this);
}

class PhotoInstructionsBloc
    extends Bloc<PhotoInstructionsEvent, PhotoInstructionsState> {
  PhotoInstructionsBloc() : super(const PhotoInstructionsInitialState()) {
    on<PhotoInstructionsTakePhotoEvent>(
      (event, emit) {
        emit(
          PhotoInstructionsPickingState(
            pickingOperation: CancelableOperation.fromFuture(() async {
              ImagePicker()
                  .pickImage(
                source: ImageSource.camera,
                preferredCameraDevice: CameraDevice.front,
              )
                  .then(
                (image) async {
                  if (image != null) {
                    return await ImageCropper()
                        .cropImage(
                          sourcePath: image.path,
                          aspectRatio: CropAspectRatio(
                            ratioX: kProfilePictureAspectRatio.width,
                            ratioY: kProfilePictureAspectRatio.height,
                          ),
                        )
                        .then(
                          (img) => img!.readAsBytes(),
                        )
                        .then(
                          (bytes) => XFile.fromData(bytes),
                        );
                  }
                  return null;
                },
              );
            }())
              ..then(
                (file) => add(PhotoInstructionsPickedEvent(photo: file)),
              ),
          ),
        );
      },
    );

    on<PhotoInstructionsPickEvent>(
      (event, emit) {
        emit(
          PhotoInstructionsPickingState(
            pickingOperation: CancelableOperation.fromFuture(
              ImagePicker().pickImage(source: ImageSource.gallery).then(
                (image) async {
                  if (image != null) {
                    return await ImageCropper()
                        .cropImage(
                          sourcePath: image.path,
                          aspectRatio: CropAspectRatio(
                            ratioX: kProfilePictureAspectRatio.width,
                            ratioY: kProfilePictureAspectRatio.height,
                          ),
                        )
                        .then(
                          (img) => img!.readAsBytes(),
                        )
                        .then(
                          (bytes) => XFile.fromData(bytes),
                        );
                  }
                  return null;
                },
              ),
            )..then(
                (file) => add(PhotoInstructionsPickedEvent(photo: file)),
              ),
          ),
        );
      },
    );

    on<PhotoInstructionsPickedEvent>(
      (event, emit) {
        if (event.photo != null) {
          emit(
            PhotoInstructionsPickedState(
              photo: event.photo!,
            ),
          );
        } else {
          emit(
            const PhotoInstructionsNoPictureState(),
          );
        }
      },
    );
  }

  @override
  Future<void> close() async {
    switch (state) {
      case PhotoInstructionsPickingState(
          pickingOperation: final pickingOperation
        ):
        await pickingOperation.cancel();
        break;
      default:
        break;
    }
    return super.close();
  }
}
