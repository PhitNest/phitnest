// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:ui/ui.dart';

// class ChatTextTile extends StatelessWidget {
//   final String chatText;
//   final bool sendByMe;

//   const ChatTextTile({
//     super.key,
//     required this.chatText,
//     required this.sendByMe,
//   });

//   @override
//   Widget build(BuildContext context) => Align(
//         alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
//           margin: EdgeInsets.only(bottom: 20.h),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8.r),
//             gradient: sendByMe
//                 ? const LinearGradient(colors: [Colors.black, Colors.black])
//                 : const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [Color(0xFF5E5CE6), Color(0xFFBF5AF2)],
//                   ),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.r),
//               color: Colors.black,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Text(
//                 chatText,
//                 style: theme.textTheme.bodyMedium,
//               ),
//             ),
//           ),
//         ),
//       );
// }
