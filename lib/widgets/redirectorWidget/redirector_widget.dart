import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
              DisplayUtils.isDarkMode(context) ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Future redirect(BuildContext context) async {
    // Mobile settings
    SharedPreferences prefs = await SharedPreferences.getInstance();

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
          // Hold a static reference to the current signed in user model.
          UserModel.currentUser = user;
          NavigationUtils.pushReplacement(context, HomeScreen(user: user));
        } else {
          NavigationUtils.pushReplacement(context, AuthScreen());
        }
      } else {
        // If firebase has not yet authenticated, redirect to auth screen
        NavigationUtils.pushReplacement(context, AuthScreen());
      }
    } else {
      // If app on boarding has not yet finished, redirect to onboarding screen
      NavigationUtils.pushReplacement(context, OnBoardingScreen());
    }
  }
}
