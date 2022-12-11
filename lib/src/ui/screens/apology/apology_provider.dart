import 'package:flutter/material.dart';

import '../../../common/validators.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'apology_state.dart';
import 'apology_view.dart';

class ApologyProvider extends ScreenProvider<ApologyState, ApologyView> {
  const ApologyProvider() : super();

  @override
  ApologyView build(BuildContext context, ApologyState state) => ApologyView(
        autovalidateMode: state.validateMode,
        scrollController: state.scrollController,
        onPressedSubmit: () => state.formKey.currentState!.validate()
            ? Navigator.pushAndRemoveUntil(
                context,
                NoAnimationMaterialPageRoute(
                  builder: (_) => ThankYouProvider(
                    name: state.nameController.text,
                  ),
                ),
                (_) => false,
              )
            : state.validateMode = AutovalidateMode.always,
        nameController: state.nameController,
        emailController: state.emailController,
        validateFirstName: (val) => validateName(val),
        validateEmail: (val) => validateEmail(val),
        formKey: state.formKey,
        nameFocusNode: state.nameFocusNode,
        emailFocusNode: state.emailFocusNode,
        onTapName: () => Future.delayed(
          const Duration(milliseconds: 600),
          () => state.onFocusName(true),
        ),
        onTapEmail: () => Future.delayed(
          const Duration(milliseconds: 600),
          () => state.onFocusEmail(true),
        ),
      );

  @override
  ApologyState buildState() => ApologyState();
}
