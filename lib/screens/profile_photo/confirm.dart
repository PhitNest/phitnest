import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:phitnest_core/core.dart';

import '../../widgets/widgets.dart';
import '../home/ui.dart';
import '../login_screen.dart';

sealed class ConfirmPhotoResponse extends Equatable {
  const ConfirmPhotoResponse() : super();
}

final class ConfirmPhotoSuccess extends ConfirmPhotoResponse {
  const ConfirmPhotoSuccess() : super();

  @override
  List<Object?> get props => [];
}

final class ConfirmPhotoFailure extends ConfirmPhotoResponse {
  final Failure error;

  const ConfirmPhotoFailure({
    required this.error,
  }) : super();

  @override
  List<Object?> get props => [error];
}

final class ConfirmPhotoLostAuth extends ConfirmPhotoResponse {
  const ConfirmPhotoLostAuth() : super();

  @override
  List<Object?> get props => [];
}

typedef ConfirmPhotoBloc = LoaderBloc<void, ConfirmPhotoResponse>;
typedef ConfirmPhotoConsumer = LoaderConsumer<void, ConfirmPhotoResponse>;

extension on BuildContext {
  ConfirmPhotoBloc get confirmPhotoBloc => loader();
}

final class ConfirmPhotoScreen extends StatelessWidget {
  final CroppedFile photo;
  final ApiInfo apiInfo;

  const ConfirmPhotoScreen({
    super.key,
    required this.photo,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: BlocProvider(
            create: (_) => ConfirmPhotoBloc(
              load: (_) => photo.readAsBytes().then((bytes) => context
                  .sessionLoader.session
                  .then((session) async => session != null
                      ? await uploadProfilePicture(
                              photo: ByteStream.fromBytes(bytes),
                              length: bytes.length,
                              session: session)
                          .then((failure) => failure != null
                              ? ConfirmPhotoFailure(
                                  error: failure,
                                )
                              : const ConfirmPhotoSuccess())
                      : const ConfirmPhotoLostAuth())),
            ),
            child: ConfirmPhotoConsumer(
              listener: (context, confirmState) {
                switch (confirmState) {
                  case LoaderLoadedState(data: final failure):
                    switch (failure) {
                      case ConfirmPhotoLostAuth():
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute<void>(
                            builder: (context) => LoginScreen(
                              apiInfo: apiInfo,
                            ),
                          ),
                          (_) => false,
                        );
                      case ConfirmPhotoSuccess():
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute<void>(
                            builder: (context) => HomeScreen(
                              apiInfo: apiInfo,
                            ),
                          ),
                          (_) => false,
                        );
                      case ConfirmPhotoFailure(error: final error):
                        StyledBanner.show(message: error.message, error: true);
                    }
                  default:
                }
              },
              builder: (context, screenState) => Column(
                children: [
                  Image.file(
                    File(photo.path),
                    height: 444.h,
                    width: double.infinity,
                  ),
                  56.verticalSpace,
                  ...switch (screenState) {
                    LoaderLoadingState() => const [Loader()],
                    _ => [
                        ElevatedButton(
                          child: Text(
                            'CONFIRM',
                            style: theme.textTheme.bodySmall,
                          ),
                          onPressed: () => context.confirmPhotoBloc
                              .add(const LoaderLoadEvent(null)),
                        ),
                        12.verticalSpace,
                        StyledOutlineButton(
                          text: 'BACK',
                          onPress: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ]
                  },
                ],
              ),
            ),
          ),
        ),
      );
}
