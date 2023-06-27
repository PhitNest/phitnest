import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:phitnest_core/core.dart';

import 'bloc/bloc.dart';

class ConfirmPhotoScreen extends StatelessWidget {
  final CroppedFile photo;

  const ConfirmPhotoScreen({
    super.key,
    required this.photo,
  }) : super();

  @override
  Widget build(BuildContext context) => BlocConsumer<CognitoBloc, CognitoState>(
        listener: (context, cognitoState) {},
        builder: (context, cognitoState) => BlocProvider(
          create: (_) => ConfirmPhotoBloc(photo),
          child: BlocConsumer<ConfirmPhotoBloc, ConfirmPhotoState>(
            listener: (context, screenState) {},
            builder: (context, screenState) => Scaffold(
              body: Center(
                child: Column(
                  children: [
                    TextButton(
                      child: const Text('CONFIRM'),
                      onPressed: () => context.confirmPhotoBloc.add(
                        ConfirmPhotoConfirmEvent(
                          session:
                              (cognitoState as CognitoLoggedInState).session,
                        ),
                      ),
                    ),
                    TextButton(
                      child: const Text('BACK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
