import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../register.dart';

final class RegisterNamePage extends StatelessWidget {
  final RegisterControllers controllers;
  final void Function() onSubmit;

  const RegisterNamePage({
    super.key,
    required this.controllers,
    required this.onSubmit,
  }) : super();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            120.verticalSpace,
            Text(
              'Let\'s get started! \nWhat\'s is your name?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            42.verticalSpace,
            StyledUnderlinedTextField(
              hint: 'First name',
              controller: controllers.firstNameController,
              validator: validateNonEmpty,
              textInputAction: TextInputAction.next,
            ),
            24.verticalSpace,
            StyledUnderlinedTextField(
              hint: 'Last name',
              controller: controllers.lastNameController,
              validator: validateNonEmpty,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => onSubmit(),
            ),
            147.verticalSpace,
            ElevatedButton(
              onPressed: onSubmit,
              child: Text(
                'NEXT',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          ],
        ),
      );
}
