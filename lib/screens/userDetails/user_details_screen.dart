import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phitnest/screens/userDetails/provider/user_details_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../screen_utils.dart';

class UserDetailsScreen extends StatelessWidget {
  final bool isMatch;
  final UserModel viewingUser;

  const UserDetailsScreen(
      {Key? key, required this.viewingUser, required this.isMatch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserDetailsProvider(
        viewingUser: viewingUser,
        builder: ((context, model, functions, child) {
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
                                  functions.buildImage(index),
                              itemCount: model.images.length,
                              controller: model.controller,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            child: SmoothPageIndicator(
                              controller: model.controller, // PageController
                              count: model.images.length,
                              effect: SlideEffect(
                                  spacing: 4.0,
                                  radius: 4.0,
                                  dotWidth: (MediaQuery.of(context).size.width /
                                          model.images.length) -
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
                            '${viewingUser.fullName()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 27),
                          ),
                          Text(
                            viewingUser.age.isEmpty || viewingUser.age == 'N/A'
                                ? ''
                                : '  ${viewingUser.age}',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.school),
                          Text('   ${viewingUser.school}')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.location_on),
                          Text('   ${viewingUser.milesAway}')
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8),
                      child: Text(
                        viewingUser.bio.isEmpty || viewingUser.bio == 'N/A'
                            ? ''
                            : '  ${viewingUser.bio}',
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Photos'.tr(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          if (model.pages.length >= 2)
                            SmoothPageIndicator(
                              controller: model.gridPageViewController,
                              // PageController
                              count: model.pages.length,
                              effect: JumpingDotEffect(
                                  spacing: 4.0,
                                  radius: 4.0,
                                  dotWidth: 8,
                                  dotHeight: 8.0,
                                  paintStyle: PaintingStyle.fill,
                                  dotColor: Colors.grey,
                                  activeDotColor: Color(
                                      COLOR_PRIMARY)), // your preferred effect
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: SizedBox(
                          height: viewingUser.photos.length > 3 ? 260 : 130,
                          width: double.infinity,
                          child: PageView(
                            controller: model.gridPageViewController,
                            children: model.gridPages,
                          )),
                    ),
                    Visibility(
                      visible: !isMatch,
                      child: Container(
                        height: 110,
                      ),
                    )
                  ],
                ),
              ),
              bottomSheet: Visibility(
                visible: !isMatch,
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
        }));
  }
}
