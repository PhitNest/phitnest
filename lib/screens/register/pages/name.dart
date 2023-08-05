part of '../register.dart';

String? validateName(dynamic value) {
  if (value == null || (value is String && value.isEmpty)) {
    return 'Required';
  }
  return null;
}

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
              style: theme.textTheme.bodyLarge,
            ),
            42.verticalSpace,
            StyledUnderlinedTextField(
              hint: 'First name',
              controller: controllers.firstNameController,
              validator: validateName,
            ),
            24.verticalSpace,
            StyledUnderlinedTextField(
              hint: 'Last name',
              controller: controllers.lastNameController,
              validator: validateName,
            ),
            147.verticalSpace,
            ElevatedButton(
              onPressed: onSubmit,
              child: Text(
                'NEXT',
                style: theme.textTheme.bodySmall,
              ),
            )
          ],
        ),
      );
}
