import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../../config/aws.dart';
import 'secure_storage.dart';

export 'change_password/change_password.dart';
export 'confirm_email.dart';
export 'forgot_password/forgot_password.dart';
export 'login/login.dart';
export 'logout.dart';
export 'refresh_session/refresh_session.dart';
export 'register/register.dart';
export 's3.dart';
export 'secure_storage.dart';
export 'session.dart';

CognitoUserPool? _userPool;

CognitoUserPool get userPool {
  if (_userPool == null) {
    throw Exception('User pool not initialized. Call initializeAws() first.');
  }
  return _userPool!;
}

void initializeAws(bool useAdminAuth) {
  if (useAdminAuth) {
    _userPool = CognitoUserPool(
      kAdminPoolId,
      kAdminClientId,
      storage: SecureCognitoStorage(),
    );
  } else {
    _userPool = CognitoUserPool(
      kUserPoolId,
      kClientId,
      storage: SecureCognitoStorage(),
    );
  }
}
