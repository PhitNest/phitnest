import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../../confirm_email/bloc/bloc.dart';
import 'bloc/bloc.dart';

class ConfirmPhotoScreen extends StatelessWidget {
  final XFile photo;

  const ConfirmPhotoScreen({
    super.key,
    required this.photo,
  }) : super();

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => ConfirmEmailBloc(),
        child: BlocConsumer<CognitoBloc, CognitoState>(
          listener: (context, cognitoState) {},
          builder: (context, cognitoState) =>
              BlocConsumer<ConfirmEmailBloc, ConfirmEmailState>(
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
