import '../ui/screens/screen.dart';

const kOnBoarding = '/onBoarding';
const kRequestLocation = '/requestLocation';
const kApology = '/apology';

var kRouteMap = {
  'default': (settings) => OnBoardingScreen(),
  '${kOnBoarding}': (settings) => OnBoardingScreen(),
  '${kRequestLocation}': (settings) => RequestLocationScreen(),
  '${kApology}': (settings) => ApologyScreen()
};
