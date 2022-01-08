import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/MessageData.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/accountDetails/AccountDetailsScreen.dart';
import 'package:dating/ui/auth/AuthScreen.dart';
import 'package:dating/ui/contactUs/ContactUsScreen.dart';
import 'package:dating/ui/fullScreenImageViewer/FullScreenImageViewer.dart';
import 'package:dating/ui/reauthScreen/reauth_user_screen.dart';
import 'package:dating/ui/settings/SettingsScreen.dart';
import 'package:dating/ui/upgradeAccount/UpgradeAccount.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  late User user;
  FireStoreUtils _fireStoreUtils = FireStoreUtils();
  List images = [];
  List _pages = [];
  List<Widget> _gridPages = [];
  PageController controller = PageController();

  @override
  void initState() {
    user = widget.user;
    images.clear();
    images.addAll(user.photos);
    if (images.isNotEmpty) {
      if (images[images.length - 1] != null) {
        images.add(null);
      }
    } else {
      images.add(null);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _gridPages = _buildGridView();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 32, right: 32),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Center(
                    child:
                        displayCircleImage(user.profilePictureURL, 130, false)),
                Positioned(
                  left: 80,
                  right: 0,
                  child: FloatingActionButton(
                      heroTag: 'pickImage',
                      backgroundColor: Color(COLOR_ACCENT),
                      child: Icon(
                        Icons.camera_alt,
                        color:
                            isDarkMode(context) ? Colors.black : Colors.white,
                      ),
                      mini: true,
                      onPressed: _onCameraClick),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 32, left: 32),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                user.fullName(),
                style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : Colors.black,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Photos'.tr(),
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (_pages.length >= 2)
                    SmoothPageIndicator(
                      controller: controller,
                      count: _pages.length,
                      effect: ScrollingDotsEffect(
                        activeDotColor: Color(COLOR_ACCENT),
                        dotColor: Colors.grey,
                      ),
                    ),
                ]),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: SizedBox(
              height: user.photos.length > 3 ? 260 : 130,
              width: double.infinity,
              child: PageView(
                children: _gridPages,
                controller: controller,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                dense: true,
                onTap: () {
                  push(context, AccountDetailsScreen(user: user));
                },
                title: Text(
                  'Account Details'.tr(),
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
              ListTile(
                dense: true,
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return UpgradeAccount();
                    },
                  );
                },
                title: Text(
                  user.isVip
                      ? 'Cancel subscription'.tr()
                      : 'Upgrade Account'.tr(),
                  style: TextStyle(fontSize: 16),
                ),
                leading: Image.asset(
                  'assets/images/vip.png',
                  height: 24,
                  width: 24,
                ),
              ),
              ListTile(
                dense: true,
                onTap: () {
                  push(context, SettingsScreen(user: user));
                },
                title: Text(
                  'Settings'.tr(),
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(
                  Icons.settings,
                  color: isDarkMode(context) ? Colors.white70 : Colors.black45,
                ),
              ),
              ListTile(
                dense: true,
                onTap: () {
                  push(context, ContactUsScreen());
                },
                title: Text(
                  'Contact Us'.tr(),
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(
                  Icons.call,
                  color: Colors.green,
                ),
              ),
              ListTile(
                dense: true,
                onTap: () async {
                  AuthProviders? authProvider;
                  List<auth.UserInfo> userInfoList =
                      auth.FirebaseAuth.instance.currentUser?.providerData ??
                          [];
                  await Future.forEach(userInfoList, (auth.UserInfo info) {
                    switch (info.providerId) {
                      case 'password':
                        authProvider = AuthProviders.PASSWORD;
                        break;
                      case 'phone':
                        authProvider = AuthProviders.PHONE;
                        break;
                      case 'facebook.com':
                        authProvider = AuthProviders.FACEBOOK;
                        break;
                      case 'apple.com':
                        authProvider = AuthProviders.APPLE;
                        break;
                    }
                  });
                  bool? result = await showDialog(
                    context: context,
                    builder: (context) => ReAuthUserScreen(
                      provider: authProvider!,
                      email: auth.FirebaseAuth.instance.currentUser!.email,
                      phoneNumber:
                          auth.FirebaseAuth.instance.currentUser!.phoneNumber,
                      deleteUser: true,
                    ),
                  );
                  if (result != null && result) {
                    await showProgress(
                        context, 'Deleting account...'.tr(), false);
                    await FireStoreUtils.deleteUser();
                    await hideProgress();
                    MyAppState.currentUser = null;
                    pushAndRemoveUntil(context, AuthScreen(), false);
                  }
                },
                title: Text(
                  'Delete Account'.tr(),
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(
                  CupertinoIcons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.transparent,
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Text(
                  'Logout'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode(context) ? Colors.white : Colors.black,
                  ),
                ),
                onPressed: () async {
                  user.active = false;
                  user.lastOnlineTimestamp = Timestamp.now();
                  await FireStoreUtils.updateCurrentUser(user);
                  await auth.FirebaseAuth.instance.signOut();
                  MyAppState.currentUser = null;
                  pushAndRemoveUntil(context, AuthScreen(), false);
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'Add profile picture'.tr(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Remove Picture'.tr()),
          isDestructiveAction: true,
          onPressed: () async {
            Navigator.pop(context);
            showProgress(context, 'Removing picture...'.tr(), false);
            if (user.profilePictureURL.isNotEmpty)
              await _fireStoreUtils.deleteImage(user.profilePictureURL);
            user.profilePictureURL = '';
            await FireStoreUtils.updateCurrentUser(user);
            MyAppState.currentUser = user;
            hideProgress();
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Choose from gallery'.tr()),
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              await _imagePicked(File(image.path));
            }
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Take a picture'.tr()),
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.camera);
            if (image != null) {
              await _imagePicked(File(image.path));
            }
            setState(() {});
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Future<void> _imagePicked(File image) async {
    showProgress(context, 'Uploading image...'.tr(), false);
    user.profilePictureURL =
        await FireStoreUtils.uploadUserImageToFireStorage(image, user.userID);
    await FireStoreUtils.updateCurrentUser(user);
    MyAppState.currentUser = user;
    hideProgress();
  }

  Widget _imageBuilder(String? url) {
    bool isLastItem = url == null;

    return GestureDetector(
      onTap: () {
        isLastItem ? _pickImage() : _viewOrDeleteImage(url);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        color: Color(COLOR_PRIMARY),
        child: isLastItem
            ? Icon(
                Icons.camera_alt,
                size: 50,
                color: isDarkMode(context) ? Colors.black : Colors.white,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                      user.profilePictureURL == DEFAULT_AVATAR_URL ? '' : url,
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
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) => _imageBuilder(elements[index]),
          itemCount: elements.length,
          physics: BouncingScrollPhysics()));
    });
    return gridViewPages;
  }

  _viewOrDeleteImage(String url) {
    final action = CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.pop(context);
            images.removeLast();
            images.remove(url);
            await _fireStoreUtils.deleteImage(url);
            user.photos = images;
            User? newUser = await FireStoreUtils.updateCurrentUser(user);
            MyAppState.currentUser = newUser;
            if (newUser != null) {
              user = newUser;
              images.add(null);
              setState(() {});
            }
          },
          child: Text('Remove Picture'.tr()),
          isDestructiveAction: true,
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            push(context, FullScreenImageViewer(imageUrl: url));
          },
          isDefaultAction: true,
          child: Text('View Picture'.tr()),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.pop(context);
            user.profilePictureURL = url;
            dynamic result = await FireStoreUtils.updateCurrentUser(user);
            if (result != null) {
              user = result;
            }
            setState(() {});
          },
          isDefaultAction: true,
          child: Text('Make Profile Picture'.tr()),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _pickImage() {
    final action = CupertinoActionSheet(
      message: Text(
        'Add picture'.tr(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Choose from gallery'.tr()),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              Url imageUrl = await _fireStoreUtils.uploadChatImageToFireStorage(
                  File(image.path), context);
              images.removeLast();
              images.add(imageUrl.url);
              user.photos = images;
              User? newUser = await FireStoreUtils.updateCurrentUser(user);
              if (newUser != null) {
                MyAppState.currentUser = newUser;
                user = newUser;
              }
              images.add(null);
              setState(() {});
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Take a picture'.tr()),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.camera);
            if (image != null) {
              Url imageUrl = await _fireStoreUtils.uploadChatImageToFireStorage(
                  File(image.path), context);
              images.removeLast();
              images.add(imageUrl.url);
              user.photos = images;
              User? newUser = await FireStoreUtils.updateCurrentUser(user);
              if (newUser != null) {
                MyAppState.currentUser = newUser;
                user = newUser;
              }
              images.add(null);
              setState(() {});
            }
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
