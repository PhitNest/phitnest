// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../common/theme.dart';
// import '../../../common/validators.dart';
// import '../../widgets/styled/styled.dart';
// import '../pages.dart';
// import '../registration/ui/registration_page.dart';
// import 'login_bloc.dart';
// import 'login_state.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => BlocProvider<LoginBloc>(
//         create: (context) => LoginBloc(),
//         child: BlocBuilder<LoginBloc, LoginState>(
//           builder: (context, state) => Scaffold(
//             body: SingleChildScrollView(
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               child: SizedBox(
//                 height: 1.sh,
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height:
//                           (120 - MediaQuery.of(context).viewInsets.bottom / 4)
//                               .h,
//                       width: double.infinity,
//                     ),
//                     Image.asset(
//                       'assets/images/logo.png',
//                       width: 61.59.w,
//                     ),
//                     25.verticalSpace,
//                     Text(
//                       'PhitNest is Better Together',
//                       style: theme.textTheme.headlineMedium,
//                     ),
//                     40.verticalSpace,
//                     SizedBox(
//                       width: 291.w,
//                       child: Form(
//                         key: state.formKey,
//                         autovalidateMode: state.autoValidateMode,
//                         child: Column(
//                           children: [
//                             StyledUnderlinedTextField(
//                               controller: state.emailController,
//                               hint: 'Email',
//                               error: state.error,
//                               errorMaxLines: 1,
//                               focusNode: state.emailFocusNode,
//                               keyboardType: TextInputType.emailAddress,
//                               textInputAction: TextInputAction.next,
//                               onChanged: (value) =>
//                                   context.read<LoginBloc>().textEdited(),
//                               validator: (value) => validateEmail(value),
//                             ),
//                             StyledPasswordField(
//                               controller: state.passwordController,
//                               hint: 'Password',
//                               error: state.error,
//                               focusNode: state.passwordFocusNode,
//                               textInputAction: TextInputAction.done,
//                               validator: (value) => validatePassword(value),
//                               onChanged: (value) =>
//                                   context.read<LoginBloc>().textEdited(),
//                               onFieldSubmitted: (value) {
//                                 if (!(state is LoginLoading)) {
//                                   context.read<LoginBloc>().submit();
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     16.verticalSpace,
//                     Builder(
//                       builder: (context) {
//                         if (state is LoginLoading) {
//                           return const CircularProgressIndicator();
//                         } else {
//                           return StyledButton(
//                             text: 'SIGN IN',
//                             onPressed: () => context.read<LoginBloc>().submit(),
//                           );
//                         }
//                       },
//                     ),
//                     Spacer(),
//                     StyledUnderlinedTextButton(
//                       text: 'FORGOT PASSWORD?',
//                       onPressed: () {
//                         if (state is LoginLoading) {
//                           context.read<LoginBloc>().cancelLoading();
//                         }
//                         Navigator.push(
//                           context,
//                           CupertinoPageRoute(
//                             builder: (context) => ForgotPasswordPage(),
//                           ),
//                         );
//                       },
//                     ),
//                     StyledUnderlinedTextButton(
//                       text: 'REGISTER',
//                       onPressed: () {
//                         if (state is LoginLoading) {
//                           context.read<LoginBloc>().cancelLoading();
//                         }
//                         Navigator.push(
//                           context,
//                           CupertinoPageRoute(
//                             builder: (context) => RegistrationPage(),
//                           ),
//                         );
//                       },
//                     ),
//                     48.verticalSpace,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
// }
