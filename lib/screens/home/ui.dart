// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:phitnest_core/core.dart';

// import '../../widgets/widgets.dart';
// import '../profile_photo/instructions/ui.dart';
// import 'bloc/bloc.dart';
// import 'chat/ui.dart';
// import 'explore/ui.dart';
// import 'options/ui.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key}) : super();

//   @override
//   Widget build(BuildContext context) => BlocConsumer<CognitoBloc, CognitoState>(
//         listener: (context, cognitoState) {},
//         builder: (context, cognitoState) => BlocProvider(
//           create: (_) => HomeBloc(
//             (cognitoState as CognitoLoggedInState).session,
//           ),
//           child: BlocConsumer<HomeBloc, HomeState>(
//             listener: (context, screenState) {
//               switch (screenState) {
//                 case HomeSentFriendRequestState():
//                   StyledBanner.show(
//                       message: 'Sent friend request', error: false);
//                 case HomeFailureState():
//                   Navigator.pushReplacement(
//                     context,
//                     CupertinoPageRoute<void>(
//                       builder: (_) => const PhotoInstructionsScreen(),
//                     ),
//                   );
//                 default:
//               }
//             },
//             builder: (context, screenState) => Scaffold(
//               body: switch (screenState) {
//                 HomeSentFriendRequestState(
//                   response: final response,
//                   currPage: final currPage
//                 ) ||
//                 HomeLoadedState(
//                   response: final response,
//                   currPage: final currPage
//                 ) ||
//                 HomeSendingFriendRequestState(
//                   response: final response,
//                   currPage: final currPage
//                 ) =>
//                   Column(
//                     children: [
//                       Expanded(
//                         child: switch (currPage) {
//                           0 => ExploreScreen(
//                               users: response.explore,
//                               pageController: context.homeBloc.pageController,
//                             ),
//                           1 => ChatScreen(
//                               friends: response.friends,
//                             ),
//                           _ => OptionsScreen(
//                               pfp: response.profilePhoto,
//                             )
//                         },
//                       ),
//                       StyledNavBar(
//                         page: currPage,
//                         logoState: LogoState.animated,
//                         onReleaseLogo: () {},
//                         onPressDownLogo: () {
//                           if (currPage == 0) {
//                             context.homeBloc.add(
//                               HomeSendFriendRequestEvent(
//                                 index: context.homeBloc.pageController.page!
//                                     .round(),
//                               ),
//                             );
//                           } else {
//                             context.homeBloc.add(HomeTabChangedEvent(index: 0));
//                           }
//                         },
//                         onPressedNews: () {},
//                         onPressedExplore: () =>
//                             context.homeBloc.add(HomeTabChangedEvent(index: 0)),
//                         onPressedChat: () =>
//                             context.homeBloc.add(HomeTabChangedEvent(index: 1)),
//                         onPressedOptions: () =>
//                             context.homeBloc.add(HomeTabChangedEvent(index: 2)),
//                         friendRequestCount: 0,
//                       ),
//                     ],
//                   ),
//                 _ => Center(child: CircularProgressIndicator()),
//               },
//             ),
//           ),
//         ),
//       );
// }
