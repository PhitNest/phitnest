// ignore_for_file: close_sinks

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:phitnest/constants/constants.dart';
import 'package:phitnest/helpers/helpers.dart';
import 'package:phitnest/models/models.dart';
import 'package:phitnest/screens/screens.dart';

class FirebaseUtils {
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();
  static List<Swipe> matchedUsersList = [];
  static late StreamController<List<HomeConversationModel>> conversationsStream;
  static List<HomeConversationModel> homeConversations = [];
  static List<BlockUserModel> blockedList = [];
  static List<UserModel> matches = [];
  static late StreamController<List<UserModel>> tinderCardsStreamController;

  static Future<UserModel?> loadUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await _firestore.collection(USERS).doc(uid).get();
    if (userDocument.exists) {
      return UserModel.fromJson(userDocument.data() ?? {});
    } else {
      return null;
    }
  }

  /// Updates the firebase document for [user] in the collection [USERS]
  /// Returns null on error.
  static Future<bool> updateCurrentUser(UserModel user) async {
    return await _firestore
        .collection(USERS)
        .doc(user.userID)
        .set(user.toJson())
        .then((document) {
      return true;
    }, onError: (e) {
      return false;
    });
  }

  static Future<Url> uploadChatImageToFireStorage(
      File image, BuildContext context) async {
    DialogUtils.showProgress(context, 'Uploading image...'.tr(), false);
    var uniqueID = Uuid().v4();
    File compressedImage = await compressImage(image);
    Reference upload = storage.child('images/$uniqueID.png');
    UploadTask uploadTask = upload.putFile(compressedImage);
    uploadTask.snapshotEvents.listen((event) {
      DialogUtils.updateProgress(
          'Uploading image ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
                  '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
                  'KB'
              .tr());
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

  static Future<ChatVideoContainer> uploadChatVideoToFireStorage(
      File video, BuildContext context) async {
    DialogUtils.showProgress(context, 'Uploading video...'.tr(), false);
    var uniqueID = Uuid().v4();
    File compressedVideo = await _compressVideo(video);
    Reference upload = storage.child('videos/$uniqueID.mp4');
    SettableMetadata metadata = SettableMetadata(contentType: 'video');
    UploadTask uploadTask = upload.putFile(compressedVideo, metadata);
    uploadTask.snapshotEvents.listen((event) {
      DialogUtils.updateProgress(
          'Uploading video ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
                  '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
                  'KB'
              .tr());
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

  static Future<String> uploadVideoThumbnailToFireStorage(File file) async {
    var uniqueID = Uuid().v4();
    File compressedImage = await compressImage(file);
    Reference upload = storage.child('thumbnails/$uniqueID.png');
    UploadTask uploadTask = upload.putFile(compressedImage);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<List<Swipe>> getMatches(String userID) async {
    List<Swipe> matchList = <Swipe>[];
    await _firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: userID)
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

  static Future<bool> removeMatch(String id) async {
    bool isSuccessful = false;
    await _firestore.collection(SWIPES).doc(id).delete().then((onValue) {
      isSuccessful = true;
    }, onError: (e) {
      print('${e.toString()}');
      isSuccessful = false;
    });
    return isSuccessful;
  }

  static Future<List<UserModel>> getMatchedUserObject(String userID) async {
    List<String> friendIDs = [];
    matchedUsersList.clear();
    matchedUsersList = await getMatches(userID);
    matchedUsersList.forEach((matchedUser) {
      friendIDs.add(matchedUser.user2);
    });
    matches.clear();
    for (String id in friendIDs) {
      await _firestore.collection(USERS).doc(id).get().then((user) {
        matches.add(UserModel.fromJson(user.data() ?? {}));
      });
    }
    return matches;
  }

  static Stream<List<HomeConversationModel>> getConversations(
      UserModel user, String userID) async* {
    conversationsStream = StreamController<List<HomeConversationModel>>();
    HomeConversationModel newHomeConversation;

    _firestore
        .collection(CHANNEL_PARTICIPATION)
        .where('user', isEqualTo: userID)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        conversationsStream.sink.add(homeConversations);
      } else {
        homeConversations.clear();
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
                bool isGroupChat = !channel.id.contains(userID);
                List<UserModel> users = [];
                if (isGroupChat) {
                  FirebaseUtils.getGroupMembers(user, channel.id)
                      .listen((listOfUsers) {
                    if (listOfUsers.isNotEmpty) {
                      users = listOfUsers;
                      newHomeConversation = HomeConversationModel(
                          conversationModel:
                              ConversationModel.fromJson(channel.data() ?? {}),
                          isGroupChat: isGroupChat,
                          members: users);

                      if (newHomeConversation.conversationModel!.id.isEmpty)
                        newHomeConversation.conversationModel!.id = channel.id;

                      homeConversations
                          .removeWhere((conversationModelToDelete) {
                        return newHomeConversation.conversationModel!.id ==
                            conversationModelToDelete.conversationModel!.id;
                      });
                      homeConversations.add(newHomeConversation);
                      homeConversations.sort((a, b) => a
                          .conversationModel!.lastMessageDate
                          .compareTo(b.conversationModel!.lastMessageDate));
                      conversationsStream.sink
                          .add(homeConversations.reversed.toList());
                    }
                  });
                } else {
                  FirebaseUtils.getUserByID(channel.id.replaceAll(userID, ''))
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

                    homeConversations.removeWhere((conversationModelToDelete) {
                      return newHomeConversation.conversationModel!.id ==
                          conversationModelToDelete.conversationModel!.id;
                    });

                    homeConversations.add(newHomeConversation);
                    homeConversations.sort((a, b) => a
                        .conversationModel!.lastMessageDate
                        .compareTo(b.conversationModel!.lastMessageDate));
                    conversationsStream.sink
                        .add(homeConversations.reversed.toList());
                  });
                }
              }
            });
          }
        });
      }
    });
    yield* conversationsStream.stream;
  }

  static Stream<List<UserModel>> getGroupMembers(
      UserModel user, String channelID) async* {
    StreamController<List<UserModel>> membersStreamController =
        StreamController();
    FirebaseUtils.getGroupMembersIDs(user, channelID).listen((memberIDs) {
      if (memberIDs.isNotEmpty) {
        List<UserModel> groupMembers = [];
        for (String id in memberIDs) {
          FirebaseUtils.getUserByID(id).listen((user) {
            groupMembers.add(user);
            membersStreamController.sink.add(groupMembers);
          });
        }
      } else {
        membersStreamController.sink.add([]);
      }
    });
    yield* membersStreamController.stream;
  }

  static Stream<List<String>> getGroupMembersIDs(
      UserModel user, String channelID) async* {
    StreamController<List<String>> membersIDsStreamController =
        StreamController();
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
        membersIDsStreamController.sink.add(uids);
      } else {
        membersIDsStreamController.sink.add([]);
      }
    });
    yield* membersIDsStreamController.stream;
  }

  static Stream<UserModel> getUserByID(String id) async* {
    StreamController<UserModel> userStreamController = StreamController();
    _firestore.collection(USERS).doc(id).snapshots().listen((user) {
      userStreamController.sink.add(UserModel.fromJson(user.data() ?? {}));
    });
    yield* userStreamController.stream;
  }

  static Future<ConversationModel?> getChannelByIdOrNull(
      String channelID) async {
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

  static Stream<ChatModel> getChatMessages(
      UserModel user, HomeConversationModel homeConversationModel) async* {
    StreamController<ChatModel> chatModelStreamController = StreamController();
    ChatModel chatModel = ChatModel();
    List<MessageData> listOfMessages = [];
    List<UserModel> listOfMembers = homeConversationModel.members;
    if (homeConversationModel.isGroupChat) {
      homeConversationModel.members.forEach((groupMember) {
        if (groupMember.userID != user.userID) {
          getUserByID(groupMember.userID).listen((updatedUser) {
            for (int i = 0; i < listOfMembers.length; i++) {
              if (listOfMembers[i].userID == updatedUser.userID) {
                listOfMembers[i] = updatedUser;
              }
            }
            chatModel.message = listOfMessages;
            chatModel.members = listOfMembers;
            chatModelStreamController.sink.add(chatModel);
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
        chatModelStreamController.sink.add(chatModel);
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
        chatModelStreamController.sink.add(chatModel);
      });
    }
    yield* chatModelStreamController.stream;
  }

  static Future<void> sendMessage(
      UserModel user,
      List<UserModel> members,
      bool isGroup,
      MessageData message,
      ConversationModel conversationModel) async {
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
      payloadFriends = [user];
    }

    await Future.forEach(members, (UserModel element) async {
      if (element.userID != user.userID) {
        if (element.settings.pushNewMessages) {
          UserModel? friend;
          if (isGroup) {
            friend = payloadFriends
                .firstWhere((user) => user.fcmToken == element.fcmToken);
            payloadFriends.remove(friend);
            payloadFriends.add(user);
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
              isGroup ? conversationModel.name : user.fullName(),
              message.content,
              payload);
          if (isGroup) {
            payloadFriends.remove(user);
            payloadFriends.add(friend!);
          }
        }
      }
    });
  }

  static Future<bool> createConversation(
      UserModel user, ConversationModel conversation) async {
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
      await FirebaseUtils.createChannelParticipation(myChannelParticipation);
      await FirebaseUtils.createChannelParticipation(myFriendParticipation);
      isSuccessful = true;
    }, onError: (e) {
      print((e as PlatformException).message);
      isSuccessful = false;
    });
    return isSuccessful;
  }

  static Future<void> updateChannel(ConversationModel conversationModel) async {
    await _firestore
        .collection(CHANNELS)
        .doc(conversationModel.id)
        .update(conversationModel.toJson());
  }

  static Future<void> createChannelParticipation(
      ChannelParticipation channelParticipation) async {
    await _firestore
        .collection(CHANNEL_PARTICIPATION)
        .add(channelParticipation.toJson());
  }

  static Future<HomeConversationModel> createGroupChat(
      UserModel user, List<UserModel> selectedUsers, String groupName) async {
    late HomeConversationModel groupConversationModel;
    DocumentReference channelDoc = _firestore.collection(CHANNELS).doc();
    ConversationModel conversationModel = ConversationModel();
    conversationModel.id = channelDoc.id;
    conversationModel.creatorId = user.userID;
    conversationModel.name = groupName;
    conversationModel.lastMessage =
        '${user.fullName()} created this group'.tr();
    conversationModel.lastMessageDate = Timestamp.now();
    await channelDoc.set(conversationModel.toJson()).then((onValue) async {
      selectedUsers.add(user);
      for (UserModel user in selectedUsers) {
        ChannelParticipation channelParticipation = ChannelParticipation(
            channel: conversationModel.id, user: user.userID);
        await createChannelParticipation(channelParticipation);
      }
      groupConversationModel = HomeConversationModel(
          isGroupChat: true,
          members: selectedUsers,
          conversationModel: conversationModel);
    });
    return groupConversationModel;
  }

  static Future<bool> leaveGroup(
      UserModel user, ConversationModel conversationModel) async {
    bool isSuccessful = false;
    conversationModel.lastMessage = '${user.fullName()} '
            'left'
        .tr();
    conversationModel.lastMessageDate = Timestamp.now();
    await updateChannel(conversationModel).then((_) async {
      await _firestore
          .collection(CHANNEL_PARTICIPATION)
          .where('channel', isEqualTo: conversationModel.id)
          .where('user', isEqualTo: user.userID)
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

  static Future<bool> blockUser(
      UserModel user, UserModel blockedUser, String type) async {
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
  }

  static Stream<bool> getBlocks(UserModel user) async* {
    StreamController<bool> refreshStreamController = StreamController();
    _firestore
        .collection(REPORTS)
        .where('source', isEqualTo: user.userID)
        .snapshots()
        .listen((onData) {
      List<BlockUserModel> list = [];
      for (DocumentSnapshot<Map<String, dynamic>> block in onData.docs) {
        list.add(BlockUserModel.fromJson(block.data() ?? {}));
      }
      blockedList = list;

      if (homeConversations.isNotEmpty || matches.isNotEmpty) {
        refreshStreamController.sink.add(true);
      }
    });
    yield* refreshStreamController.stream;
  }

  static bool validateIfUserBlocked(String userID) {
    for (BlockUserModel blockedUser in blockedList) {
      if (userID == blockedUser.dest) {
        return true;
      }
    }
    return false;
  }

  static Stream<List<UserModel>> getTinderUsers(UserModel currentUser) async* {
    tinderCardsStreamController = StreamController<List<UserModel>>();
    List<UserModel> tinderUsers = [];
    Position? locationData = await LocationUtils.getCurrentLocation();
    if (locationData != null) {
      currentUser.location = UserLocation(
          latitude: locationData.latitude, longitude: locationData.longitude);
      await _firestore
          .collection(USERS)
          .where('showMe', isEqualTo: true)
          .get()
          .then((value) async {
        value.docs
            .forEach((DocumentSnapshot<Map<String, dynamic>> tinderUser) async {
          try {
            if (tinderUser.id != currentUser.userID) {
              UserModel user = UserModel.fromJson(tinderUser.data() ?? {});
              double distance = LocationUtils.getDistance(
                  currentUser.location, user.location);
              if (await FirebaseUtils._isValidUserForTinderSwipe(
                  currentUser, user, distance)) {
                user.milesAway = '$distance Miles Away'.tr();
                tinderUsers.insert(0, user);
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

  static bool isPreferredGender(UserModel user, String gender) {
    if (user.settings.genderPreference != 'All') {
      return gender == user.settings.genderPreference;
    } else {
      return true;
    }
  }

  static Future<bool> _isValidUserForTinderSwipe(
      UserModel user, UserModel tinderUser, double distance) async {
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
        FirebaseUtils.isPreferredGender(user, tinderUser.settings.gender) &&
        LocationUtils.isInPreferredDistance(user, distance);
  }

  static matchChecker(UserModel user, BuildContext context) async {
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
              NavigationUtils.push(
                  context,
                  MatchScreen(
                    user: user,
                    matchedUser: matchedUser,
                  ));
              FirebaseUtils.updateHasBeenSeen(unSeenMatch.data() ?? {});
            });
          }
        } catch (e) {
          print('FireStoreUtils.matchChecker failed to parse object '
              '$e');
        }
      });
    }
  }

  static onSwipeLeft(UserModel user, UserModel dislikedUser) async {
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

  static Future<UserModel?> onSwipeRight(
      UserModel currentUser, UserModel user) async {
    // check if this user sent a match request before ? if yes, it's a match,
    // if not, send him match request
    QuerySnapshot querySnapshot = await _firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: user.userID)
        .where('user2', isEqualTo: currentUser.userID)
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
          user1: currentUser.userID,
          user2: user.userID);
      await document.set(swipe.toJson());
      if (user.settings.pushNewMatchesEnabled) {
        await NotificationUtils.sendNotification(
            user.fcmToken,
            'New match',
            'You have got a new '
                'match: ${currentUser.fullName()}.',
            null);
      }

      return user;
    } else {
      //this user didn't send me a match request, let's send match request
      // and keep swiping
      await FirebaseUtils.sendSwipeRequest(user, currentUser.userID);
      return null;
    }
  }

  static Future<bool> sendSwipeRequest(UserModel user, String myID) async {
    bool isSuccessful = false;
    DocumentReference documentReference = _firestore.collection(SWIPES).doc();
    Swipe swipe = Swipe(
        id: documentReference.id,
        user1: myID,
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

  static updateHasBeenSeen(Map<String, dynamic> target) async {
    target['hasBeenSeen'] = true;
    await _firestore.collection(SWIPES).doc(target['id'] ?? '').update(target);
  }

  static Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }

  static undo(UserModel user, UserModel tinderUser) async {
    await _firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: user.userID)
        .where('user2', isEqualTo: tinderUser.userID)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await _firestore.collection(SWIPES).doc(value.docs.first.id).delete();
      }
    });
  }

  static closeTinderStream() {
    tinderCardsStreamController.close();
  }

  static void updateCardStream(List<UserModel> data) {
    tinderCardsStreamController.add(data);
  }

  static Future<bool> incrementSwipe(UserModel user) async {
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
        return FirebaseUtils._shouldResetCounter(validationDocumentSnapshot);
      }
    } else {
      await _firestore.doc(documentReference.path).set(SwipeCounter(
              authorID: user.userID, createdAt: Timestamp.now(), count: 1)
          .toJson());
      return true;
    }
  }

  static Future<Url> uploadAudioFile(File file, BuildContext context) async {
    DialogUtils.showProgress(context, 'Uploading Audio...'.tr(), false);
    var uniqueID = Uuid().v4();
    Reference upload = storage.child('audio/$uniqueID.mp3');
    SettableMetadata metadata = SettableMetadata(contentType: 'audio');
    UploadTask uploadTask = upload.putFile(file, metadata);
    uploadTask.snapshotEvents.listen((event) {
      DialogUtils.updateProgress(
          'Uploading Audio ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
                  '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
                  'KB'
              .tr());
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

  static Future<bool> _shouldResetCounter(
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

  static loginWithFacebook() async {
    /// creates a user for this facebook login when this user first time login
    /// and save the new user object to firebase and firebase auth
    FacebookAuth facebookAuth = FacebookAuth.instance;
    bool isLogged = await facebookAuth.accessToken != null;
    if (!isLogged) {
      LoginResult result = await facebookAuth
          .login(); // by default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        // you are logged
        AccessToken? token = await facebookAuth.accessToken;
        return await handleFacebookLogin(
            await facebookAuth.getUserData(), token!);
      }
    } else {
      AccessToken? token = await facebookAuth.accessToken;
      return await handleFacebookLogin(
          await facebookAuth.getUserData(), token!);
    }
  }

  static handleFacebookLogin(
      Map<String, dynamic> userData, AccessToken token) async {
    auth.UserCredential authResult = await auth.FirebaseAuth.instance
        .signInWithCredential(
            auth.FacebookAuthProvider.credential(token.token));
    UserModel? user = await loadUser(authResult.user?.uid ?? '');
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
      user.active = true;
      user.fcmToken = await _firebaseMessaging.getToken() ?? '';
      dynamic result = await updateCurrentUser(user);
      return result;
    } else {
      user = UserModel(
          email: userData['email'] ?? '',
          firstName: firstName,
          profilePictureURL: userData['picture']['data']['url'] ?? '',
          userID: authResult.user?.uid ?? '',
          lastOnlineTimestamp: Timestamp.now(),
          lastName: lastName,
          active: true,
          fcmToken: await _firebaseMessaging.getToken() ?? '',
          phoneNumber: '',
          photos: [],
          settings: UserSettings());
      String? errorMessage = await firebaseCreateNewUser(user);
      if (errorMessage == null) {
        return user;
      } else {
        return errorMessage;
      }
    }
  }

  static loginWithApple() async {
    final appleCredential = await apple.TheAppleSignIn.performRequests([
      apple.AppleIdRequest(
          requestedScopes: [apple.Scope.email, apple.Scope.fullName])
    ]);
    if (appleCredential.error != null) {
      return 'Couldn\'t login with apple.';
    }

    if (appleCredential.status == apple.AuthorizationStatus.authorized) {
      final auth.AuthCredential credential =
          auth.OAuthProvider('apple.com').credential(
        accessToken: String.fromCharCodes(
            appleCredential.credential?.authorizationCode ?? []),
        idToken: String.fromCharCodes(
            appleCredential.credential?.identityToken ?? []),
      );
      return await handleAppleLogin(credential, appleCredential.credential!);
    } else {
      return 'Couldn\'t login with apple.';
    }
  }

  static handleAppleLogin(
    auth.AuthCredential credential,
    apple.AppleIdCredential appleIdCredential,
  ) async {
    auth.UserCredential authResult =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);
    UserModel? user = await loadUser(authResult.user?.uid ?? '');
    if (user != null) {
      user.active = true;
      user.fcmToken = await _firebaseMessaging.getToken() ?? '';
      dynamic result = await updateCurrentUser(user);
      return result;
    } else {
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
      String? errorMessage = await firebaseCreateNewUser(user);
      if (errorMessage == null) {
        return user;
      } else {
        return errorMessage;
      }
    }
  }

  /// save a new user document in the USERS table in firebase _firestore
  /// returns an error message on failure or null on success
  static Future<String?> firebaseCreateNewUser(UserModel user) async {
    try {
      await _firestore.collection(USERS).doc(user.userID).set(user.toJson());
      return null;
    } catch (e, s) {
      print('FireStoreUtils.firebaseCreateNewUser $e $s');
      return 'Couldn\'t sign up'.tr();
    }
  }

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  static Future<dynamic> loginWithEmailAndPassword(
      String email, String password, Position currentLocation) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection(USERS).doc(result.user?.uid ?? '').get();
      UserModel? user;
      if (documentSnapshot.exists) {
        user = UserModel.fromJson(documentSnapshot.data() ?? {});
        user.location = UserLocation(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude);
        user.fcmToken = await _firebaseMessaging.getToken() ?? '';
        await updateCurrentUser(user);
      }
      return user;
    } on auth.FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
      switch ((exception).code) {
        case 'invalid-email':
          return 'Email address is malformed.'.tr();
        case 'wrong-password':
          return 'Wrong password.'.tr();
        case 'user-not-found':
          return 'No user corresponding to the given email address.'.tr();
        case 'user-disabled':
          return 'This user has been disabled.'.tr();
        case 'too-many-requests':
          return 'Too many attempts to sign in as this user.'.tr();
      }
      return 'Unexpected firebase error, Please try again.'.tr();
    } catch (e, s) {
      print(e.toString() + '$s');
      return 'Login failed, Please try again.'.tr();
    }
  }

  ///submit a phone number to firebase to receive a code verification, will
  ///be used later to login
  static firebaseSubmitPhoneNumber(
    String phoneNumber,
    auth.PhoneCodeAutoRetrievalTimeout? phoneCodeAutoRetrievalTimeout,
    auth.PhoneCodeSent? phoneCodeSent,
    auth.PhoneVerificationFailed? phoneVerificationFailed,
    auth.PhoneVerificationCompleted? phoneVerificationCompleted,
  ) {
    auth.FirebaseAuth.instance.verifyPhoneNumber(
      timeout: Duration(minutes: 2),
      phoneNumber: phoneNumber,
      verificationCompleted: phoneVerificationCompleted!,
      verificationFailed: phoneVerificationFailed!,
      codeSent: phoneCodeSent!,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout!,
    );
  }

  /// submit the received code to firebase to complete the phone number
  /// verification process
  static Future<dynamic> firebaseSubmitPhoneNumberCode(String verificationID,
      String code, String phoneNumber, Position signUpLocation,
      {String firstName = 'Anonymous',
      String lastName = 'UserModel',
      File? image}) async {
    auth.AuthCredential authCredential = auth.PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: code);
    auth.UserCredential userCredential =
        await auth.FirebaseAuth.instance.signInWithCredential(authCredential);
    UserModel? user = await loadUser(userCredential.user?.uid ?? '');
    if (user != null) {
      return user;
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
        active: true,
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
      String? errorMessage = await firebaseCreateNewUser(user);
      if (errorMessage == null) {
        return user;
      } else {
        return 'Couldn\'t create new user with phone number.'.tr();
      }
    }
  }

  /// this method is used to upload the user image to _firestore
  /// @param image file to be uploaded to _firestore
  /// @param userID the userID used as part of the image name on _firestore
  /// @return the full download url used to view the image
  static Future<String> uploadUserImageToFireStorage(
      File image, String userID) async {
    File compressedImage = await compressImage(image);
    Reference upload = storage.child('images/$userID.png');
    UploadTask uploadTask = upload.putFile(compressedImage);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  /// compress image file to make it load faster but with lower quality,
  /// change the quality parameter to control the quality of the image after
  /// being compressed(100 = max quality - 0 = low quality)
  /// @param file the image file that will be compressed
  /// @return File a new compressed file with smaller size
  static Future<File> compressImage(File file) async {
    File compressedImage = await FlutterNativeImage.compressImage(
      file.path,
      quality: 25,
    );
    return compressedImage;
  }

  static firebaseSignUpWithEmailAndPassword(
      String emailAddress,
      String password,
      File? image,
      String firstName,
      String lastName,
      Position locationData,
      String mobile) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password);
      String profilePicUrl = '';
      if (image != null) {
        DialogUtils.updateProgress('Uploading image, Please wait...'.tr());
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
          active: true,
          phoneNumber: mobile,
          firstName: firstName,
          userID: result.user?.uid ?? '',
          lastName: lastName,
          fcmToken: await _firebaseMessaging.getToken() ?? '',
          profilePictureURL: profilePicUrl);
      String? errorMessage = await firebaseCreateNewUser(user);
      if (errorMessage == null) {
        return user;
      } else {
        return 'Couldn\'t sign up for firebase, Please try again.'.tr();
      }
    } on auth.FirebaseAuthException catch (error) {
      print(error.toString() + '${error.stackTrace}');
      String message = 'Couldn\'t sign up'.tr();
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email already in use, Please pick another email!'.tr();
          break;
        case 'invalid-email':
          message = 'Enter valid e-mail'.tr();
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled'.tr();
          break;
        case 'weak-password':
          message = 'Password must be more than 5 characters'.tr();
          break;
        case 'too-many-requests':
          message = 'Too many requests, Please try again later.'.tr();
          break;
      }
      return message;
    } catch (e) {
      return 'Couldn\'t sign up'.tr();
    }
  }

  static Future<auth.UserCredential?> reAuthUser(AuthProviders provider,
      {String? email,
      String? password,
      String? smsCode,
      String? verificationId,
      AccessToken? accessToken,
      apple.AuthorizationResult? appleCredential}) async {
    late auth.AuthCredential credential;
    switch (provider) {
      case AuthProviders.PASSWORD:
        credential = auth.EmailAuthProvider.credential(
            email: email!, password: password!);
        break;
      case AuthProviders.PHONE:
        credential = auth.PhoneAuthProvider.credential(
            smsCode: smsCode!, verificationId: verificationId!);
        break;
      case AuthProviders.FACEBOOK:
        credential = auth.FacebookAuthProvider.credential(accessToken!.token);
        break;
      case AuthProviders.APPLE:
        credential = auth.OAuthProvider('apple.com').credential(
          accessToken: String.fromCharCodes(
              appleCredential!.credential?.authorizationCode ?? []),
          idToken: String.fromCharCodes(
              appleCredential.credential?.identityToken ?? []),
        );
        break;
    }
    return await auth.FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential);
  }

  static resetPassword(String emailAddress) async =>
      await auth.FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailAddress);

  static deleteUser(UserModel user) async {
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
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .delete();

      // delete user  from firebase auth
      await auth.FirebaseAuth.instance.currentUser!.delete();
    } catch (e, s) {
      print('FireStoreUtils.deleteUser $e $s');
    }
  }

  static recordPurchase(UserModel user, PurchaseDetails purchase) async {
    PurchaseModel purchaseModel = PurchaseModel(
      active: true,
      productId: purchase.productID,
      receipt: purchase.purchaseID ?? '',
      serverVerificationData: purchase.verificationData.serverVerificationData,
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
    await updateCurrentUser(user);
  }

  static isSubscriptionActive(UserModel user) async {
    DocumentSnapshot<Map<String, dynamic>> userPurchase =
        await _firestore.collection(SUBSCRIPTIONS).doc(user.userID).get();
    if (userPurchase.exists) {
      try {
        PurchaseModel purchaseModel =
            PurchaseModel.fromJson(userPurchase.data() ?? {});
        DateTime purchaseDate =
            DateTime.fromMillisecondsSinceEpoch(purchaseModel.transactionDate);
        DateTime endOfSubscription = DateTime.now();
        if (purchaseModel.productId == MONTHLY_SUBSCRIPTION) {
          endOfSubscription = purchaseDate.add(Duration(days: 30));
        } else if (purchaseModel.productId == YEARLY_SUBSCRIPTION) {
          endOfSubscription = purchaseDate.add(Duration(days: 365));
        }
        if (DateTime.now().isBefore(endOfSubscription)) {
          return true;
        } else {
          user.isVip = false;
          await updateCurrentUser(user);
          await _firestore
              .collection(SUBSCRIPTIONS)
              .doc(user.userID)
              .set({'active': false});
          return false;
        }
      } catch (e, s) {
        print('FireStoreUtils.isSubscriptionActive parse error $e $s');
        return false;
      }
    } else {
      return;
    }
  }
}
