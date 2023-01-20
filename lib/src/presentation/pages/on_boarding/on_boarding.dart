// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../common/theme.dart';
// import '../../widgets/styled/styled.dart';
// import '../pages.dart';

// class OnBoardingPage extends StatelessWidget {
//   const OnBoardingPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: Column(
//           children: [
//             SizedBox(
//               height: 120.h,
//               width: double.infinity,
//             ),
//             Text(
//               "It takes a village\nto live a healthy life",
//               style: theme.textTheme.headlineLarge,
//               textAlign: TextAlign.center,
//             ),
//             40.verticalSpace,
//             Text(
//               "Meet people at your fitness club.\nAchieve your goals together.\nLive a healthy life!",
//               style: theme.textTheme.labelLarge,
//               textAlign: TextAlign.center,
//             ),
//             Spacer(),
//             StyledButton(
//               onPressed: () => Navigator.pushReplacement(
//                 context,
//                 CupertinoPageRoute(
//                   builder: (context) => LoginPage(),
//                 ),
//               ),
//               text: "LET'S GET STARTED",
//             ),
//             167.verticalSpace,
//           ],
//         ),
//       );
// }
