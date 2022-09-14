import 'package:phitnest_mobile/src/ui/screens/thankYou/thank_you.dart';

import '../ui/screens/screen.dart';

const kOnBoarding = '/onBoarding';
const kRequestLocation = '/requestLocation';
const kApology = '/apology';
const kContactUs = '/contactUs';
const kThankYou = '/thankYou';

var kRouteMap = {
  'default': (settings) => OnBoardingScreen(),
  kOnBoarding: (settings) => OnBoardingScreen(),
  kRequestLocation: (settings) => RequestLocationScreen(),
  kApology: (settings) => ApologyScreen(),
  kContactUs: (settings) => ContactUsScreen(),
  kThankYou: (settings) => ThankYouScreen(name: settings.arguments[0]),
};
