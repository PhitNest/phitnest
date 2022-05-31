import 'package:phitnest/ui/screens/models.dart';

class OnBoardingPageData {
  final String path;
  final String? text;
  final double heightFactor;

  const OnBoardingPageData({
    required this.path,
    required this.text,
    required this.heightFactor,
  });
}

class OnBoardingModel extends BaseModel {
  static const List<OnBoardingPageData> pages = [
    /// Each page has a given height factor that is fine tuned to look pretty
    OnBoardingPageData(
      path: 'assets/images/onBoarding/on_boarding_one.png',
      heightFactor: 1.75,
      text: "Welcome to phitnest",
    ),
    OnBoardingPageData(
      path: 'assets/images/onBoarding/on_boarding_two.png',
      heightFactor: 1.29,
      text: "Match with others",
    ),
    OnBoardingPageData(
      path: 'assets/images/onBoarding/on_boarding_three.png',
      heightFactor: 1.75,
      text: null,
    )
  ];
}
