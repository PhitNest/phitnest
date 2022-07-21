import 'dart:ui';

import 'package:flutter/material.dart';

// Back end
const kBackEndUrl = 'http://10.0.2.2:3000';

// App colors
const kColorPrimary = Color(0xFF4FB3AF);
const kColorAccent = Color(0xFF206D81);

const kColorButton = Color(0xFFD0E9EC);

// Device preference key
const kFinishedOnBoardingSetting = 'finishedOnBoarding';
const kRefreshTokenCache = 'refreshToken';
const kEmailCache = 'email';
const kPasswordCache = 'password';

// Database document collection indices
const kUsersPublic = 'users_public';
const kUsersPrivate = 'users_private';
const kConversations = 'conversations';
const kMessages = 'messages';
const kRelations = 'relations';

// Storage bucket paths
const kProfilePictureBucketPath = 'profilePictures';

const kDefaultAvatarUrl =
    'https://www.iosapptemplates.com/wp-content/uploads/2019/06/empty-avatar.jpg';
