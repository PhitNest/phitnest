import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:location/location_utils.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../models/models.dart';
import '../../screens/screen_utils.dart';
import '../../screens/screens.dart';
import '../services.dart';

class FirebaseModel extends BackEndModel {
  final Reference _storage = FirebaseStorage.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  List<Swipe> _matchedUsersList = [];
  late final StreamController<List<HomeConversationModel>> _conversationsStream;
  final List<HomeConversationModel> _homeConversations = [];
  List<BlockUserModel> _blockedList = [];
  final List<UserModel> _matches = [];
  late StreamController<List<UserModel>> _membersStreamController;
  late StreamController<UserModel> _userStreamController;
  late StreamController<List<String>> _membersIDsStreamController;
  late StreamController<bool> _refreshStreamController;
  late StreamController<ChatModel> _chatModelStreamController;

  /// This is a token stream for firebase messaging. It is updated with calls to
  /// [updateLifeCycleState]
  late final StreamSubscription<String> _tokenStream;
  FirebaseModel() : super() {
    // When the token stream receives an event, update the users firebase
    // messaging token stored in firestore.
    _tokenStream = _firebaseMessaging.onTokenRefresh.listen((token) {
      UserModel? user = currentUser;
      if (user != null) {
        user.fcmToken = token;
        updateCurrentUser(user: user);
      }
    });
  }

  @override
  Future<void> updateUserDetails(BuildContext context, String mobile,
      String email, Future<void> Function() onUpdate) async {
    AuthProviders? authProvider;

    List<UserInfo> userInfoList =
        FirebaseAuth.instance.currentUser?.providerData ?? [];
    await Future.forEach(userInfoList, (UserInfo info) {
      if (info.providerId == 'password') {
        authProvider = AuthProviders.PASSWORD;
      } else if (info.providerId == 'phone') {
        authProvider = AuthProviders.PHONE;
      }
    });
    bool? result = false;
    if (authProvider == AuthProviders.PHONE &&
        FirebaseAuth.instance.currentUser!.phoneNumber != mobile) {
      result = await showDialog(
        context: context,
        builder: (context) => ReAuthUserScreen(
          user: currentUser!,
          provider: authProvider!,
          phoneNumber: mobile,
          deleteUser: false,
        ),
      );
      if (result != null && result) {
        await DialogUtils.showProgress(context, 'Saving details...', true);
        await onUpdate();
        await DialogUtils.hideProgress();
      }
    } else if (authProvider == AuthProviders.PASSWORD &&
        FirebaseAuth.instance.currentUser!.email != email) {
      result = await showDialog(
        context: context,
        builder: (context) => ReAuthUserScreen(
          user: currentUser!,
          provider: authProvider!,
          email: email,
          deleteUser: false,
        ),
      );
      if (result != null && result) {
        await DialogUtils.showProgress(context, 'Saving details...', true);
        await onUpdate();
        await DialogUtils.hideProgress();
      }
    } else {
      await DialogUtils.showProgress(context, 'Saving details...', true);
      await onUpdate();
      await DialogUtils.hideProgress();
    }
  }

  /// When the app's life cycle updates, pause/resume the token stream and set
  /// the activity boolean for the user.
  @override
  void updateLifeCycleState(AppLifecycleState state) {
    UserModel? user = currentUser;
    if (_firebaseAuth.currentUser != null && user != null) {
      if (state == AppLifecycleState.paused) {
        //user offline
        _tokenStream.pause();
        user.active = false;
        user.lastOnlineTimestamp = Timestamp.now();
        updateCurrentUser(user: user);
      } else if (state == AppLifecycleState.resumed) {
        //user online
        _tokenStream.resume();
        user.active = true;
        updateCurrentUser(user: user);
      }
    }
  }

  @override
  Future<void> updateCurrentUser({UserModel? user}) async {
    if (user == null) {
      User? firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        // Load user model from firestore document
        DocumentSnapshot<Map<String, dynamic>> userDocument =
            await _firestore.collection(USERS).doc(firebaseUser.uid).get();
        if (userDocument.exists) {
          user = UserModel.fromJson(userDocument.data() ?? {});
        }
        _firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      }
    }

    if (user != null) {
      await super.updateCurrentUser(user: user);
      await _firestore.collection(USERS).doc(user.userID).set(user.toJson());
    }
  }

  @override
  Future<void> updateSubscription() async {
    UserModel? user = currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userPurchase =
          await _firestore.collection(SUBSCRIPTIONS).doc(user.userID).get();
      if (userPurchase.exists) {
        try {
          PurchaseModel purchaseModel =
              PurchaseModel.fromJson(userPurchase.data() ?? {});
          DateTime purchaseDate = DateTime.fromMillisecondsSinceEpoch(
              purchaseModel.transactionDate);
          DateTime endOfSubscription = DateTime.now();
          if (purchaseModel.productId == MONTHLY_SUBSCRIPTION) {
            endOfSubscription = purchaseDate.add(Duration(days: 30));
          } else if (purchaseModel.productId == YEARLY_SUBSCRIPTION) {
            endOfSubscription = purchaseDate.add(Duration(days: 365));
          }
          if (DateTime.now().isAfter(endOfSubscription)) {
            user.isVip = false;
            await updateCurrentUser(user: user);
            await _firestore
                .collection(SUBSCRIPTIONS)
                .doc(user.userID)
                .delete();
          }
        } catch (e, s) {
          print('FireStoreUtils.isSubscriptionActive parse error $e $s');
        }
      }
    }
  }

  @override
  Future<String?> loginWithFacebook() async {
    AccessToken? token = await _facebookAuth.accessToken;
    if (token == null) {
      LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.success) {
        token = await _facebookAuth.accessToken;
      }
    }
    if (token != null) {
      UserCredential authResult = await _firebaseAuth
          .signInWithCredential(FacebookAuthProvider.credential(token.token));
      updateCurrentUser();
      UserModel? user = currentUser;
      Map<String, dynamic> userData = await _facebookAuth.getUserData();

      List<String> fullName = (userData['name'] as String).split(' ');
      String firstName = '';
      String lastName = '';
      if (fullName.isNotEmpty) {
        firstName = fullName.first;
        lastName = fullName.skip(1).join(' ');
      }
      if (user != null) {
        user.profilePictureURL = userData['picture']['data']['url'];
        user.firstName = firstName;
        user.lastName = lastName;
        user.email = userData['email'];
        user.fcmToken = await _firebaseMessaging.getToken() ?? '';
        await updateCurrentUser(user: user);
        return null;
      } else {
        user = UserModel(
            email: userData['email'] ?? '',
            firstName: firstName,
            profilePictureURL: userData['picture']['data']['url'] ?? '',
            userID: authResult.user?.uid ?? '',
            lastOnlineTimestamp: Timestamp.now(),
            lastName: lastName,
            fcmToken: await _firebaseMessaging.getToken() ?? '',
            active: false,
            phoneNumber: '',
            photos: [],
            settings: UserSettings());
        return await _firebaseCreateNewUser(user);
      }
    } else {
      return "Failed";
    }
  }

  @override
  Future<String?> loginWithApple() async {
    final appleCredential = await apple.TheAppleSignIn.performRequests([
      apple.AppleIdRequest(
          requestedScopes: [apple.Scope.email, apple.Scope.fullName])
    ]);
    if (appleCredential.error != null) {
      return 'Couldn\'t login with apple.';
    }
    if (appleCredential.status == apple.AuthorizationStatus.authorized) {
      final AuthCredential credential = OAuthProvider('apple.com').credential(
        accessToken: String.fromCharCodes(
            appleCredential.credential?.authorizationCode ?? []),
        idToken: String.fromCharCodes(
            appleCredential.credential?.identityToken ?? []),
      );
      UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);
      updateCurrentUser();
      UserModel? user = currentUser;
      if (user != null) {
        user.active = true;
        user.fcmToken = await _firebaseMessaging.getToken() ?? '';
        await updateCurrentUser(user: user);
        return null;
      } else {
        apple.AppleIdCredential appleIdCredential = appleCredential.credential!;
        user = UserModel(
            email: appleIdCredential.email ?? '',
            firstName: appleIdCredential.fullName?.givenName ?? 'Deleted',
            profilePictureURL: '',
            userID: authResult.user?.uid ?? '',
            lastOnlineTimestamp: Timestamp.now(),
            lastName: appleIdCredential.fullName?.familyName ?? 'UserModel',
            active: true,
            fcmToken: await _firebaseMessaging.getToken() ?? '',
            phoneNumber: '',
            photos: [],
            settings: UserSettings());
        return await _firebaseCreateNewUser(user);
      }
    } else {
      return 'Couldn\'t login with apple.';
    }
  }

  @override
  Future<String?> loginWithEmail(
      String email, String password, Position currentLocation) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection(USERS).doc(result.user?.uid ?? '').get();
      UserModel? user;
      if (documentSnapshot.exists) {
        user = UserModel.fromJson(documentSnapshot.data() ?? {});
        user.location = UserLocation(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude);
        user.fcmToken = await _firebaseMessaging.getToken() ?? '';
        await updateCurrentUser(user: user);
        return null;
      }
      return 'No such account';
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
      switch ((exception).code) {
        case 'invalid-email':
          return 'Email address is malformed.';
        case 'wrong-password':
          return 'Wrong password.';
        case 'user-not-found':
          return 'No user corresponding to the given email address.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts to sign in as this user.';
      }
      return 'Unexpected firebase error, Please try again.';
    } catch (e, s) {
      print(e.toString() + '$s');
      return 'Login failed, Please try again.';
    }
  }

  ///submit a phone number to firebase to receive a code verification, will
  ///be used later to login
  @override
  Future<String?> firebaseSubmitPhoneNumber(
      String firstName,
      String lastName,
      Position signupLocation,
      String phoneNumber,
      PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout,
      PhoneCodeSent phoneCodeSent,
      PhoneVerificationFailed phoneVerificationFailed,
      void Function() onLogin) async {
    String? errorMessage;
    _firebaseAuth.verifyPhoneNumber(
      timeout: Duration(minutes: 2),
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        updateCurrentUser();
        UserModel? user = currentUser;
        if (user != null) {
          await updateCurrentUser(user: user);
          DialogUtils.hideProgress();
          onLogin();
        } else {
          /// create a new user from phone login
          user = UserModel(
              firstName: firstName,
              lastName: lastName,
              fcmToken: await _firebaseMessaging.getToken() ?? '',
              phoneNumber: phoneNumber,
              active: true,
              lastOnlineTimestamp: Timestamp.now(),
              photos: [],
              settings: UserSettings(),
              location: UserLocation(
                  latitude: signupLocation.latitude,
                  longitude: signupLocation.longitude),
              signUpLocation: UserLocation(
                  latitude: signupLocation.latitude,
                  longitude: signupLocation.longitude),
              email: '',
              profilePictureURL: '',
              userID: userCredential.user?.uid ?? '');
          errorMessage = await _firebaseCreateNewUser(user);
          DialogUtils.hideProgress();
        }
      },
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
    );
    return errorMessage;
  }

  /// submit the received code to firebase to complete the phone number
  /// verification process
  @override
  Future<String?> loginWithPhoneNumber(String verificationID, String code,
      String phoneNumber, Position signUpLocation,
      {String firstName = 'Anonymous',
      String lastName = 'UserModel',
      File? image}) async {
    AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: code);
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(authCredential);
    updateCurrentUser();
    UserModel? user = currentUser;
    if (user != null) {
      return null;
    } else {
      /// create a new user from phone login
      String profileImageUrl = '';
      if (image != null) {
        profileImageUrl = await uploadUserImageToFireStorage(
            image, userCredential.user?.uid ?? '');
      }
      UserModel user = UserModel(
        firstName: firstName,
        lastName: lastName,
        fcmToken: await _firebaseMessaging.getToken() ?? '',
        phoneNumber: phoneNumber,
        profilePictureURL: profileImageUrl,
        userID: userCredential.user?.uid ?? '',
        active: false,
        age: '',
        bio: '',
        isVip: false,
        lastOnlineTimestamp: Timestamp.now(),
        photos: [],
        school: '',
        settings: UserSettings(),
        showMe: true,
        location: UserLocation(
            latitude: signUpLocation.latitude,
            longitude: signUpLocation.longitude),
        signUpLocation: UserLocation(
            latitude: signUpLocation.latitude,
            longitude: signUpLocation.longitude),
        email: '',
      );
      return await _firebaseCreateNewUser(user);
    }
  }

  Future<String?> _firebaseCreateNewUser(UserModel user) async {
    try {
      await _firestore.collection(USERS).doc(user.userID).set(user.toJson());
      currentUser = user;
      return null;
    } catch (e, s) {
      print('FireStoreUtils.firebaseCreateNewUser $e $s');
      return 'Couldn\'t sign up';
    }
  }

  @override
  Future<String?> firebaseSignUpWithEmailAndPassword(
      String emailAddress,
      String password,
      File? image,
      String firstName,
      String lastName,
      Position locationData,
      String mobile) async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: emailAddress, password: password);
      String profilePicUrl = '';
      if (image != null) {
        DialogUtils.updateProgress('Uploading image, Please wait...');
        profilePicUrl =
            await uploadUserImageToFireStorage(image, result.user?.uid ?? '');
      }
      UserModel user = UserModel(
          email: emailAddress,
          signUpLocation: UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude),
          location: UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude),
          showMe: true,
          settings: UserSettings(),
          school: '',
          photos: [],
          lastOnlineTimestamp: Timestamp.now(),
          isVip: false,
          bio: '',
          age: '',
          active: false,
          phoneNumber: mobile,
          firstName: firstName,
          userID: result.user?.uid ?? '',
          lastName: lastName,
          fcmToken: await _firebaseMessaging.getToken() ?? '',
          profilePictureURL: profilePicUrl);
      return await _firebaseCreateNewUser(user);
    } on FirebaseAuthException catch (error) {
      print(error.toString() + '${error.stackTrace}');
      String message = 'Couldn\'t sign up';
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email already in use, Please pick another email!';
          break;
        case 'invalid-email':
          message = 'Enter valid e-mail';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'Password must be more than 5 characters';
          break;
        case 'too-many-requests':
          message = 'Too many requests, Please try again later.';
          break;
      }
      return message;
    } catch (e) {
      return 'Couldn\'t sign up';
    }
  }

  /// this method is used to upload the user image to _firestore
  /// @param image file to be uploaded to _firestore
  /// @param userID the userID used as part of the image name on _firestore
  /// @return the full download url used to view the image
  @override
  Future<String> uploadUserImageToFireStorage(File image, String userID) async {
    File compressedImage = await _compressImage(image);
    Reference upload = _storage.child('images/$userID.png');
    UploadTask uploadTask = upload.putFile(compressedImage);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  @override
  Future<ConversationModel?> getChannelByIdOrNull(String channelID) async {
    ConversationModel? conversationModel;
    await _firestore.collection(CHANNELS).doc(channelID).get().then((channel) {
      if (channel.exists) {
        conversationModel = ConversationModel.fromJson(channel.data() ?? {});
      }
    }, onError: (e) {
      print((e as PlatformException).message);
    });
    return conversationModel;
  }

  @override
  Future<List<UserModel>> getMatchedUserObject() async {
    List<String> friendIDs = [];
    _matchedUsersList.clear();
    _matchedUsersList = await getMatches();
    _matchedUsersList.forEach((matchedUser) {
      friendIDs.add(matchedUser.user2);
    });
    _matches.clear();
    for (String id in friendIDs) {
      await _firestore.collection(USERS).doc(id).get().then((user) {
        _matches.add(UserModel.fromJson(user.data() ?? {}));
      });
    }
    return _matches;
  }

  @override
  Future<void> updateChannel(ConversationModel conversationModel) async {
    await _firestore
        .collection(CHANNELS)
        .doc(conversationModel.id)
        .update(conversationModel.toJson());
  }

  /// compress video file to make it load faster but with lower quality,
  /// change the quality parameter to control the quality of the video after
  /// being compressed
  /// @param file the video file that will be compressed
  /// @return File a new compressed file with smaller size
  static Future<File> _compressVideo(File file) async {
    MediaInfo? info = await VideoCompress.compressVideo(file.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
        includeAudio: true,
        frameRate: 24);
    if (info != null) {
      File compressedVideo = File(info.path!);
      return compressedVideo;
    } else {
      return file;
    }
  }

  @override
  Future<ChatVideoContainer> uploadChatVideoToFireStorage(
      File video, BuildContext context) async {
    DialogUtils.showProgress(context, 'Uploading video...', false);
    var uniqueID = Uuid().v4();
    File compressedVideo = await _compressVideo(video);
    Reference upload = _storage.child('videos/$uniqueID.mp4');
    SettableMetadata metadata = SettableMetadata(contentType: 'video');
    UploadTask uploadTask = upload.putFile(compressedVideo, metadata);
    uploadTask.snapshotEvents.listen((event) {
      DialogUtils.updateProgress(
          'Uploading video ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
          '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
          'KB');
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    final uint8list = await VideoThumbnail.thumbnailFile(
        video: downloadUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG);
    final file = File(uint8list!);
    String thumbnailDownloadUrl = await uploadVideoThumbnailToFireStorage(file);
    DialogUtils.hideProgress();
    return ChatVideoContainer(
        videoUrl: Url(
            url: downloadUrl.toString(), mime: metaData.contentType ?? 'video'),
        thumbnailUrl: thumbnailDownloadUrl);
  }

  @override
  Future<void> sendMessage(List<UserModel> members, bool isGroup,
      MessageData message, ConversationModel conversationModel) async {
    var ref = _firestore
        .collection(CHANNELS)
        .doc(conversationModel.id)
        .collection(THREAD)
        .doc();
    message.messageID = ref.id;
    await ref.set(message.toJson());
    List<UserModel> payloadFriends;
    if (isGroup) {
      payloadFriends = [];
      payloadFriends.addAll(members);
    } else {
      payloadFriends = [currentUser!];
    }

    await Future.forEach(members, (UserModel element) async {
      if (element.userID != currentUser!.userID) {
        if (element.settings.pushNewMessages) {
          UserModel? friend;
          if (isGroup) {
            friend = payloadFriends
                .firstWhere((user) => user.fcmToken == element.fcmToken);
            payloadFriends.remove(friend);
            payloadFriends.add(currentUser!);
          }
          Map<String, dynamic> payload = <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'conversationModel': conversationModel.toPayload(),
            'isGroup': isGroup,
            'members': payloadFriends.map((e) => e.toPayload()).toList()
          };

          await NotificationUtils.sendNotification(
              element.fcmToken,
              isGroup ? conversationModel.name : currentUser!.fullName(),
              message.content,
              payload);
          if (isGroup) {
            payloadFriends.remove(currentUser);
            payloadFriends.add(friend!);
          }
        }
      }
    });
  }

  @override
  Future<Url> uploadAudioFile(File file, BuildContext context) async {
    DialogUtils.showProgress(context, 'Uploading Audio...', false);
    var uniqueID = Uuid().v4();
    Reference upload = _storage.child('audio/$uniqueID.mp3');
    SettableMetadata metadata = SettableMetadata(contentType: 'audio');
    UploadTask uploadTask = upload.putFile(file, metadata);
    uploadTask.snapshotEvents.listen((event) {
      DialogUtils.updateProgress(
          'Uploading Audio ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
          '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
          'KB');
    });
    uploadTask.whenComplete(() {}).catchError((onError) {
      print((onError as PlatformException).message);
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    DialogUtils.hideProgress();
    return Url(
        mime: metaData.contentType ?? 'audio', url: downloadUrl.toString());
  }

  @override
  Future<bool> createConversation(ConversationModel conversation) async {
    UserModel? user = currentUser;
    if (user != null) {
      bool isSuccessful = false;
      await _firestore
          .collection(CHANNELS)
          .doc(conversation.id)
          .set(conversation.toJson())
          .then((onValue) async {
        ChannelParticipation myChannelParticipation =
            ChannelParticipation(user: user.userID, channel: conversation.id);
        ChannelParticipation myFriendParticipation = ChannelParticipation(
            user: conversation.id.replaceAll(user.userID, ''),
            channel: conversation.id);
        await createChannelParticipation(myChannelParticipation);
        await createChannelParticipation(myFriendParticipation);
        isSuccessful = true;
      }, onError: (e) {
        print((e as PlatformException).message);
        isSuccessful = false;
      });
      return isSuccessful;
    }
    return false;
  }

  Stream<List<String>> getGroupMembersIDs(
      UserModel user, String channelID) async* {
    _membersIDsStreamController = StreamController();
    _firestore
        .collection(CHANNEL_PARTICIPATION)
        .where('channel', isEqualTo: channelID)
        .snapshots()
        .listen((participations) {
      List<String> uids = [];
      for (DocumentSnapshot<Map<String, dynamic>> document
          in participations.docs) {
        uids.add(document.data()?['user'] ?? '');
      }
      if (uids.contains(user.userID)) {
        _membersIDsStreamController.sink.add(uids);
      } else {
        _membersIDsStreamController.sink.add([]);
      }
    });
    yield* _membersIDsStreamController.stream;
  }

  Stream<List<UserModel>> getGroupMembers(
      UserModel user, String channelID) async* {
    _membersStreamController = StreamController();
    getGroupMembersIDs(user, channelID).listen((memberIDs) {
      if (memberIDs.isNotEmpty) {
        List<UserModel> groupMembers = [];
        for (String id in memberIDs) {
          getUserByID(id).listen((user) {
            groupMembers.add(user);
            _membersStreamController.sink.add(groupMembers);
          });
        }
      } else {
        _membersStreamController.sink.add([]);
      }
    });
    yield* _membersStreamController.stream;
  }

  Future<String> uploadVideoThumbnailToFireStorage(File file) async {
    var uniqueID = Uuid().v4();
    File compressedImage = await _compressImage(file);
    Reference upload = _storage.child('thumbnails/$uniqueID.png');
    UploadTask uploadTask = upload.putFile(compressedImage);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  @override
  Future<bool> leaveGroup(ConversationModel conversationModel) async {
    bool isSuccessful = false;
    conversationModel.lastMessage = '${currentUser!.fullName()} '
        'left';
    conversationModel.lastMessageDate = Timestamp.now();
    await updateChannel(conversationModel).then((_) async {
      await _firestore
          .collection(CHANNEL_PARTICIPATION)
          .where('channel', isEqualTo: conversationModel.id)
          .where('user', isEqualTo: currentUser!.userID)
          .get()
          .then((onValue) async {
        await _firestore
            .collection(CHANNEL_PARTICIPATION)
            .doc(onValue.docs.first.id)
            .delete()
            .then((onValue) {
          isSuccessful = true;
        });
      });
    });
    return isSuccessful;
  }

  @override
  Stream<ChatModel> getChatMessages(
      HomeConversationModel homeConversationModel) async* {
    _chatModelStreamController = StreamController();
    ChatModel chatModel = ChatModel();
    List<MessageData> listOfMessages = [];
    List<UserModel> listOfMembers = homeConversationModel.members;
    if (homeConversationModel.isGroupChat) {
      homeConversationModel.members.forEach((groupMember) {
        if (groupMember.userID != currentUser!.userID) {
          getUserByID(groupMember.userID).listen((updatedUser) {
            for (int i = 0; i < listOfMembers.length; i++) {
              if (listOfMembers[i].userID == updatedUser.userID) {
                listOfMembers[i] = updatedUser;
              }
            }
            chatModel.message = listOfMessages;
            chatModel.members = listOfMembers;
            _chatModelStreamController.sink.add(chatModel);
          });
        }
      });
    } else {
      UserModel friend = homeConversationModel.members.first;
      getUserByID(friend.userID).listen((user) {
        listOfMembers.clear();
        listOfMembers.add(user);
        chatModel.message = listOfMessages;
        chatModel.members = listOfMembers;
        _chatModelStreamController.sink.add(chatModel);
      });
    }
    if (homeConversationModel.conversationModel != null) {
      _firestore
          .collection(CHANNELS)
          .doc(homeConversationModel.conversationModel!.id)
          .collection(THREAD)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((onData) {
        listOfMessages.clear();
        onData.docs.forEach((document) {
          listOfMessages.add(MessageData.fromJson(document.data()));
        });
        chatModel.message = listOfMessages;
        chatModel.members = listOfMembers;
        _chatModelStreamController.sink.add(chatModel);
      });
    }
    yield* _chatModelStreamController.stream;
  }

  @override
  Future<List<Swipe>> getMatches() async {
    List<Swipe> matchList = <Swipe>[];
    await _firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: currentUser!.userID)
        .where('hasBeenSeen', isEqualTo: true)
        .get()
        .then((querySnapShot) {
      querySnapShot.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        if (match.id.isEmpty) {
          match.id = doc.id;
        }
        matchList.add(match);
      });
    });
    return matchList.toSet().toList();
  }

  @override
  Stream<List<HomeConversationModel>> getConversations() async* {
    UserModel? user = currentUser;
    if (user != null) {
      _conversationsStream = StreamController<List<HomeConversationModel>>();
      HomeConversationModel newHomeConversation;

      _firestore
          .collection(CHANNEL_PARTICIPATION)
          .where('user', isEqualTo: user.userID)
          .snapshots()
          .listen((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          _conversationsStream.sink.add(_homeConversations);
        } else {
          _homeConversations.clear();
          Future.forEach(querySnapshot.docs,
              (DocumentSnapshot<Map<String, dynamic>> document) {
            if (document.exists) {
              ChannelParticipation participation =
                  ChannelParticipation.fromJson(document.data() ?? {});
              _firestore
                  .collection(CHANNELS)
                  .doc(participation.channel)
                  .snapshots()
                  .listen((channel) async {
                if (channel.exists) {
                  bool isGroupChat = !channel.id.contains(user.userID);
                  List<UserModel> users = [];
                  if (isGroupChat) {
                    getGroupMembers(user, channel.id).listen((listOfUsers) {
                      if (listOfUsers.isNotEmpty) {
                        users = listOfUsers;
                        newHomeConversation = HomeConversationModel(
                            conversationModel: ConversationModel.fromJson(
                                channel.data() ?? {}),
                            isGroupChat: isGroupChat,
                            members: users);

                        if (newHomeConversation.conversationModel!.id.isEmpty)
                          newHomeConversation.conversationModel!.id =
                              channel.id;

                        _homeConversations
                            .removeWhere((conversationModelToDelete) {
                          return newHomeConversation.conversationModel!.id ==
                              conversationModelToDelete.conversationModel!.id;
                        });
                        _homeConversations.add(newHomeConversation);
                        _homeConversations.sort((a, b) => a
                            .conversationModel!.lastMessageDate
                            .compareTo(b.conversationModel!.lastMessageDate));
                        _conversationsStream.sink
                            .add(_homeConversations.reversed.toList());
                      }
                    });
                  } else {
                    getUserByID(channel.id.replaceAll(user.userID, ''))
                        .listen((user) {
                      users.clear();
                      users.add(user);
                      newHomeConversation = HomeConversationModel(
                          conversationModel:
                              ConversationModel.fromJson(channel.data() ?? {}),
                          isGroupChat: isGroupChat,
                          members: users);

                      if (newHomeConversation.conversationModel!.id.isEmpty)
                        newHomeConversation.conversationModel!.id = channel.id;

                      _homeConversations
                          .removeWhere((conversationModelToDelete) {
                        return newHomeConversation.conversationModel!.id ==
                            conversationModelToDelete.conversationModel!.id;
                      });

                      _homeConversations.add(newHomeConversation);
                      _homeConversations.sort((a, b) => a
                          .conversationModel!.lastMessageDate
                          .compareTo(b.conversationModel!.lastMessageDate));
                      _conversationsStream.sink
                          .add(_homeConversations.reversed.toList());
                    });
                  }
                }
              });
            }
          });
        }
      });
      yield* _conversationsStream.stream;
    }
  }

  @override
  Stream<bool> getBlocks() async* {
    _refreshStreamController = StreamController();
    _firestore
        .collection(REPORTS)
        .where('source', isEqualTo: currentUser!.userID)
        .snapshots()
        .listen((onData) {
      List<BlockUserModel> list = [];
      for (DocumentSnapshot<Map<String, dynamic>> block in onData.docs) {
        list.add(BlockUserModel.fromJson(block.data() ?? {}));
      }
      _blockedList = list;

      if (_homeConversations.isNotEmpty || _matches.isNotEmpty) {
        _refreshStreamController.sink.add(true);
      }
    });
    yield* _refreshStreamController.stream;
  }

  Stream<UserModel> getUserByID(String id) async* {
    _userStreamController = StreamController();
    _firestore.collection(USERS).doc(id).snapshots().listen((user) {
      _userStreamController.sink.add(UserModel.fromJson(user.data() ?? {}));
    });
    yield* _userStreamController.stream;
  }

  @override
  bool validateIfUserBlocked(String userID) {
    for (BlockUserModel blockedUser in _blockedList) {
      if (userID == blockedUser.dest) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<Url> uploadChatImageToFireStorage(
      File image, BuildContext context) async {
    DialogUtils.showProgress(context, 'Uploading image...', false);
    var uniqueID = Uuid().v4();
    File compressedImage = await _compressImage(image);
    Reference upload = _storage.child('images/$uniqueID.png');
    UploadTask uploadTask = upload.putFile(compressedImage);
    uploadTask.snapshotEvents.listen((event) {
      DialogUtils.updateProgress(
          'Uploading image ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
          '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
          'KB');
    });
    uploadTask.whenComplete(() {}).catchError((onError) {
      print((onError as PlatformException).message);
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    DialogUtils.hideProgress();
    return Url(
        mime: metaData.contentType ?? 'image', url: downloadUrl.toString());
  }

  /// compress image file to make it load faster but with lower quality,
  /// change the quality parameter to control the quality of the image after
  /// being compressed(100 = max quality - 0 = low quality)
  /// @param file the image file that will be compressed
  /// @return File a new compressed file with smaller size
  Future<File> _compressImage(File file) async {
    File compressedImage = await FlutterNativeImage.compressImage(
      file.path,
      quality: 25,
    );
    return compressedImage;
  }

  Stream<List<UserModel>> getTinderUsers(
      StreamController<List<UserModel>> tinderCardsStreamController) async* {
    List<UserModel> tinderUsers = [];
    Position? locationData = await LocationUtils.getCurrentLocation();
    UserModel? user = currentUser;
    if (user != null) {
      if (locationData != null) {
        user.location = UserLocation(
            latitude: locationData.latitude, longitude: locationData.longitude);
        await _firestore
            .collection(USERS)
            .where('showMe', isEqualTo: true)
            .get()
            .then((value) async {
          value.docs.forEach(
              (DocumentSnapshot<Map<String, dynamic>> tinderUser) async {
            try {
              if (tinderUser.id != user.userID) {
                UserModel other = UserModel.fromJson(tinderUser.data() ?? {});
                double distance = LocationUtils.getDistance(
                    user.location.latitude,
                    user.location.longitude,
                    other.location.latitude,
                    other.location.longitude);
                if (await isValidUserForTinderSwipe(other, distance)) {
                  other.milesAway = '$distance Miles Away';
                  tinderUsers.insert(0, other);
                  tinderCardsStreamController.add(tinderUsers);
                }
                if (tinderUsers.isEmpty) {
                  tinderCardsStreamController.add(tinderUsers);
                }
              } else if (value.docs.length == 1) {
                tinderCardsStreamController.add(tinderUsers);
              }
            } catch (e) {
              print(
                  'FireStoreUtils.getTinderUsers failed to parse user object $e');
            }
          });
        }, onError: (e) {
          print('${(e as PlatformException).message}');
        });
      }
      yield* tinderCardsStreamController.stream;
    }
  }

  updateHasBeenSeen(Map<String, dynamic> target) async {
    target['hasBeenSeen'] = true;
    await _firestore.collection(SWIPES).doc(target['id'] ?? '').update(target);
  }

  @override
  Future<bool> isValidUserForTinderSwipe(
      UserModel tinderUser, double distance) async {
    UserModel? user = currentUser;
    if (user != null) {
      //make sure that we haven't swiped this user before
      QuerySnapshot result1 = await _firestore
          .collection(SWIPES)
          .where('user1', isEqualTo: user.userID)
          .where('user2', isEqualTo: tinderUser.userID)
          .get()
          .catchError((onError) {
        print('${(onError as PlatformException).message}');
      });

      return result1.docs.isEmpty &&
          isPreferredGender(tinderUser.settings.gender) &&
          LocationUtils.isInPreferredDistance(
              user.settings.distanceRadius, distance);
    }
    return false;
  }

  bool isPreferredGender(String gender) {
    if (currentUser!.settings.genderPreference != 'All') {
      return gender == currentUser!.settings.genderPreference;
    } else {
      return true;
    }
  }

  @override
  Future<void> onSwipeLeft(UserModel dislikedUser) async {
    UserModel? user = currentUser;
    if (user != null) {
      DocumentReference documentReference = _firestore.collection(SWIPES).doc();
      Swipe leftSwipe = Swipe(
          id: documentReference.id,
          type: 'dislike',
          user1: user.userID,
          user2: dislikedUser.userID,
          createdAt: Timestamp.now(),
          hasBeenSeen: false);
      await documentReference.set(leftSwipe.toJson());
    }
  }

  @override
  Future<UserModel?> onSwipeRight(UserModel other) async {
    // check if this user sent a match request before ? if yes, it's a match,
    // if not, send him match request
    UserModel? user = currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection(SWIPES)
          .where('user1', isEqualTo: other.userID)
          .where('user2', isEqualTo: user.userID)
          .where('type', isEqualTo: 'like')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        //this user sent me a match request, let's talk
        DocumentReference document = _firestore.collection(SWIPES).doc();
        var swipe = Swipe(
            id: document.id,
            type: 'like',
            hasBeenSeen: true,
            createdAt: Timestamp.now(),
            user1: user.userID,
            user2: other.userID);
        await document.set(swipe.toJson());
        if (other.settings.pushNewMatchesEnabled) {
          await NotificationUtils.sendNotification(
              other.fcmToken,
              'New match',
              'You have got a new '
                  'match: ${user.fullName()}.',
              null);
        }

        return other;
      } else {
        //this user didn't send me a match request, let's send match request
        // and keep swiping
        await sendSwipeRequest(other);
        return null;
      }
    }
    return null;
  }

  Future<bool> sendSwipeRequest(UserModel user) async {
    bool isSuccessful = false;
    DocumentReference documentReference = _firestore.collection(SWIPES).doc();
    Swipe swipe = Swipe(
        id: documentReference.id,
        user1: currentUser!.userID,
        user2: user.userID,
        hasBeenSeen: false,
        createdAt: Timestamp.now(),
        type: 'like');
    await documentReference.set(swipe.toJson()).then((onValue) {
      isSuccessful = true;
    }, onError: (e) {
      isSuccessful = false;
    });
    return isSuccessful;
  }

  Future<bool> _shouldResetCounter(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) async {
    SwipeCounter counter = SwipeCounter.fromJson(documentSnapshot.data() ?? {});
    DateTime now = DateTime.now();
    DateTime from = DateTime.fromMillisecondsSinceEpoch(
        counter.createdAt.millisecondsSinceEpoch);
    Duration diff = now.difference(from);
    if (diff.inDays > 0) {
      counter.count = 1;
      counter.createdAt = Timestamp.now();
      await _firestore
          .collection(SWIPE_COUNT)
          .doc(counter.authorID)
          .update(counter.toJson());
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> resetPassword(String emailAddress) async =>
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);

  @override
  Future<UserCredential?> reAuthUser(AuthProviders provider,
      {String? email,
      String? password,
      String? smsCode,
      String? verificationId,
      dynamic accessToken,
      dynamic appleCredential}) async {
    late AuthCredential credential;
    switch (provider) {
      case AuthProviders.PASSWORD:
        credential =
            EmailAuthProvider.credential(email: email!, password: password!);
        break;
      case AuthProviders.PHONE:
        credential = PhoneAuthProvider.credential(
            smsCode: smsCode!, verificationId: verificationId!);
        break;
      case AuthProviders.FACEBOOK:
        credential = FacebookAuthProvider.credential(accessToken!.token);
        break;
      case AuthProviders.APPLE:
        credential = OAuthProvider('apple.com').credential(
          accessToken: String.fromCharCodes(
              appleCredential!.credential?.authorizationCode ?? []),
          idToken: String.fromCharCodes(
              appleCredential.credential?.identityToken ?? []),
        );
        break;
    }
    return await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential);
  }

  @override
  Future<void> undo(UserModel tinderUser) async {
    await _firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: currentUser!.userID)
        .where('user2', isEqualTo: tinderUser.userID)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await _firestore.collection(SWIPES).doc(value.docs.first.id).delete();
      }
    });
  }

  @override
  Future<bool> incrementSwipe() async {
    UserModel? user = currentUser;
    if (user != null) {
      DocumentReference<Map<String, dynamic>> documentReference =
          _firestore.collection(SWIPE_COUNT).doc(user.userID);
      DocumentSnapshot<Map<String, dynamic>> validationDocumentSnapshot =
          await documentReference.get();
      if (validationDocumentSnapshot.exists) {
        if ((validationDocumentSnapshot['count'] ?? 1) < 10) {
          await _firestore
              .doc(documentReference.path)
              .update({'count': validationDocumentSnapshot['count'] + 1});
          return true;
        } else {
          return _shouldResetCounter(validationDocumentSnapshot);
        }
      } else {
        await _firestore.doc(documentReference.path).set(SwipeCounter(
                authorID: user.userID, createdAt: Timestamp.now(), count: 1)
            .toJson());
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> blockUser(UserModel blockedUser, String type) async {
    UserModel? user = currentUser;
    if (user != null) {
      bool isSuccessful = false;
      BlockUserModel blockUserModel = BlockUserModel(
          type: type,
          source: user.userID,
          dest: blockedUser.userID,
          createdAt: Timestamp.now());
      await _firestore
          .collection(REPORTS)
          .add(blockUserModel.toJson())
          .then((onValue) {
        isSuccessful = true;
      });
      return isSuccessful;
    } else {
      return false;
    }
  }

  @override
  Future<void> matchChecker(
      BuildContext context, void Function(UserModel user) onMatch) async {
    UserModel? user = currentUser;
    if (user != null) {
      String myID = user.userID;
      QuerySnapshot<Map<String, dynamic>> result = await _firestore
          .collection(SWIPES)
          .where('user2', isEqualTo: myID)
          .where('type', isEqualTo: 'like')
          .get();
      if (result.docs.isNotEmpty) {
        await Future.forEach(result.docs,
            (DocumentSnapshot<Map<String, dynamic>> document) async {
          try {
            Swipe match = Swipe.fromJson(document.data() ?? {});
            QuerySnapshot<Map<String, dynamic>> unSeenMatches = await _firestore
                .collection(SWIPES)
                .where('user1', isEqualTo: myID)
                .where('type', isEqualTo: 'like')
                .where('user2', isEqualTo: match.user1)
                .where('hasBeenSeen', isEqualTo: false)
                .get();
            if (unSeenMatches.docs.isNotEmpty) {
              unSeenMatches.docs.forEach(
                  (DocumentSnapshot<Map<String, dynamic>> unSeenMatch) async {
                DocumentSnapshot<Map<String, dynamic>> matchedUserDocSnapshot =
                    await _firestore.collection(USERS).doc(match.user1).get();
                UserModel matchedUser =
                    UserModel.fromJson(matchedUserDocSnapshot.data() ?? {});
                onMatch(matchedUser);
                updateHasBeenSeen(unSeenMatch.data() ?? {});
              });
            }
          } catch (e) {
            print('FireStoreUtils.matchChecker failed to parse object '
                '$e');
          }
        });
      }
    }
  }

  Future<void> createChannelParticipation(
      ChannelParticipation channelParticipation) async {
    await _firestore
        .collection(CHANNEL_PARTICIPATION)
        .add(channelParticipation.toJson());
  }

  @override
  Future<void> recordPurchase(PurchaseDetails purchase) async {
    UserModel? user = currentUser;
    if (user != null) {
      PurchaseModel purchaseModel = PurchaseModel(
        active: true,
        productId: purchase.productID,
        receipt: purchase.purchaseID ?? '',
        serverVerificationData:
            purchase.verificationData.serverVerificationData,
        source: purchase.verificationData.source,
        subscriptionPeriod:
            purchase.purchaseID == MONTHLY_SUBSCRIPTION ? 'monthly' : 'yearly',
        transactionDate: int.parse(purchase.transactionDate!),
        userID: user.userID,
      );
      await _firestore
          .collection(SUBSCRIPTIONS)
          .doc(user.userID)
          .set(purchaseModel.toJson());
      user.isVip = true;
      await updateCurrentUser(user: user);
    }
  }

  @override
  Future<void> deleteProfilePicture() async {
    var fileUrl = Uri.decodeFull(Path.basename(currentUser!.profilePictureURL))
        .replaceAll(RegExp(r'(\?alt).*'), '');

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }

  Future<void> deleteUser() async {
    UserModel? user = currentUser;
    if (user != null) {
      try {
        // delete user records from subscriptions table
        await _firestore.collection(SUBSCRIPTIONS).doc(user.userID).delete();

        // delete user records from swipe_counts table
        await _firestore.collection(SWIPE_COUNT).doc(user.userID).delete();

        // delete user records from swipes table
        await _firestore
            .collection(SWIPES)
            .where('user1', isEqualTo: user.userID)
            .get()
            .then((value) async {
          for (var doc in value.docs) {
            await _firestore.doc(doc.reference.path).delete();
          }
        });
        await _firestore
            .collection(SWIPES)
            .where('user2', isEqualTo: user.userID)
            .get()
            .then((value) async {
          for (var doc in value.docs) {
            await _firestore.doc(doc.reference.path).delete();
          }
        });

        // delete user records from CHANNEL_PARTICIPATION table
        await _firestore
            .collection(CHANNEL_PARTICIPATION)
            .where('user', isEqualTo: user.userID)
            .get()
            .then((value) async {
          for (var doc in value.docs) {
            await _firestore.doc(doc.reference.path).delete();
          }
        });

        // delete user records from REPORTS table
        await _firestore
            .collection(REPORTS)
            .where('source', isEqualTo: user.userID)
            .get()
            .then((value) async {
          for (var doc in value.docs) {
            await _firestore.doc(doc.reference.path).delete();
          }
        });

        // delete user records from REPORTS table
        await _firestore
            .collection(REPORTS)
            .where('dest', isEqualTo: user.userID)
            .get()
            .then((value) async {
          for (var doc in value.docs) {
            await _firestore.doc(doc.reference.path).delete();
          }
        });

        // delete user records from users table
        await _firestore
            .collection(USERS)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .delete();

        // delete user  from firebase auth
        await _firestore.terminate();
        await FirebaseAuth.instance.currentUser!.delete();
      } catch (e, s) {
        print('FireStoreUtils.deleteUser $e $s');
      }
    }
  }

  @override
  void dispose() async {
    if (currentUser != null) {
      currentUser!.active = false;
      await updateCurrentUser(user: currentUser!);
    }
    _userStreamController.close();
    _refreshStreamController.close();
    _membersIDsStreamController.close();
    _chatModelStreamController.close();
    _membersStreamController.close();
    _conversationsStream.close();
    super.dispose();
  }
}
