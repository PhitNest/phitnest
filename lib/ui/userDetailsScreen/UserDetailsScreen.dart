import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/CustomFlutterTinderCard.dart';
import 'package:dating/constants.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/fullScreenImageViewer/FullScreenImageViewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserDetailsScreen extends StatefulWidget {
  final User user;
  final bool isMatch;

  const UserDetailsScreen({Key? key, required this.user, required this.isMatch})
      : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late User user;
  List<String?> images = [];
  List _pages = [];
  PageController controller = PageController(
    initialPage: 0,
  );
  PageController gridPageViewController = PageController(
    initialPage: 0,
  );
  List<Widget> _gridPages = [];

  @override
  void initState() {
    user = widget.user;
    images.add(user.profilePictureURL);
    images.addAll(user.photos.cast<String>());
    images.removeWhere((element) => element == null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: isDarkMode(context) ? Colors.black : Colors.white));
    _gridPages = _buildGridView();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * .6,
                      child: PageView.builder(
                        itemBuilder: (BuildContext context, int index) =>
                            _buildImage(index),
                        itemCount: images.length,
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      child: SmoothPageIndicator(
                        controller: controller, // PageController
                        count: images.length,
                        effect: SlideEffect(
                            spacing: 4.0,
                            radius: 4.0,
                            dotWidth: (MediaQuery.of(context).size.width /
                                    images.length) -
                                4,
                            dotHeight: 4.0,
                            paintStyle: PaintingStyle.fill,
                            dotColor: Colors.grey,
                            activeDotColor:
                                Colors.white), // your preferred effect
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: -28,
                      child: FloatingActionButton(
                          mini: false,
                          child: Icon(
                            Icons.arrow_downward,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    )
                  ]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${user.fullName()}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                    ),
                    Text(
                      user.age.isEmpty || user.age == 'N/A'
                          ? ''
                          : '  ${user.age}',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.school),
                    Text('   ${user.school}')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.location_on),
                    Text('   ${user.milesAway}')
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8),
                child: Text(
                  user.bio.isEmpty || user.bio == 'N/A' ? '' : '  ${user.bio}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Photos'.tr(),
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    if (_pages.length >= 2)
                      SmoothPageIndicator(
                        controller: gridPageViewController,
                        // PageController
                        count: _pages.length,
                        effect: JumpingDotEffect(
                            spacing: 4.0,
                            radius: 4.0,
                            dotWidth: 8,
                            dotHeight: 8.0,
                            paintStyle: PaintingStyle.fill,
                            dotColor: Colors.grey,
                            activeDotColor:
                                Color(COLOR_PRIMARY)), // your preferred effect
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: SizedBox(
                    height: user.photos.length > 3 ? 260 : 130,
                    width: double.infinity,
                    child: PageView(
                      controller: gridPageViewController,
                      children: _gridPages,
                    )),
              ),
              Visibility(
                visible: !widget.isMatch,
                child: Container(
                  height: 110,
                ),
              )
            ],
          ),
        ),
        bottomSheet: Visibility(
          visible: !widget.isMatch,
          child: Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    elevation: 4,
                    heroTag: 'left'.tr(),
                    onPressed: () {
                      Navigator.pop(context, CardSwipeOrientation.LEFT);
                    },
                    backgroundColor: Colors.white,
                    mini: false,
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  FloatingActionButton(
                    elevation: 4,
                    heroTag: 'center'.tr(),
                    onPressed: () {
                      Navigator.pop(context, CardSwipeOrientation.RIGHT);
                    },
                    backgroundColor: Colors.white,
                    mini: true,
                    child: Icon(
                      Icons.star,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  FloatingActionButton(
                    elevation: 4,
                    heroTag: 'right'.tr(),
                    onPressed: () {
                      Navigator.pop(context, CardSwipeOrientation.RIGHT);
                    },
                    backgroundColor: Colors.white,
                    mini: false,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.green,
                      size: 40,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGridView() {
    _pages.clear();
    List<Widget> gridViewPages = [];
    var len = images.length;
    var size = 6;
    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      _pages.add(images.sublist(i, end));
    }
    _pages.forEach((elements) {
      gridViewPages.add(GridView.builder(
          padding: EdgeInsets.only(right: 16, left: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (context, index) => _imageBuilder(elements[index]),
          itemCount: elements.length,
          physics: BouncingScrollPhysics()));
    });
    return gridViewPages;
  }

  Widget _imageBuilder(String url) {
    return GestureDetector(
      onTap: () {
        push(context, FullScreenImageViewer(imageUrl: url));
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
                color: isDarkMode(context) ? Colors.black : Colors.white,
              );
            },
            errorWidget: (context, imageUrl, error) {
              return Icon(
                Icons.error_outline,
                size: 75,
                color: isDarkMode(context) ? Colors.black : Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImage(int index) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl:
          user.profilePictureURL == DEFAULT_AVATAR_URL ? '' : images[index]!,
      placeholder: (context, imageUrl) {
        return Icon(
          Icons.hourglass_empty,
          size: 75,
          color: isDarkMode(context) ? Colors.black : Colors.white,
        );
      },
      errorWidget: (context, imageUrl, error) {
        return Icon(
          Icons.error_outline,
          size: 75,
          color: isDarkMode(context) ? Colors.black : Colors.white,
        );
      },
    );
  }

  @override
  void dispose() {
    gridPageViewController.dispose();
    controller.dispose();
    super.dispose();
  }
}
