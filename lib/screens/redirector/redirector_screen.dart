import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/screen_utils.dart';
import '../../screens/screens.dart';
import '../../services/services.dart';

/// This class will route the user to the proper page when the app is loaded.
class RedirectorScreen extends StatelessWidget {
  const RedirectorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This async function will route the user when on boarding is completed.
    redirect(context);
    // Temporary loading screen
    return Scaffold(
      backgroundColor: Color(COLOR_PRIMARY),
      body: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Color(COLOR_PRIMARY)),
          backgroundColor:
              DisplayUtils.isDarkMode ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  /// Redirects the user to the correct page
  Future<void> redirect(BuildContext context) async {
    // Mobile settings
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Has this app finished on boarding
    bool finishedOnBoarding = (prefs.getBool(FINISHED_ON_BOARDING) ?? false);

    if (finishedOnBoarding) {
      final BackEndModel backEnd = BackEndModel.getBackEnd(context);

      // Try updating current user with stored firebase credentials
      if (backEnd.currentUser == null) {
        await backEnd.updateCurrentUser();
      }

      // Return to auth screen if there are no existing credentials, otherwise
      // go to home screen
      if (backEnd.currentUser != null) {
        Navigation.pushReplacement(context, HomeScreen());
      } else {
        Navigation.pushReplacement(context, AuthScreen());
      }
    } else {
      // If app has not yet finished on boarding, redirect to onboarding screen
      Navigation.pushReplacement(context, OnBoardingScreen());
    }
  }
}
