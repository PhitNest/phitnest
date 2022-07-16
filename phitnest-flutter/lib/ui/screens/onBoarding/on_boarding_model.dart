import '../screen_model.dart';

class OnBoardingPageData {
  final String path;
  final String text;

  const OnBoardingPageData({
    required this.path,
    required this.text,
  });
}

/// Model for the on boarding screen
class OnBoardingModel extends ScreenModel {
  /// These are used to generate on boarding pages
  static const List<OnBoardingPageData> pages = [
    OnBoardingPageData(
      path: 'assets/images/onBoarding/on_boarding_one.png',
      text: "Welcome to phitnest",
    ),
    OnBoardingPageData(
      path: 'assets/images/onBoarding/on_boarding_two.png',
      text: 'Match with others',
    ),
    OnBoardingPageData(
      path: 'assets/images/onBoarding/on_boarding_three.png',
      text: 'Ready to go?',
    )
  ];
}
