import '../ui/screens/screen.dart';

const kOnBoarding = '/onBoarding';
const kRequestLocation = '/requestLocation';
const kApology = '/apology';
const kContactUs = '/contactUs';
const kThankYou = '/thankYou';
const kFoundLocation = '/foundLocation';

var kRouteMap = {
  'default': (settings) => OnBoardingScreen(),
  kOnBoarding: (settings) => OnBoardingScreen(),
  kRequestLocation: (settings) => RequestLocationScreen(),
  kApology: (settings) => ApologyScreen(),
  kContactUs: (settings) => ContactUsScreen(),
  kThankYou: (settings) => ThankYouScreen(name: settings.arguments[0]),
  kFoundLocation: (settings) => FoundLocationScreen(gym: settings.arguments[0])
};
