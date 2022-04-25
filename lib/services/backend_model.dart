import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../app.dart';

abstract class BackEndModel extends ChangeNotifier {
  UserModel? currentUser;

  void updateLifeCycleState(AppLifecycleState state);

  Future<void> updateCurrentUser({UserModel? user}) async {
    currentUser = user;
  }

  Future<void> updateSubscription();

  Future<String?> loginWithFacebook();

  Future<String?> loginWithApple();

  Future<String?> loginWithEmail(
      String email, String password, Position currentLocation);

  Future<String?> loginWithPhoneNumber(String verificationID, String code,
      String phoneNumber, Position signUpLocation,
      {String firstName = 'Anonymous',
      String lastName = 'UserModel',
      File? image});

  Future<String?> firebaseSignUpWithEmailAndPassword(
      String emailAddress,
      String password,
      File? image,
      String firstName,
      String lastName,
      Position locationData,
      String mobile);

  Future<void> firebaseSubmitPhoneNumber(
      String firstName,
      String lastName,
      Position signupLocation,
      String phoneNumber,
      void Function(String verificationId) phoneCodeAutoRetrievalTimeout,
      void Function(String verificationId, int? forceResendingToken)
          phoneCodeSent,
      Future<void> Function(Exception exception) phoneVerificationFailed,
      Future<void> Function() onLogin);

  Future<void> recordPurchase(PurchaseDetails purchase);

  Stream<List<UserModel>> getTinderUsers(
      StreamController<List<UserModel>> tinderCardsStreamController);

  Future<bool> isValidUserForTinderSwipe(UserModel tinderUser, double distance);

  Future<void> matchChecker(
      BuildContext context, void Function(UserModel other) onMatch);

  Future<bool> blockUser(UserModel blockedUser, String type);

  Future<void> onSwipeLeft(UserModel dislikedUser);

  Future<UserModel?> onSwipeRight(UserModel other);

  Future<void> undo(UserModel tinderUser);

  Future<void> resetPassword(String emailAddress);

  Future<dynamic> reAuthUser(AuthProviders provider,
      {String? email,
      String? password,
      String? smsCode,
      String? verificationId,
      dynamic accessToken,
      dynamic appleCredential});

  Future<bool> incrementSwipe();

  Future<void> deleteProfilePicture();

  Future<void> updateChannel(ConversationModel conversationModel);

  Future<Url> uploadAudioFile(File file, BuildContext context);

  Future<void> sendMessage(List<UserModel> members, bool isGroup,
      MessageData message, ConversationModel conversationModel);

  Future<ChatVideoContainer> uploadChatVideoToFireStorage(
      File video, BuildContext context);

  Future<bool> createConversation(ConversationModel conversation);

  Future<String> uploadUserImageToFireStorage(File image, String userID);

  Future<ConversationModel?> getChannelByIdOrNull(String channelID);

  bool validateIfUserBlocked(String userID);

  Future<Url> uploadChatImageToFireStorage(File image, BuildContext context);

  Future<bool> leaveGroup(ConversationModel conversationModel);

  Stream<List<HomeConversationModel>> getConversations();

  Stream<UserModel> getUserByID(String id);

  Stream<ChatModel> getChatMessages(
      HomeConversationModel homeConversationModel);

  Future<List<Swipe>> getMatches();

  Future<List<UserModel>> getMatchedUserObject();

  Stream<bool> getBlocks();

  Future<void> deleteUser();

  Future<void> updateUserDetails(BuildContext context, String mobile,
      String email, Future<void> Function() onUpdate);

  static BackEndModel getBackEnd(BuildContext context) =>
      Provider.of<BackEndModel>(context, listen: false);
}
