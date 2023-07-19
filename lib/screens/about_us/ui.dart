// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../theme.dart';

// class AboutUsScreen extends StatelessWidget {
//   const AboutUsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 40.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             64.verticalSpace,
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   icon: const Icon(
//                     Icons.arrow_back_ios_new,
//                     color: Color(0xFFF4F9FF),
//                   ),
//                 ),
//                 12.horizontalSpace,
//                 Text(
//                   'About Us',
//                   style: AppTheme.instance.theme.textTheme.bodyLarge,
//                 ),
//               ],
//             ),
//             25.verticalSpace,
//             TextButton(
//               onPressed: () {},
//               child: Text(
//                 'Terms of Service',
//                 style: AppTheme.instance.theme.textTheme.bodyMedium!.copyWith(
//                   fontStyle: FontStyle.normal,
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: Text(
//                 'Privacy Policy',
//                 style: AppTheme.instance.theme.textTheme.bodyMedium!.copyWith(
//                   fontStyle: FontStyle.normal,
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () => showLicensePage(context: context),
//               child: Text(
//                 'Software Licenses',
//                 style: AppTheme.instance.theme.textTheme.bodyMedium!.copyWith(
//                   fontStyle: FontStyle.normal,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
