import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';

class RegisterPageOneView extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final FormFieldValidator validateFirstName;
  final FormFieldValidator validateLastName;
  final AutovalidateMode autovalidateMode;
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressedNext;
  final VoidCallback onTappedFirstName;
  final VoidCallback onTappedLastName;
  final FocusNode firstNameFocus;
  final FocusNode lastNameFocus;
  final ScrollController scrollController;

  RegisterPageOneView({
    required this.firstNameController,
    required this.lastNameController,
    required this.onPressedNext,
    required this.autovalidateMode,
    required this.formKey,
    required this.validateFirstName,
    required this.validateLastName,
    required this.onTappedFirstName,
    required this.onTappedLastName,
    required this.firstNameFocus,
    required this.lastNameFocus,
    required this.scrollController,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        useBackButton: true,
        scrollController: scrollController,
        body: Column(
          children: [
            28.verticalSpace,
            Text(
              'Register',
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            35.verticalSpace,
            SizedBox(
              width: 291.w,
              child: Form(
                key: formKey,
                autovalidateMode: autovalidateMode,
                child: Column(
                  children: [
                    SizedBox(
                      height: 34.h,
                      child: TextInputField(
                        hint: 'First Name',
                        onTap: onTappedFirstName,
                        focusNode: firstNameFocus,
                        validator: validateFirstName,
                        controller: firstNameController,
                        inputAction: TextInputAction.next,
                      ),
                    ),
                    16.verticalSpace,
                    SizedBox(
                      height: 34.h,
                      child: TextInputField(
                        hint: 'Last Name',
                        focusNode: lastNameFocus,
                        onTap: onTappedLastName,
                        validator: validateLastName,
                        controller: lastNameController,
                      ),
                    )
                  ],
                ),
              ),
            ),
            87.verticalSpace,
            StyledButton(
              onPressed: onPressedNext,
              child: Text('NEXT'),
            ),
            60.verticalSpace,
          ],
        ),
      );
}
