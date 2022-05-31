import 'package:phitnest/ui/screens/models.dart';

class OnBoardingPageData {
  final String path;
  final String text;

  const OnBoardingPageData({
    required this.path,
    required this.text,
  });
}

class OnBoardingModel extends BaseModel {
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
