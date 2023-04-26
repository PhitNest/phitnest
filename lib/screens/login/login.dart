import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phitnest_core/auth/auth.dart';

import '../../common/widgets/styled_button.dart';
import '../../common/widgets/styled_password_field.dart';
import '../../common/widgets/styled_underline_text_field.dart';
import '../../theme.dart';

final Provider<Auth> authProvider =
    Provider<Auth>((ref) => Auth.fromServerStatus('sandbox'));

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final auth = ref.watch(authProvider);

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: [
              Text(
                'PhitNest Admin',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.black26,
                thickness: 1.5,
                height: 15,
                endIndent: 80,
                indent: 80,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                'Login',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 50),
              Form(
                child: SizedBox(
                  width: size.width * 0.5,
                  child: Column(
                    children: [
                      StyledUnderlinedTextField(
                        hint: 'Email',
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      const SizedBox(height: 10),
                      StyledPasswordField(
                        hint: 'Password',
                        textInputAction: TextInputAction.done,
                        controller: passwordController,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                      ),
                      const SizedBox(height: 20),
                      StyledButton(
                        text: 'Submit',
                        onPressed: () => auth.login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
