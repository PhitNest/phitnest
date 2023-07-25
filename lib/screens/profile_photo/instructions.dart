import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phitnest_core/core.dart';

import '../../common/constants/constants.dart';
import 'confirm.dart';

final class PickPhoto extends Equatable {
  final CroppedFile? photo;

  const PickPhoto({
    required this.photo,
  }) : super();

  @override
  List<Object?> get props => [photo];
}

final class TakePhoto extends Equatable {
  final CroppedFile? photo;

  const TakePhoto({
    required this.photo,
  }) : super();

  @override
  List<Object?> get props => [photo];
}

typedef PickPhotoBloc = LoaderBloc<void, PickPhoto>;
typedef TakePhotoBloc = LoaderBloc<void, TakePhoto>;
typedef PickPhotoConsumer = LoaderConsumer<void, PickPhoto>;
typedef TakePhotoConsumer = LoaderConsumer<void, TakePhoto>;

extension on BuildContext {
  PickPhotoBloc get pickPhotoBloc => loader();
  TakePhotoBloc get takePhotoBloc => loader();
}

class PhotoInstructionsScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const PhotoInstructionsScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => PickPhotoBloc(
                    load: (_) async => PickPhoto(
                      photo: await ImagePicker()
                          .pickImage(source: ImageSource.gallery)
                          .then(
                        (image) async {
                          if (image != null) {
                            return await ImageCropper().cropImage(
                              sourcePath: image.path,
                              aspectRatio: CropAspectRatio(
                                ratioX: kProfilePictureAspectRatio.width,
                                ratioY: kProfilePictureAspectRatio.height,
                              ),
                            );
                          }
                          return null;
                        },
                      ).catchError((_) => null),
                    ),
                  ),
                ),
                BlocProvider(
                  create: (_) => TakePhotoBloc(
                    load: (_) async => TakePhoto(
                      photo: await ImagePicker()
                          .pickImage(
                        source: ImageSource.camera,
                        preferredCameraDevice: CameraDevice.front,
                      )
                          .then(
                        (image) async {
                          if (image != null) {
                            return await ImageCropper().cropImage(
                              sourcePath: image.path,
                              aspectRatio: CropAspectRatio(
                                ratioX: kProfilePictureAspectRatio.width,
                                ratioY: kProfilePictureAspectRatio.height,
                              ),
                            );
                          }
                          return null;
                        },
                      ).catchError((_) => null),
                    ),
                  ),
                )
              ],
              child: TakePhotoConsumer(
                listener: (context, takePhotoState) {
                  switch (takePhotoState) {
                    case LoaderLoadedState(data: final res):
                      if (res.photo != null) {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (context) => ConfirmPhotoScreen(
                              photo: res.photo!,
                              apiInfo: apiInfo,
                            ),
                          ),
                        );
                      }
                    default:
                  }
                },
                builder: (context, takePhotoState) => PickPhotoConsumer(
                  listener: (context, pickPhotoState) {
                    switch (pickPhotoState) {
                      case LoaderLoadedState(data: final res):
                        if (res.photo != null) {
                          Navigator.of(context).push(
                            CupertinoPageRoute<void>(
                              builder: (context) => ConfirmPhotoScreen(
                                photo: res.photo!,
                                apiInfo: apiInfo,
                              ),
                            ),
                          );
                        }
                      default:
                    }
                  },
                  builder: (context, pickPhotoState) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First, let\'s put a face to your name.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      32.verticalSpace,
                      Text(
                        'Add a photo of yourself\n**from the SHOULDERS UP**\n\n'
                        'Just enough for gym buddies to recognize you! Like '
                        'this...',
                        style: theme.textTheme.bodyMedium,
                      ),
                      28.verticalSpace,
                      Center(
                        child: Image.asset(
                          'assets/images/selfie.png',
                          width: 200.w,
                        ),
                      ),
                      32.verticalSpace,
                      Center(
                        child: ElevatedButton(
                          onPressed: () => context.takePhotoBloc
                              .add(const LoaderLoadEvent(null)),
                          child: Text(
                            'TAKE PHOTO',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                      12.verticalSpace,
                      Center(
                        child: StyledOutlineButton(
                          onPress: () => context.pickPhotoBloc
                              .add(const LoaderLoadEvent(null)),
                          text: 'UPLOAD PHOTO',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
