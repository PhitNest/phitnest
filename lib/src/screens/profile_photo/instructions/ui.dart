import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../confirm/ui.dart';
import 'bloc/bloc.dart';

class PhotoInstructionsScreen extends StatelessWidget {
  const PhotoInstructionsScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => PhotoInstructionsBloc(),
        child: BlocConsumer<PhotoInstructionsBloc, PhotoInstructionsState>(
          listener: (context, screenState) {
            switch (screenState) {
              case PhotoInstructionsPickedState(photo: final photo):
                Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (context) => ConfirmPhotoScreen(
                      photo: photo,
                    ),
                  ),
                );
              default:
            }
          },
          builder: (context, screenState) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context.photoInstructionsBloc.add(
                      const PhotoInstructionsTakePhotoEvent(),
                    ),
                    child: const Text('TAKE PHOTO'),
                  ),
                  TextButton(
                    onPressed: () => context.photoInstructionsBloc.add(
                      const PhotoInstructionsTakePhotoEvent(),
                    ),
                    child: const Text('UPLOAD PHOTO'),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
