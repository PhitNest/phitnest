import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme.dart';

class StyledNavBar extends StatelessWidget {
  final int pageIndex;
  final Function() longPressLogo;

  static const String colouredLogoUrl = 'assets/images/logo_color.svg';

  StyledNavBar({
    Key? key,
    required this.pageIndex,
    required this.longPressLogo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.5,
            spreadRadius: 0.0,
            color: Colors.black,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Ink(
        width: double.infinity,
        height: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'NEWS',
              style: pageIndex == 0
                  ? theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )
                  : theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
            ),
            Text(
              'EXPLORE',
              style: pageIndex == 1
                  ? theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )
                  : theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
            ),
            GestureDetector(
              onLongPress: longPressLogo,
              child: SvgPicture.asset(
                colouredLogoUrl,
                width: 50.0.w,
                height: 38.62.h,
              ),
            ),
            Text(
              'CHAT',
              style: pageIndex == 2
                  ? theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )
                  : theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
            ),
            Text(
              'OPTIONS',
              style: pageIndex == 3
                  ? theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )
                  : theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget StyledNavBar(BuildContext context) {
//   return Container(
//     height: 66.h,
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       boxShadow: [
//         BoxShadow(
//           blurRadius: 8.5,
//           spreadRadius: 0.0,
//           color: Colors.black,
//           offset: Offset(0, 7),
//         ),
//       ],
//     ),
//     child: Ink(
//       width: double.infinity,
//       height: double.maxFinite,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Text(
//             'NEWS',
//             style: theme.textTheme.bodySmall!.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             'EXPLORE',
//             style: theme.textTheme.bodySmall!.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SvgPicture.asset(
//             'assets/images/logo_color.svg',
//             width: 50.0.w,
//             height: 38.62.h,
//           ),
//           Text(
//             'CHAT',
//             style: theme.textTheme.bodySmall!.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             'OPTIONS',
//             style: theme.textTheme.bodySmall!.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
