import 'package:flutter/material.dart';

import 'models/models.dart';
import 'ui/screens/screen.dart';

/**
 * All screens should have their route listed here. After creating the route
 * constant here, add it to the static lookup table [kRouteMap] below.
 */
const kOnBoarding = '/onBoarding';
const kRequestLocation = '/requestLocation';
const kApology = '/apology';
const kContactUs = '/contactUs';
const kThankYou = '/thankYou';
const kFoundLocation = '/foundLocation';
const kGymSearch = '/gymSearch';

/**
 * After creating a route constant above, add an entry to [kRouteMap].
 * The key should be the route constant and the value should be a function 
 * returning a [Screen] and a parameter of type [RouteSettings].
 */
Map<String, Screen Function(RouteSettings)> kRouteMap = {
  'default': (settings) => OnBoardingScreen(),
  kOnBoarding: (settings) => OnBoardingScreen(),
  kRequestLocation: (settings) => RequestLocationScreen(),
  kApology: (settings) => ApologyScreen(),
  kContactUs: (settings) => ContactUsScreen(),
  kThankYou: (settings) => ThankYouScreen(name: settings.arguments as String),
  kFoundLocation: (settings) =>
      FoundLocationScreen(gym: settings.arguments as Gym),
  kGymSearch: (settings) => GymSearchScreen()
};
