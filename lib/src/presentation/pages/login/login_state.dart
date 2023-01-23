// import 'package:async/async.dart';
// import 'package:flutter/cupertino.dart';

// import '../bloc_state.dart';

// abstract class LoginState extends BlocState {
//   final TextEditingController emailController;
//   final TextEditingController passwordController;
//   final FocusNode emailFocusNode;
//   final FocusNode passwordFocusNode;
//   final AutovalidateMode autoValidateMode;
//   final GlobalKey<FormState> formKey;
//   final String? error;

//   const LoginState({
//     required this.emailController,
//     required this.passwordController,
//     required this.autoValidateMode,
//     required this.formKey,
//     required this.emailFocusNode,
//     required this.passwordFocusNode,
//     this.error,
//   }) : super();

//   @override
//   List<Object> get props => [
//         emailController,
//         passwordController,
//         autoValidateMode,
//         formKey,
//         emailFocusNode,
//         passwordFocusNode,
//         error ?? '',
//       ];

//   @override
//   Future<void> dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     emailFocusNode.dispose();
//     passwordFocusNode.dispose();
//     return super.dispose();
//   }
// }

// class LoginInitial extends LoginState {
//   const LoginInitial({
//     required super.autoValidateMode,
//     required super.emailController,
//     required super.formKey,
//     required super.passwordController,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     super.error,
//   }) : super();

//   LoginInitial copyWith({
//     TextEditingController? emailController,
//     TextEditingController? passwordController,
//     AutovalidateMode? autoValidateMode,
//     GlobalKey<FormState>? formKey,
//     String? error,
//     FocusNode? emailFocusNode,
//     FocusNode? passwordFocusNode,
//   }) =>
//       LoginInitial(
//         emailController: emailController ?? this.emailController,
//         passwordController: passwordController ?? this.passwordController,
//         autoValidateMode: autoValidateMode ?? this.autoValidateMode,
//         formKey: formKey ?? this.formKey,
//         error: error ?? this.error,
//         emailFocusNode: emailFocusNode ?? this.emailFocusNode,
//         passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
//       );
// }

// class LoginLoading extends LoginInitial {
//   final CancelableOperation operation;

//   const LoginLoading({
//     required this.operation,
//     required super.autoValidateMode,
//     required super.emailController,
//     required super.formKey,
//     required super.passwordController,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     super.error,
//   }) : super();

//   LoginLoading copyWith({
//     TextEditingController? emailController,
//     TextEditingController? passwordController,
//     AutovalidateMode? autoValidateMode,
//     GlobalKey<FormState>? formKey,
//     String? error,
//     FocusNode? emailFocusNode,
//     FocusNode? passwordFocusNode,
//     CancelableOperation? operation,
//   }) =>
//       LoginLoading(
//         emailController: emailController ?? this.emailController,
//         passwordController: passwordController ?? this.passwordController,
//         autoValidateMode: autoValidateMode ?? this.autoValidateMode,
//         formKey: formKey ?? this.formKey,
//         error: error ?? this.error,
//         emailFocusNode: emailFocusNode ?? this.emailFocusNode,
//         passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
//         operation: operation ?? this.operation,
//       );

//   @override
//   Future<void> dispose() async {
//     await operation.cancel();
//     return super.dispose();
//   }

//   @override
//   List<Object> get props => [
//         ...super.props,
//         operation,
//       ];
// }