part of '../ui.dart';

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required';
  }
  return null;
}

class RegisterNamePage extends StatelessWidget {
  const RegisterNamePage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: context.registerBloc.firstNameController,
            validator: validateName,
          ),
          TextFormField(
            controller: context.registerBloc.lastNameController,
            validator: validateName,
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
