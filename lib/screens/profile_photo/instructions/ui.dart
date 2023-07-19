// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../theme.dart';
// import '../../../widgets/styled_outline_button.dart';
// import '../confirm/ui.dart';
// import 'bloc/bloc.dart';

// class PhotoInstructionsScreen extends StatelessWidget {
//   const PhotoInstructionsScreen({super.key}) : super();

//   @override
//   Widget build(BuildContext context) => BlocProvider(
//         create: (_) => PhotoInstructionsBloc(),
//         child: BlocConsumer<PhotoInstructionsBloc, PhotoInstructionsState>(
//           listener: (context, screenState) {
//             switch (screenState) {
//               case PhotoInstructionsPickedState(photo: final photo):
//                 Navigator.of(context).push(
//                   CupertinoPageRoute<void>(
//                     builder: (context) => ConfirmPhotoScreen(
//                       photo: photo,
//                     ),
//                   ),
//                 );
//               default:
//             }
//           },
//           builder: (context, screenState) => Scaffold(
//             body: Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 40.w),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     96.verticalSpace,
//                     Text(
//                       'First, let\'s put a face to your name.',
//                       style: AppTheme.instance.theme.textTheme.bodyLarge,
//                     ),
//                     32.verticalSpace,
//                     Text(
//                       'Add a photo of yourself\n**from the SHOULDERS UP**\n\n'
//                       'Just enough for gym buddies to recognize you! Like this...',
//                       style: AppTheme.instance.theme.textTheme.bodyMedium,
//                     ),
//                     28.verticalSpace,
//                     Center(
//                       child: Image.asset(
//                         'assets/images/selfie.png',
//                         width: 200.w,
//                       ),
//                     ),
//                     32.verticalSpace,
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: () => context.photoInstructionsBloc.add(
//                           const PhotoInstructionsTakePhotoEvent(),
//                         ),
//                         child: Text(
//                           'TAKE PHOTO',
//                           style: AppTheme.instance.theme.textTheme.bodySmall,
//                         ),
//                       ),
//                     ),
//                     12.verticalSpace,
//                     Center(
//                       child: StyledOutlineButton(
//                         onPress: () => context.photoInstructionsBloc.add(
//                           const PhotoInstructionsPickEvent(),
//                         ),
//                         text: 'UPLOAD PHOTO',
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
// }
