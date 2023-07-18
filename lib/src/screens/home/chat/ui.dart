// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../theme.dart';
// import '../../../widgets/styled_outline_button.dart';
// import '../bloc/bloc.dart';
// import 'widgets/chat_conversation.dart';
// import 'widgets/chat_tile.dart';
// import 'widgets/friend_request.dart';

// class ChatScreen extends StatelessWidget {
//   final List<Friendship> friends;

//   const ChatScreen({super.key, required this.friends});

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 40.w),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               68.verticalSpace,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Chats',
//                     style: AppTheme.instance.theme.textTheme.bodyLarge,
//                   ),
//                   StyledOutlineButton(
//                     onPress: () => Navigator.of(context).push(
//                       CupertinoPageRoute<void>(
//                         builder: (context) => const FriendRequestScreen(),
//                       ),
//                     ),
//                     text: 'FRIENDS',
//                   ),
//                 ],
//               ),
//               18.verticalSpace,
//               ...friends.map(
//                 (friend) => ChatTile(
//                   name: '${friend.other.firstName} ${friend.other.lastName}',
//                   message: friend.recentMessage?.text ?? 'Tap to chat',
//                   onTap: () => Navigator.of(context).push(
//                     CupertinoPageRoute<void>(
//                       builder: (context) => ChatConversation(
//                         name:
//                             '${friend.other.firstName} ${friend.other.lastName}',
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
// }
