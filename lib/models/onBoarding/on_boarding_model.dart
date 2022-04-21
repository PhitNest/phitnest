import 'package:flutter/material.dart';

class OnBoardingModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
