import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

part 'pages/account_info.dart';
part 'pages/inviter_email.dart';
part 'pages/loading.dart';
part 'pages/name.dart';

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

typedef RegisterFormBloc = FormBloc<RegisterControllers>;
typedef RegisterFormConsumer = FormConsumer<RegisterControllers>;
typedef RegisterLoaderBloc = LoaderBloc<RegisterParams, RegisterResponse>;
typedef RegisterLoaderConsumer
    = LoaderConsumer<RegisterParams, RegisterResponse>;

extension GetRegisterBlocs on BuildContext {
  RegisterFormBloc get registerFormBloc => BlocProvider.of(this);
  RegisterLoaderBloc get registerLoaderBloc => loader();
}

void _nextPage(BuildContext context) =>
    context.registerFormBloc.controllers.pageController.nextPage(
      duration: const Duration(
        milliseconds: 400,
      ),
      curve: Curves.easeInOut,
    );

final class RegisterScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const RegisterScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => RegisterFormBloc(RegisterControllers()),
            ),
            BlocProvider(
              create: (_) => RegisterLoaderBloc(
                load: (params) => register(
                  params: params,
                  pool: apiInfo.pool,
                ),
              ),
            ),
          ],
          child: RegisterFormConsumer(
            listener: (context, screenState) {},
            builder: (context, screenState) => Form(
              key: context.registerFormBloc.formKey,
              autovalidateMode: screenState.autovalidateMode,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: RegisterLoaderConsumer(
                  listener: (context, loaderState) {
                    switch (loaderState) {
                      case LoaderLoadedState(data: final response):
                        switch (response) {
                          case RegisterSuccess(user: final user):
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute<void>(
                                builder: (context) => ConfirmEmailScreen(),
                              ),
                            );
                          case RegisterFailureResponse(message: final message):
                            StyledBanner.show(message: message, error: true);
                        }
                      default:
                    }
                  },
                  builder: (context, loaderState) => switch (loaderState) {
                    LoaderLoadingState() => const RegisterLoadingPage(),
                    _ => PageView(
                        controller:
                            context.registerFormBloc.controllers.pageController,
                        children: const [
                          RegisterNamePage(),
                          RegisterAccountInfoPage(),
                          RegisterInviterEmailPage(),
                        ],
                      ),
                  },
                ),
              ),
            ),
          ),
        ),
      );
}
