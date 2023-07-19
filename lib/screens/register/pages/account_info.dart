part of '../ui.dart';

final class RegisterAccountInfoPage extends StatelessWidget {
  const RegisterAccountInfoPage({super.key}) : super();

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
            controller: context.registerFormBloc.controllers.emailController,
            validator: EmailValidator.validateEmail,
          ),
          24.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Password',
            controller: context.registerFormBloc.controllers.passwordController,
            validator: validatePassword,
          ),
          24.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Confirm password',
            validator: (value) => value ==
                    context.registerFormBloc.controllers.passwordController.text
                ? null
                : 'Passwords do not match',
          ),
          32.verticalSpace,
          ElevatedButton(
            onPressed: () => context.registerFormBloc.submit(
              onAccept: () => _nextPage(context),
            ),
            child: Text(
              'NEXT',
              style: theme.textTheme.bodySmall,
            ),
          )
        ],
      );
}
