import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/ui.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../confirm/confirm.dart';

part 'bloc.dart';

final class PhotoInstructionsPage extends StatelessWidget {
  const PhotoInstructionsPage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        ChoosePhotoBloc(load: (photoChooser) => photoChooser()),
                  ),
                ],
                child: ChoosePhotoConsumer(
                  listener: _handleStateChanged,
                  builder: (context, choosePhotoState) => Column(
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
                          onPressed: () => context.choosePhotoBloc
                              .add(LoaderLoadEvent(() => _takePhoto(context))),
                          child: Text(
                            'TAKE PHOTO',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                      12.verticalSpace,
                      Center(
                        child: StyledOutlineButton(
                          onPress: () => context.choosePhotoBloc
                              .add(LoaderLoadEvent(() => _pickPhoto(context))),
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
