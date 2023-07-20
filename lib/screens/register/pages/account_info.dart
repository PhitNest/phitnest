part of '../ui.dart';

final class RegisterAccountInfoPage extends StatelessWidget {
  final RegisterControllers controllers;
  final void Function() onSubmit;

  const RegisterAccountInfoPage({
    super.key,
    required this.controllers,
    required this.onSubmit,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          120.verticalSpace,
          Text(
            'Let\'s create your account!',
            style: theme.textTheme.bodyLarge,
          ),
          42.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Your email address',
            controller: controllers.emailController,
            validator: EmailValidator.validateEmail,
          ),
          24.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Password',
            controller: controllers.passwordController,
            validator: validatePassword,
          ),
          24.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Confirm password',
            validator: (value) => value == controllers.passwordController.text
                ? null
                : 'Passwords do not match',
          ),
          32.verticalSpace,
          ElevatedButton(
            onPressed: onSubmit,
            child: Text(
              'NEXT',
              style: theme.textTheme.bodySmall,
            ),
          )
        ],
      );
}
