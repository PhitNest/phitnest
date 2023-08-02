part of 'register.dart';

final class RegisterControllers extends FormControllers {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final inviterEmailController = TextEditingController();
  final pageController = PageController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    inviterEmailController.dispose();
    pageController.dispose();
  }
}

extension on BuildContext {
  FormBloc<RegisterControllers> get registerFormBloc => BlocProvider.of(this);
}
