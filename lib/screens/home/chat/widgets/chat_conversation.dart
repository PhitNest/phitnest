// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../theme.dart';
// import 'chat_text_tile.dart';

// class ChatConversation extends StatelessWidget {
//   final String name;

//   const ChatConversation({super.key, required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             58.verticalSpace,
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   icon: const Icon(
//                     Icons.arrow_back_ios_new,
//                     color: Color(0xFFF4F9FF),
//                   ),
//                 ),
//                 Text(
//                   name,
//                   style: AppTheme.instance.theme.textTheme.bodyLarge,
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(
//                     Icons.more_vert,
//                     color: Color(0xFFF4F9FF),
//                   ),
//                 ),
//               ],
//             ),
//             23.verticalSpace,
//             SizedBox(
//               height: 0.72.sh,
//               child: ListView(
//                 children: const [
//                   ChatTextTile(
//                     chatText: 'Hey, how are you?',
//                     sendByMe: false,
//                   ),
//                   ChatTextTile(
//                     chatText: 'Hey, how are you?',
//                     sendByMe: false,
//                   ),
//                   ChatTextTile(
//                     chatText: 'Hey, how are you?',
//                     sendByMe: true,
//                   ),
//                   ChatTextTile(
//                     chatText: 'Hey, how are you?',
//                     sendByMe: false,
//                   ),
//                   ChatTextTile(
//                     chatText: 'Hey, how are you?',
//                     sendByMe: true,
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             Container(
//               margin: EdgeInsets.only(bottom: 15.h),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.r),
//                 color: Colors.transparent,
//                 border: Border.all(
//                   color: Colors.white,
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 0.65.sw,
//                     child: Center(
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: 'Write a message...',
//                           hintStyle:
//                               AppTheme.instance.theme.textTheme.bodySmall,
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 15.w,
//                             vertical: 15.h,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         'SEND',
//                         style: AppTheme.instance.theme.textTheme.bodySmall!
//                             .copyWith(fontStyle: FontStyle.normal),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
