// import 'package:camera/camera.dart';
// import 'package:cross_file_image/cross_file_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// import '../../../app_bloc.dart';
// import '../../../common/utils.dart';
// import '../../../common/theme.dart';
// import '../../../common/validators.dart';
// import '../../../domain/entities/entities.dart';
// import '../../widgets/styled/styled.dart';
// import '../pages.dart';
// import 'registration_bloc.dart';
// import 'registration_state.dart';

// class RegistrationPage extends StatelessWidget {
//   const RegistrationPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => BlocProvider<RegistrationBloc>(
//         create: (context) => RegistrationBloc(),
//         child: BlocBuilder<RegistrationBloc, RegistrationState>(
//           builder: (context, state) {
//             final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
//             if (state is RegistrationSuccessState) {
//               context.read<AppBloc>().setRegistered(
//                   user: state.user, password: state.passwordController.text);
//               Future.delayed(
//                 Duration.zero,
//                 () => Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ConfirmEmailPage(
//                       email: state.emailController.text.trim(),
//                     ),
//                   ),
//                 ),
//               );
//             }
//             if (state is RegistrationLoading ||
//                 state is RegistrationSuccessState ||
//                 state is S3RequestLoadingState) {
//               return Scaffold(
//                 body: Column(
//                   children: [
//                     double.infinity.horizontalSpace,
//                     220.verticalSpace,
//                     CircularProgressIndicator(),
//                     24.verticalSpace,
//                     Text(
//                       "Registering...",
//                       style: theme.textTheme.labelLarge,
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return Scaffold(
//                 body: SingleChildScrollView(
//                   keyboardDismissBehavior:
//                       ScrollViewKeyboardDismissBehavior.onDrag,
//                   child: SizedBox(
//                     height: 1.sh,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: PageView.builder(
//                             controller: state.pageController,
//                             onPageChanged: (value) =>
//                                 context.read<RegistrationBloc>().swipe(value),
//                             itemCount: state.pageScrollLimit,
//                             itemBuilder: (context, index) {
//                               switch (index) {
//                                 case 0:

//                                 case 1:
//                                   return;
//                                 case 2:
//                                   return;
//                                 case 3:
//                                   return;
//                                 case 4:
//                                   return 
//                                 case 5:
//                                   if (state is ProfilePictureUploaded) {
//                                     return Column(
//                                       children: [
//                                         40.verticalSpace,
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             image: DecorationImage(
//                                               fit: BoxFit.cover,
//                                               alignment:
//                                                   FractionalOffset.bottomCenter,
//                                               image: XFileImage(
//                                                 state.profilePicture,
//                                               ),
//                                             ),
//                                           ),
//                                           child: SizedBox(
//                                             width: 1.sw,
//                                             height: 333.h,
//                                           ),
//                                         ),
//                                         20.verticalSpace,
//                                         Builder(
//                                           builder: (context) {
//                                             if (state
//                                                 is RegistrationRequestErrorState) {
//                                               return Column(
//                                                 children: [
//                                                   Text(
//                                                     state.failure.message,
//                                                     textAlign: TextAlign.center,
//                                                     style: theme
//                                                         .textTheme.labelLarge!
//                                                         .copyWith(
//                                                       color: theme.errorColor,
//                                                     ),
//                                                   ),
//                                                   8.verticalSpace,
//                                                   StyledButton(
//                                                     text: 'RETRY',
//                                                     onPressed: () => context
//                                                         .read<
//                                                             RegistrationBloc>()
//                                                         .submitPageSix(),
//                                                   ),
//                                                 ],
//                                               );
//                                             } else {
//                                               return StyledButton(
//                                                 text: 'CONFIRM',
//                                                 onPressed: () => context
//                                                     .read<RegistrationBloc>()
//                                                     .submitPageSix(),
//                                               );
//                                             }
//                                           },
//                                         ),
//                                         StyledUnderlinedTextButton(
//                                           text: 'RETAKE',
//                                           onPressed: () => context
//                                               .read<RegistrationBloc>()
//                                               .setProfilePicture(null),
//                                         ),
//                                         Spacer(),
//                                         StyledUnderlinedTextButton(
//                                           text: 'ALBUMS',
//                                           onPressed: () => ImagePicker()
//                                               .pickImage(
//                                                   source: ImageSource.gallery)
//                                               .then(
//                                             (image) {
//                                               if (image != null) {
//                                                 context
//                                                     .read<RegistrationBloc>()
//                                                     .setProfilePicture(image);
//                                               }
//                                             },
//                                           ),
//                                         ),
//                                         32.verticalSpace,
//                                       ],
//                                     );
//                                   } else {
//                                     final cameraController =
//                                         (state as GymsLoaded).cameraController;
//                                     return 
//                                   }
//                               }
//                               return Container();
//                             },
//                           ),
//                         ),
//                         StyledPageIndicator(
//                           currentPage: state.pageIndex,
//                           totalPages: 6,
//                         ),
//                         48.verticalSpace,
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       );
// }
