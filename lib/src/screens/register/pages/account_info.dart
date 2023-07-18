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
            style: AppTheme.instance.theme.textTheme.bodyLarge,
          ),
          42.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Your email address',
            controller: context.registerBloc.emailController,
            validator: EmailValidator.validateEmail,
          ),
          24.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Password',
            controller: context.registerBloc.passwordController,
            validator: validatePassword,
          ),
          24.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Confirm password',
            validator: (value) =>
                value == context.registerBloc.passwordController.text
                    ? null
                    : 'Passwords do not match',
          ),
          32.verticalSpace,
          ElevatedButton(
            onPressed: () {
              if (context.registerBloc.formKey.currentState!.validate()) {
                _nextPage(context);
              } else {
                context.registerBloc.add(const RegisterFormRejectedEvent());
              }
            },
            child: Text(
              'NEXT',
              style: AppTheme.instance.theme.textTheme.bodySmall,
            ),
          )
        ],
      );
}
