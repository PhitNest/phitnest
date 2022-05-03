import 'package:flutter/material.dart';

import '../../base_model.dart';

class OnBoardingModel extends BaseModel {
  final PageController pageController = PageController();

  ///list of strings containing onBoarding titles
  final List<String> titlesList = [
    'Get a Date',
    'Private Messages',
    'Send Photos',
    'Get Notified'
  ];

  /// list of strings containing onBoarding subtitles, the small text under the
  /// title
  final List<String> subtitlesList = [
    'Swipe right to get a match with people you like from your area.',
    'Chat privately with people you match.',
    'Have fun with your matches by sending photos and videos to each other.',
    'Receive notifications when you get new messages and matches.'
  ];

  /// list containing image paths or IconData representing the image of each
  /// page
  final List<dynamic> imageList = [
    'assets/images/app_logo.png',
    Icons.chat_bubble_outline,
    Icons.photo_camera,
    Icons.notifications_none
  ];

  /// The current page index
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  bool get isLastPage => _currentIndex + 1 == titlesList.length;

  set currentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
