import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';
import '../../../widgets/widgets.dart';

class FriendCard extends StatelessWidget {
  final String name;
  final VoidCallback onRemove;

  const FriendCard({
    Key? key,
    required this.name,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: 24.h,
        ),
        child: Row(
          children: [
            Text(
              name,
              style: theme.textTheme.headlineMedium!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            StyledButton(
              interiorPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              onPressed: onRemove,
              backgroundColor: Colors.transparent,
              child: Text(
                'REMOVE',
                style: theme.textTheme.bodySmall!.copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      );
}
