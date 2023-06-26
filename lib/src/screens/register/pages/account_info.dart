part of '../ui.dart';

class RegisterAccountInfoPage extends StatelessWidget {
  const RegisterAccountInfoPage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: context.registerBloc.emailController,
            validator: EmailValidator.validateEmail,
          ),
          TextFormField(
            controller: context.registerBloc.passwordController,
            validator: validatePassword,
          ),
          TextFormField(
            validator: (value) =>
                value == context.registerBloc.passwordController.text
                    ? null
                    : 'Passwords do not match',
          ),
          TextButton(
            onPressed: () {
              if (context.registerBloc.formKey.currentState!.validate()) {
                _nextPage(context);
              } else {
                context.registerBloc.add(const RegisterFormRejectedEvent());
              }
            },
            child: const Text('Next'),
          )
        ],
      );
}
