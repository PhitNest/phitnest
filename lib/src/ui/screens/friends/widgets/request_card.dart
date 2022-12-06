import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../entities/entities.dart';
import '../../../theme.dart';
import '../../../widgets/widgets.dart';

class RequestCard extends StatelessWidget {
  final PublicUserEntity user;
  final VoidCallback onAdd;
  final VoidCallback onIgnore;

  const RequestCard({
    Key? key,
    required this.user,
    required this.onAdd,
    required this.onIgnore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: 24.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                user.fullName,
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            StyledButton(
              interiorPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              onPressed: onAdd,
              backgroundColor: Color(0xFFFFE3E3),
              child: Text(
                'ADD',
                style: theme.textTheme.bodySmall!.copyWith(color: Colors.black),
              ),
            ),
            12.horizontalSpace,
            StyledButton(
              interiorPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              onPressed: onIgnore,
              backgroundColor: Colors.transparent,
              child: Text(
                'IGNORE',
                style: theme.textTheme.bodySmall!.copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      );
}
