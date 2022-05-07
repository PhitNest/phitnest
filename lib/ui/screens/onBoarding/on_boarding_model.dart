import 'package:flutter/material.dart';

import '../models.dart';

/// This is the view model for the onBoarding view
class OnBoardingModel extends BaseModel {
  /// Controls the page shown on the view
  final PageController pageController = PageController();

  ///list of strings containing onBoarding titles
  final List<String> _titlesList = [
    'Welcome!',
    'Private Messages',
    'Send Photos',
    'Get Notified'
  ];

  /// list of strings containing onBoarding subtitles, the small text under the
  /// title
  final List<String> _subtitlesList = [
    '',
    'Chat privately with people you match.',
    'Have fun with your matches by sending photos and videos to each other.',
    'Receive notifications when you get new messages and matches.'
  ];

  /// list containing image paths or IconData representing the image of each
  /// page
  final List<dynamic> _imageList = [
    null,
    Icons.chat_bubble_outline,
    Icons.photo_camera,
    Icons.notifications_none
  ];

  /// The current page index
  int _currentIndex = 0;

  dynamic get image => _imageList[_currentIndex];

  String get title => _titlesList[_currentIndex];

  String get subtitle => _subtitlesList[_currentIndex];

  int get numPages => _titlesList.length;

  bool get isLastPage => _currentIndex + 1 == numPages;

  /// This will rebuild the view
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
