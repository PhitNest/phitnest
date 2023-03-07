import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dartz/dartz.dart';
import 'package:phitnest_utils/failure.dart';
import 'package:phitnest_utils/http_adapter.dart';

import '../domain/entities/entities.dart';

Future<Either<CognitoCredentialsEntity, Failure>> getCognitoCredentials() =>
    requestJson(
      route: route,
      method: method,
      parser: parser,
      data: data,
    );

// Future<void> login(String email, String password) async {
//   final userPool =
//       CognitoUserPool('ap-southeast-1_xxxxxxxxx', 'xxxxxxxxxxxxxxxxxxxxxxxxxx');
//   final cognitoUser = CognitoUser('email@inspire.my', userPool);
//   final authDetails = AuthenticationDetails(
//     username: 'email@inspire.my',
//     password: 'Password001!',
//   );
//   CognitoUserSession session;
//   try {
//     session = await cognitoUser.authenticateUser(authDetails);
//   } on CognitoUserNewPasswordRequiredException catch (e) {
//     try {
//       if (e.requiredAttributes.isEmpty) {
//         // No attribute hast to be set
//         session =
//             await cognitoUser.sendNewPasswordRequiredAnswer("NewPassword002!");
//       } else {
//         // All attributes from the e.requiredAttributes has to be set.
//         print(e.requiredAttributes);
//         // For example obtain and set the name attribute.
//         var attributes = {"name": "Adam Kaminski"};
//         session = await cognitoUser.sendNewPasswordRequiredAnswer(
//             "NewPassword002!", attributes);
//       }
//     } on CognitoUserMfaRequiredException catch (e) {
//       // handle SMS_MFA challenge
//     } on CognitoUserSelectMfaTypeException catch (e) {
//       // handle SELECT_MFA_TYPE challenge
//     } on CognitoUserMfaSetupException catch (e) {
//       // handle MFA_SETUP challenge
//     } on CognitoUserTotpRequiredException catch (e) {
//       // handle SOFTWARE_TOKEN_MFA challenge
//     } on CognitoUserCustomChallengeException catch (e) {
//       // handle CUSTOM_CHALLENGE challenge
//     } catch (e) {
//       print(e);
//     }
//   } on CognitoUserMfaRequiredException catch (e) {
//     // handle SMS_MFA challenge
//   } on CognitoUserSelectMfaTypeException catch (e) {
//     // handle SELECT_MFA_TYPE challenge
//   } on CognitoUserMfaSetupException catch (e) {
//     // handle MFA_SETUP challenge
//   } on CognitoUserTotpRequiredException catch (e) {
//     // handle SOFTWARE_TOKEN_MFA challenge
//   } on CognitoUserCustomChallengeException catch (e) {
//     // handle CUSTOM_CHALLENGE challenge
//   } on CognitoUserConfirmationNecessaryException catch (e) {
//     // handle User Confirmation Necessary
//   } catch (e) {
//     print(e);
//   }
//   print(session.getAccessToken().getJwtToken());
// }
