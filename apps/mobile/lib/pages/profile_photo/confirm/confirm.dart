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
import '../../login/login.dart';

part 'bloc.dart';

final class ConfirmPhotoPage extends StatelessWidget {
  final CroppedFile photo;

  const ConfirmPhotoPage({
    super.key,
    required this.photo,
  }) : super();

  Future<ConfirmPhotoResponse> _submit(Session session) async {
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

  @override
  Widget build(BuildContext context) {
    final pfp = Image.network(photo.path);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: BlocProvider(
            create: (_) => ConfirmPhotoBloc(
              load: (_, session) => _submit(session),
            ),
            child: ConfirmPhotoConsumer(
              listener: (context, confirmState) =>
                  _handleStateChanged(context, confirmState, pfp),
              builder: (context, confirmState) => Column(
                children: [
                  pfp,
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
}
