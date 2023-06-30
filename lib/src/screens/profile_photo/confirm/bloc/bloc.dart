import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:phitnest_core/core.dart';

part 'event.dart';
part 'state.dart';

extension GetConfirmPhotoBloc on BuildContext {
  ConfirmPhotoBloc get confirmPhotoBloc => BlocProvider.of(this);
}

class ConfirmPhotoBloc extends Bloc<ConfirmPhotoEvent, ConfirmPhotoState> {
  ConfirmPhotoBloc(CroppedFile photo)
      : super(const ConfirmPhotoInitialState()) {
    on<ConfirmPhotoConfirmEvent>(
      (event, emit) {
        emit(
          ConfirmPhotoLoadingState(
            loadingOperation: CancelableOperation.fromFuture(() async {
              final read = await photo.readAsBytes();
              return await uploadProfilePicture(
                session: event.session,
                length: read.length,
                photo: ByteStream.fromBytes(read),
              );
            }())
              ..then(
                (failure) => add(
                  ConfirmPhotoResponseEvent(
                    error: failure,
                  ),
                ),
              ),
          ),
        );
      },
    );

    on<ConfirmPhotoResponseEvent>(
      (event, emit) {
        if (event.error != null) {
          emit(
            ConfirmPhotoFailureState(
              error: event.error!,
            ),
          );
        } else {
          emit(const ConfirmPhotoSuccessState());
        }
      },
    );
  }

  @override
  Future<void> close() async {
    switch (state) {
      case ConfirmPhotoLoadingState(loadingOperation: final loadingOperation):
        await loadingOperation.cancel();
      default:
    }
    return super.close();
  }
}
