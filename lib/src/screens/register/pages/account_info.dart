part of '../ui.dart';

class RegisterAccountInfoPage extends StatelessWidget {
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
          StyledTextFormField(
            labelText: 'Your email address',
            textController: context.registerBloc.emailController,
            validator: EmailValidator.validateEmail,
          ),
          24.verticalSpace,
          StyledTextFormField(
            labelText: 'Password',
            textController: context.registerBloc.passwordController,
            validator: validatePassword,
          ),
          24.verticalSpace,
          StyledTextFormField(
            labelText: 'Confirm password',
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
