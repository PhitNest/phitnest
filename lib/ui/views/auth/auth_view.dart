import 'package:flutter/material.dart';

import '../../../services/authentication_service.dart';
import '../../../constants/constants.dart';
import '../../../locator.dart';

class AuthView extends StatelessWidget {
  Widget build(BuildContext context) {
    locator<AuthenticationService>().isAuthenticated().then((authenticated) {
      if (authenticated) {
        Navigator.pushNamed(context, '/home');
      }
    });

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/app_logo.png',
              width: 150.0,
              height: 150.0,
              color: Color(COLOR_PRIMARY),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 32, right: 16, bottom: 8),
            child: Text(
              'Find your soul mate',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(COLOR_PRIMARY),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            child: Text(
              'Match and chat with people you like from your area',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(COLOR_PRIMARY),
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Color(COLOR_PRIMARY))),
                ),
                child: Text(
                  'Log In',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: 40.0, left: 40.0, top: 20, bottom: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.only(top: 12, bottom: 12),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Color(COLOR_PRIMARY),
                      ),
                    ),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(COLOR_PRIMARY)),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp');
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
