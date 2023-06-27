import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:phitnest_core/core.dart';

import '../../../theme.dart';
import '../../../widgets/widgets.dart';
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
                    120.verticalSpace,
                    ElevatedButton(
                      child: Text(
                        'CONFIRM',
                        style: AppTheme.instance.theme.textTheme.bodySmall,
                      ),
                      onPressed: () => context.confirmPhotoBloc.add(
                        ConfirmPhotoConfirmEvent(
                          session:
                              (cognitoState as CognitoLoggedInState).session,
                        ),
                      ),
                    ),
                    12.verticalSpace,
                    StyledOutlineButton(
                      text: 'BACK',
                      onPress: () {
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
