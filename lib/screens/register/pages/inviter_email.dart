part of '../ui.dart';

final class RegisterInviterEmailPage extends StatelessWidget {
  final RegisterControllers controllers;
  final void Function() onSubmit;

  const RegisterInviterEmailPage({
    super.key,
    required this.controllers,
    required this.onSubmit,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          120.verticalSpace,
          Text(
            'Inviter email',
            style: theme.textTheme.bodyLarge,
          ),
          42.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Inviter Email',
            controller: controllers.inviterEmailController,
            validator: EmailValidator.validateEmail,
          ),
          28.verticalSpace,
          Center(
            child: ElevatedButton(
              onPressed: onSubmit,
              child: Text(
                'SUBMIT',
                style: theme.textTheme.bodySmall,
              ),
            ),
          )
        ],
      );
}
