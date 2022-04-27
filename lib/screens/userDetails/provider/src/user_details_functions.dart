import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigation/navigation.dart';
import 'package:phitnest/screens/userDetails/provider/src/user_details_model.dart';

import '../../../../models/models.dart';
import '../../../screen_utils.dart';
import '../../../screens.dart';

class UserDetailsFunctions {
  late final UserModel user;
  final BuildContext context;
  final UserDetailsModel model;

  UserDetailsFunctions(
      {required this.context, required this.user, required this.model}) {
    model.images = _getPhotoUrls();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: DisplayUtils.isDarkMode ? Colors.black : Colors.white));
    model.gridPages = buildGridView();
  }

  List<String?> _getPhotoUrls() {
    List<String?> urls = [user.profilePictureURL];
    urls.addAll(user.photos.cast<String>());
    urls.removeWhere((element) => element == null);
    return urls;
  }

  List<Widget> buildGridView() {
    model.pages.clear();
    List<Widget> gridViewPages = [];
    var len = model.images.length;
    var size = 6;
    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      model.pages.add(model.images.sublist(i, end));
    }
    model.pages.forEach((elements) {
      gridViewPages.add(GridView.builder(
          padding: EdgeInsets.only(right: 16, left: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (context, index) => imageBuilder(elements[index]),
          itemCount: elements.length,
          physics: BouncingScrollPhysics()));
    });
    return gridViewPages;
  }

  Widget imageBuilder(String url) {
    return GestureDetector(
      onTap: () {
        Navigation.push(context, FullScreenImageViewer(imageUrl: url));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        color: Color(COLOR_PRIMARY),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: user.profilePictureURL == DEFAULT_AVATAR_URL ? '' : url,
            placeholder: (context, imageUrl) {
              return Icon(
                Icons.hourglass_empty,
                size: 75,
                color: DisplayUtils.isDarkMode ? Colors.black : Colors.white,
              );
            },
            errorWidget: (context, imageUrl, error) {
              return Icon(
                Icons.error_outline,
                size: 75,
                color: DisplayUtils.isDarkMode ? Colors.black : Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildImage(int index) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: user.profilePictureURL == DEFAULT_AVATAR_URL
          ? ''
          : model.images[index]!,
      placeholder: (context, imageUrl) {
        return Icon(
          Icons.hourglass_empty,
          size: 75,
          color: DisplayUtils.isDarkMode ? Colors.black : Colors.white,
        );
      },
      errorWidget: (context, imageUrl, error) {
        return Icon(
          Icons.error_outline,
          size: 75,
          color: DisplayUtils.isDarkMode ? Colors.black : Colors.white,
        );
      },
    );
  }
}
