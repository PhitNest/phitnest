import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../widgets/styled/styled.dart';

class UploadingPhotoPage extends StatelessWidget {
  const UploadingPhotoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Column(
          children: [
            double.infinity.horizontalSpace,
            220.verticalSpace,
            CircularProgressIndicator(),
          ],
        ),
      );
}
