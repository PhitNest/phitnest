import 'package:flutter/material.dart';

import '../../../services/authentication_service.dart';
import '../../../constants/constants.dart';
import '../../../locator.dart';

/// This is the auth view. This is a stateless view.
class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    // Ask the authentication service if the user is authenticated, and when
    // it responds, if the user is authenticated redirect them to the home
    // route. This is the equivalent of the redirect view.
    locator<AuthenticationService>().isAuthenticated().then((authenticated) {
      if (authenticated) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      }
    });

    return Scaffold(
        body: Center(
            // This scroll view blocks render overflows when the user has the
            // keyboard open (popping back from login or signup with keyboard
            // still open)
            child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            LOGO_PATH,
            width: 150.0,
            height: 150.0,
            color: Color(COLOR_PRIMARY),
            fit: BoxFit.cover,
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
                      borderRadius: BORDER_RADIUS,
                      side: BorderSide(color: Color(COLOR_PRIMARY))),
                ),
                child: Text(
                  'Log In',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.pushNamed(context, '/login'),
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
                      borderRadius: BORDER_RADIUS,
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
                onPressed: () => Navigator.pushNamed(context, '/signUp'),
              ),
            ),
          )
        ],
      ),
    )));
  }
}
