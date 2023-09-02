import 'dart:io';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ui/ui.dart';

import '../../../widgets/widgets.dart';
import '../../home/home.dart';
import '../../login/login.dart';

part 'bloc.dart';

final class ConfirmPhotoPage extends StatelessWidget {
  final CroppedFile photo;

  const ConfirmPhotoPage({
    super.key,
    required this.photo,
  }) : super();

  Future<ConfirmPhotoResponse> submit(Session session) async {
    final bytes = await photo.readAsBytes();
    final error = await uploadProfilePicture(
      photo: ByteStream.fromBytes(bytes),
      length: bytes.length,
      session: session,
      identityId: session.credentials.userIdentityId!,
    );
    if (error != null) {
      return ConfirmPhotoFailure(message: error);
    } else {
      return const ConfirmPhotoSuccess();
    }
  }

  void handleStateChanged(
    BuildContext context,
    LoaderState<AuthResOrLost<ConfirmPhotoResponse>> loaderState,
  ) {
    switch (loaderState) {
      case LoaderLoadedState(data: final data):
        switch (data) {
          case AuthLost(message: final message):
            StyledBanner.show(
              message: message,
              error: true,
            );
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute<void>(
                builder: (_) => const LoginPage(),
              ),
              (_) => false,
            );
          case AuthRes(data: final data):
            switch (data) {
              case ConfirmPhotoSuccess():
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute<void>(
                    builder: (_) => const HomePage(),
                  ),
                  (_) => false,
                );
              case ConfirmPhotoFailure(message: final error):
                StyledBanner.show(message: error, error: true);
            }
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (_) => ConfirmPhotoBloc(
                load: (_, session) => submit(session),
              ),
              child: ConfirmPhotoConsumer(
                listener: handleStateChanged,
                builder: (context, confirmState) => Column(
                  children: [
                    Image.file(
                      File(photo.path),
                      height: 444.h,
                      width: double.infinity,
                    ),
                    56.verticalSpace,
                    ...switch (confirmState) {
                      LoaderLoadingState() => const [Loader()],
                      _ => [
                          ElevatedButton(
                            child: Text(
                              'CONFIRM',
                              style: theme.textTheme.bodySmall,
                            ),
                            onPressed: () => context.confirmPhotoBloc.add(
                                LoaderLoadEvent(
                                    AuthReq(null, context.sessionLoader))),
                          ),
                          12.verticalSpace,
                          StyledOutlineButton(
                              text: 'BACK',
                              onPress: () => Navigator.of(context).pop()),
                        ]
                    },
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
