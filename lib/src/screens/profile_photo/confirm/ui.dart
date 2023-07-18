// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:phitnest_core/core.dart';

// import '../../../theme.dart';
// import '../../../widgets/widgets.dart';
// import '../../home/ui.dart';
// import 'bloc/bloc.dart';

// class ConfirmPhotoScreen extends StatelessWidget {
//   final CroppedFile photo;

//   const ConfirmPhotoScreen({
//     super.key,
//     required this.photo,
//   }) : super();

//   @override
//   Widget build(BuildContext context) => BlocConsumer<CognitoBloc, CognitoState>(
//         listener: (context, cognitoState) {},
//         builder: (context, cognitoState) => BlocProvider(
//           create: (_) => ConfirmPhotoBloc(photo),
//           child: BlocConsumer<ConfirmPhotoBloc, ConfirmPhotoState>(
//             listener: (context, screenState) {
//               switch (screenState) {
//                 case ConfirmPhotoSuccessState():
//                   Navigator.of(context).pushAndRemoveUntil(
//                     CupertinoPageRoute<void>(
//                       builder: (context) => const HomeScreen(),
//                     ),
//                     (_) => false,
//                   );
//                 case ConfirmPhotoFailureState(error: final failure):
//                   StyledBanner.show(
//                     message: failure.message,
//                     error: true,
//                   );
//                 default:
//               }
//             },
//             builder: (context, screenState) => Scaffold(
//               body: Center(
//                 child: Column(
//                   children: [
//                     Image.file(
//                       File(photo.path),
//                       height: 444.h,
//                       width: double.infinity,
//                     ),
//                     56.verticalSpace,
//                     ElevatedButton(
//                       child: Text(
//                         'CONFIRM',
//                         style: AppTheme.instance.theme.textTheme.bodySmall,
//                       ),
//                       onPressed: () => context.confirmPhotoBloc.add(
//                         ConfirmPhotoConfirmEvent(
//                           session:
//                               (cognitoState as CognitoLoggedInState).session,
//                         ),
//                       ),
//                     ),
//                     12.verticalSpace,
//                     StyledOutlineButton(
//                       text: 'BACK',
//                       onPress: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
// }
