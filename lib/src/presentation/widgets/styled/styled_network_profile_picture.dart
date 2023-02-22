import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils/utils.dart';

class StyledNetworkProfilePicture extends StatelessWidget {
  final String url;
  final String? cacheKey;

  const StyledNetworkProfilePicture({
    required this.url,
    this.cacheKey,
  }) : super();

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: url,
        cacheKey: cacheKey,
        progressIndicatorBuilder: (context, child, loadingProgress) => SizedBox(
          width: 1.sw,
          height: 1.sw / kProfilePictureAspectRatio.aspectRatio,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.progress,
            ),
          ),
        ),
        errorWidget: (context, child, loadingProgress) => SizedBox(
          width: 1.sw,
          height: 1.sw / kProfilePictureAspectRatio.aspectRatio,
          child: Icon(Icons.error),
        ),
      );
}
