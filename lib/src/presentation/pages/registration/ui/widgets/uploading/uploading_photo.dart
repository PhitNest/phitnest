import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadingPhotoPage extends StatelessWidget {
  const UploadingPhotoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            double.infinity.horizontalSpace,
            220.verticalSpace,
            CircularProgressIndicator(),
          ],
        ),
      );
}
