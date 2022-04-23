import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phitnest/models/app/app_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:phitnest/constants/constants.dart';
import 'package:phitnest/models/models.dart';
import 'package:phitnest/helpers/helpers.dart';
import 'package:phitnest/screens/screens.dart';

/// This class will route the user to the proper page when the app is loaded.
class Redirector extends StatelessWidget {
  const Redirector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This async function will route the user when on boarding is completed.
    redirect(context);
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
      // Firebase authentication user object
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        // Load user model from firestore document
        UserModel? user = await FirebaseUtils.loadUser(firebaseUser.uid);
        if (user != null) {
          // If the user was found, set their activity to active, and update
          // their activity in firestore.
          user.active = true;
          await FirebaseUtils.updateCurrentUser(user);
          // Redirect to the home screen
          return NavigationUtils.pushReplacement(
              context, HomeScreen(user: user));
        }
      }
      // If firebase has not yet authenticated or the user does not exist in
      // firestore, redirect to auth screen
      NavigationUtils.pushReplacement(context, AuthScreen());
    } else {
      // If app has not yet finished on boarding, redirect to onboarding screen
      NavigationUtils.pushReplacement(context, OnBoardingScreen());
    }
  }
}
