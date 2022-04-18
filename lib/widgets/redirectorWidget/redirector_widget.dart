import 'package:phitnest/helpers/helper.dart';
import 'package:phitnest/constants/constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:phitnest/main.dart';
import 'package:phitnest/models/user.dart';
import 'package:phitnest/screens/auth/auth_screen.dart';
import 'package:phitnest/screens/home/home_screen.dart';
import 'package:phitnest/screens/onBoarding/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Redirector extends StatelessWidget {
  const Redirector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    redirect(context);
    return Scaffold(
      backgroundColor: Color(Constants.COLOR_PRIMARY),
      body: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Color(Constants.COLOR_PRIMARY)),
          backgroundColor:
              DisplayUtils.isDarkMode(context) ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Future redirect(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool finishedOnBoarding =
        (prefs.getBool(Constants.FINISHED_ON_BOARDING) ?? false);

    if (finishedOnBoarding) {
      auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        User? user = await FirebaseUtils.getCurrentUser(firebaseUser.uid);
        if (user != null) {
          user.active = true;
          await FirebaseUtils.updateCurrentUser(user);
          PhitnestApp.currentUser = user;
          NavigationUtils.pushReplacement(context, HomeScreen(user: user));
        } else {
          NavigationUtils.pushReplacement(context, AuthScreen());
        }
      } else {
        NavigationUtils.pushReplacement(context, AuthScreen());
      }
    } else {
      NavigationUtils.pushReplacement(context, OnBoardingScreen());
    }
  }
}
